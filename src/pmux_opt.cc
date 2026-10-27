/*
 * pmux_opt - PMUX structural optimizer for Yosys.
 *
 * The pass is deliberately built from conservative, local RTLIL
 * transformations. It does not require a technology library and can be
 * inserted before an existing synthesis flow.
 */

#include "kernel/yosys.h"
#include "kernel/sigtools.h"

#include <algorithm>
#include <climits>
#include <map>
#include <tuple>
#include <vector>

USING_YOSYS_NAMESPACE
PRIVATE_NAMESPACE_BEGIN

struct PmuxOptions
{
	bool pack_chains = true;
	bool pack_parallel = true;
	bool reduce_equivalent = true;
	bool bit_plane_refactor = true;
	bool explore_structural = false;
	bool remap = false;
	bool verbose = false;
	int lut_size = 4;
	int max_cells = 200000;
	std::string abc_script;
};

struct PmuxStats
{
	int input_pmux = 0;
	int output_pmux = 0;
	int output_mux = 0;
	int removed_branches = 0;
	int merged_branches = 0;
	int indexed_bits = 0;
	int parallel_groups = 0;
	int rewrites = 0;
};

struct SelectorFacts
{
	SigSpec key;
	Const value;
};

/*
 * Recognise the two common ways one-hot select vectors reach $pmux cells:
 *
 *   S[k] = (key == constant_k)
 *
 * and wires carrying an explicit Yosys "onehot" attribute. The database is
 * intentionally syntactic. A failed query only loses an optimisation
 * opportunity; it can never make the transformation optimistic.
 */
struct OneHotDatabase
{
	Module *module;
	SigMap &sigmap;
	dict<SigBit, SelectorFacts> comparisons;

	OneHotDatabase(Module *module_, SigMap &sigmap_) : module(module_), sigmap(sigmap_)
	{
		dict<SigBit, SelectorFacts> raw;

		// Equality outputs that are used outside a PMUX are still valid
		// selector facts. The database only describes their values.
		for (auto cell : module->cells()) {
			if (cell->type != ID($eq) || cell->get_bool_attribute(ID::keep))
				continue;

			SigSpec a = sigmap(cell->getPort(ID::A));
			SigSpec b = sigmap(cell->getPort(ID::B));
			SigSpec y = sigmap(cell->getPort(ID::Y));

			if (GetSize(y) != 1 || y[0].wire == nullptr || y[0].data != State::S0)
				continue;

			if (b.is_fully_const() && !a.is_fully_const()) {
				if (!raw.count(y[0]))
					raw[y[0]] = {a, b.as_const()};
			} else if (a.is_fully_const() && !b.is_fully_const()) {
				if (!raw.count(y[0]))
					raw[y[0]] = {b, a.as_const()};
			}
		}

		comparisons = std::move(raw);
	}

	bool query(const SigSpec &select) const
	{
		bool seen_key = false;
		SigSpec key;
		pool<Const> values;
		Wire *onehot_wire = nullptr;
		bool seen_onehot_wire = false;
		bool seen_synthetic = false;

		for (auto bit : select) {
			if (bit == State::S0 || bit == State::S1 || bit == State::Sx)
				continue;

			auto it = comparisons.find(bit);
			if (it != comparisons.end()) {
				if (seen_onehot_wire)
					return false;
				if (!seen_key) {
					seen_key = true;
					key = it->second.key;
				} else if (key != it->second.key) {
					return false;
				}
				if (!values.insert(it->second.value).second)
					return false;
				seen_synthetic = true;
				continue;
			}

			if (seen_synthetic || bit.wire == nullptr ||
					!bit.wire->get_bool_attribute(ID::onehot))
				return false;

			if (!seen_onehot_wire) {
				seen_onehot_wire = true;
				onehot_wire = bit.wire;
			} else if (onehot_wire != bit.wire) {
				return false;
			}
		}

		return seen_synthetic || seen_onehot_wire;
	}
};

struct Branch
{
	SigBit select;
	SigBit data;
};

struct BitPlan
{
	SigBit default_bit;
	std::vector<std::pair<SigBit, std::vector<SigBit>>> rules;

	bool operator==(const BitPlan &other) const
	{
		return default_bit == other.default_bit && rules == other.rules;
	}
};

static SigBit make_condition(Module *module, const std::vector<SigBit> &inputs,
		dict<SigSpec, SigBit> &cache, int &new_or_cells)
{
	SigSpec group(inputs);
	if (GetSize(group) == 1)
		return group[0];

	auto it = cache.find(group);
	if (it != cache.end())
		return it->second;

	SigSpec value = module->ReduceOr(NEW_ID, group);
	SigBit bit = value[0];
	cache[group] = bit;
	new_or_cells += GetSize(group) > 1 ? 1 : 0;
	return bit;
}

struct PmuxWorker
{
	Module *module;
	SigMap sigmap;
	OneHotDatabase onehot;
	PmuxOptions options;
	PmuxStats stats;

	PmuxWorker(Module *module_, SigMap &sigmap_, const PmuxOptions &options_) :
			module(module_), sigmap(sigmap_), onehot(module_, sigmap_), options(options_)
	{
	}

	/*
	 * Merge PMUX cells that already use the same canonical select vector.
	 * A single wide decision cone is much easier for downstream mapping to
	 * share than several unrelated vector cones with identical controls.
	 */
	void pack_parallel_pmux()
	{
		if (!options.pack_parallel)
			return;

		dict<SigSpec, std::vector<Cell *>> groups;
		for (auto cell : module->selected_cells())
			if (cell->type == ID($pmux) && !cell->get_bool_attribute(ID::keep))
				groups[sigmap(cell->getPort(ID::S))].push_back(cell);

		for (auto &it : groups) {
			auto &cells = it.second;
			if (GetSize(cells) < 2)
				continue;

			int total_width = 0;
			const int select_width = GetSize(it.first);
			bool valid = true;
			for (auto cell : cells) {
				int width = cell->getParam(ID::WIDTH).as_int();
				if (width <= 0 || GetSize(cell->getPort(ID::B)) != width * select_width) {
					valid = false;
					break;
				}
				total_width += width;
			}
			if (!valid)
				continue;

			SigSpec new_a, new_b, new_y;
			for (auto cell : cells) {
				new_a.append(cell->getPort(ID::A));
				new_y.append(cell->getPort(ID::Y));
			}
			for (int rule_index = 0; rule_index < select_width; rule_index++)
				for (auto cell : cells) {
					int width = cell->getParam(ID::WIDTH).as_int();
					new_b.append(cell->getPort(ID::B).extract(rule_index * width, width));
				}

			Cell *packed = module->addCell(NEW_ID, ID($pmux));
			packed->set_src_attribute(cells.front()->get_src_attribute());
			packed->setPort(ID::A, new_a);
			packed->setPort(ID::B, new_b);
			packed->setPort(ID::S, it.first);
			packed->setPort(ID::Y, new_y);
			packed->setParam(ID::WIDTH, total_width);
			packed->setParam(ID::S_WIDTH, select_width);

			if (options.verbose)
				log("    Packed %d parallel PMUX cells in %s (%d bits, %d branches).\n",
						GetSize(cells), module->name, total_width, select_width);

			stats.parallel_groups += GetSize(cells) - 1;
			stats.rewrites++;
			for (auto cell : cells)
				module->remove(cell);
		}
	}

	/*
	 * Build one independent PMUX per group of output bits that has the same
	 * active rules. This is the main structural decomposition step.
	 *
	 * Cost model before technology mapping:
	 *   original = width * number_of_falling-edge mux stages
	 *   candidate = sum(group_width * active_rules) + OR gates
	 *
	 * A candidate is installed only when its estimated mux cone is smaller.
	 * The exact RTLIL transformation is equivalent in the 2-state domain;
	 * duplicate-data merging is additionally gated by one-hot recognition.
	 */
	bool try_bit_plane_refactor(Cell *cell)
	{
		if (cell->get_bool_attribute(ID::keep))
			return false;

		SigSpec a = sigmap(cell->getPort(ID::A));
		SigSpec b = sigmap(cell->getPort(ID::B));
		SigSpec s = sigmap(cell->getPort(ID::S));
		SigSpec y = sigmap(cell->getPort(ID::Y));

		const int width = GetSize(y);
		const int select_width = GetSize(s);
		if (width == 0 || select_width == 0 || GetSize(a) != width ||
				GetSize(b) != width * select_width)
			return false;

		const bool selectors_are_onehot = onehot.query(s);
		std::vector<BitPlan> plans;
		std::vector<std::vector<int>> plan_bits;
		pool<SigSpec> condition_groups;
		pool<SigSpec> condition_groups_multi;
		int original_active_rules = 0;
		int removed = 0;
		int merged = 0;

		for (int bit_index = 0; bit_index < width; bit_index++) {
			BitPlan plan;
			plan.default_bit = a[bit_index];

			for (int rule_index = 0; rule_index < select_width; rule_index++) {
				SigBit select = s[rule_index];
				SigBit data = b[rule_index * width + bit_index];

				if (select == State::S0 || select == State::Sx) {
					removed++;
					continue;
				}
				if (data == plan.default_bit) {
					removed++;
					continue;
				}

				auto rule_it = std::find_if(plan.rules.begin(), plan.rules.end(),
						[&](const auto &rule) { return rule.first == data; });

				if (rule_it == plan.rules.end()) {
					plan.rules.push_back({data, {select}});
				} else if (selectors_are_onehot) {
					rule_it->second.push_back(select);
					merged++;
				} else {
					// Without a one-hot proof, equal data on different
					// selectors must remain separate priority branches.
					plan.rules.push_back({data, {select}});
				}
			}

			original_active_rules += select_width;

			int plan_index = -1;
			for (int i = 0; i < GetSize(plans); i++)
				if (plans[i] == plan) {
					plan_index = i;
					break;
				}
			if (plan_index < 0) {
				plan_index = GetSize(plans);
				plans.push_back(plan);
				plan_bits.push_back({});
			}
			plan_bits[plan_index].push_back(bit_index);
		}

		int candidate_mux_cost = 0;
		for (int plan_index = 0; plan_index < GetSize(plans); plan_index++) {
			const BitPlan &plan = plans[plan_index];
			candidate_mux_cost += GetSize(plan_bits[plan_index]) * GetSize(plan.rules);
			for (auto &rule : plan.rules) {
				SigSpec group(rule.second);
				condition_groups.insert(group);
				if (GetSize(group) > 1)
					condition_groups_multi.insert(group);
			}
		}

		const int original_mux_cost = width * select_width;
		const int candidate_condition_cost = GetSize(condition_groups_multi);
		const int candidate_total = candidate_mux_cost + candidate_condition_cost;

		if (candidate_total >= original_mux_cost)
			return false;

		if (options.verbose)
			log("    Refactor %s.%s: %d branches x %d bits -> %d plans, cost %d -> %d\n",
					module->name, cell->name, select_width, width,
					GetSize(plans), original_mux_cost, candidate_total);

		dict<SigSpec, SigBit> condition_cache;
		int created_or_cells = 0;

		for (int plan_index = 0; plan_index < GetSize(plans); plan_index++) {
			const BitPlan &plan = plans[plan_index];
			const auto &bits = plan_bits[plan_index];

			SigSpec default_sig, b_sig, s_sig, y_sig;
			for (int bit_index : bits) {
				default_sig.append(plan.default_bit);
				y_sig.append(y[bit_index]);
			}

			for (auto &rule : plan.rules) {
				SigBit condition = make_condition(module, rule.second,
						condition_cache, created_or_cells);
				for (int bit_index : bits)
					b_sig.append(rule.first);
				s_sig.append(condition);
			}

			if (GetSize(s_sig) == 0) {
				module->connect(y_sig, default_sig);
				continue;
			}

			IdString type = GetSize(s_sig) == 1 ? ID($mux) : ID($pmux);
			Cell *new_cell = module->addCell(NEW_ID, type);
			new_cell->set_src_attribute(cell->get_src_attribute());
			new_cell->setPort(ID::A, default_sig);
			new_cell->setPort(ID::B, b_sig);
			new_cell->setPort(ID::S, s_sig);
			new_cell->setPort(ID::Y, y_sig);
			new_cell->setParam(ID::WIDTH, GetSize(bits));
			if (type == ID($pmux))
				new_cell->setParam(ID::S_WIDTH, GetSize(s_sig));
		}

		stats.removed_branches += removed;
		stats.merged_branches += merged;
		stats.indexed_bits += width;
		stats.output_pmux += GetSize(plans);
		stats.rewrites++;
		module->remove(cell);
		return true;
	}

	void run()
	{
		pack_parallel_pmux();

		if (!options.bit_plane_refactor)
			return;

		std::vector<Cell *> pmux_cells;
		for (auto cell : module->selected_cells())
			if (cell->type == ID($pmux) && !cell->get_bool_attribute(ID::keep))
				pmux_cells.push_back(cell);

		stats.input_pmux = GetSize(pmux_cells);
		for (auto cell : pmux_cells)
			if (module->cell(cell->name) == cell)
				try_bit_plane_refactor(cell);
	}
};

static std::string default_area_script(int lut_size)
{
	// Re-run structural hashing, don't-care minimisation and LUT mapping after
	// pmux_opt has exposed new bit-plane sharing opportunities.
	return stringf(
			"strash; &get -n; &fraig -x; &put; scorr; dc2; dretime; "
			"strash; dch -f; if -K %d -a -A 10 -F 10 -C 32; "
			"mfs2; lutpack -S 1; "
			"strash; &get -n; &fraig -x; &put; scorr; dc2; dretime; "
			"strash; dch -f; if -K %d -a -A 10 -F 10 -C 32; "
			"mfs2; lutpack -S 1",
			lut_size, lut_size);
}

static Module *clone_temp_module(Design *design, Module *module, int &temp_id)
{
	Module *clone = module->clone();
	do {
		clone->name = RTLIL::escape_id(stringf("$pmux_opt_tmp_%d", temp_id++));
	} while (design->has(clone->name));
	design->add(clone);
	return clone;
}

static void run_structural(Design *design, Module *module,
		const PmuxOptions &options, PmuxStats &stats)
{
	if (options.pack_chains)
		Pass::call_on_module(design, module, "muxpack");

	{
		SigMap sigmap(module);
		PmuxWorker worker(module, sigmap, options);
		worker.run();
		stats.input_pmux += worker.stats.input_pmux;
		stats.output_pmux += worker.stats.output_pmux;
		stats.output_mux += worker.stats.output_mux;
		stats.removed_branches += worker.stats.removed_branches;
		stats.merged_branches += worker.stats.merged_branches;
		stats.indexed_bits += worker.stats.indexed_bits;
				stats.parallel_groups += worker.stats.parallel_groups;
		stats.rewrites += worker.stats.rewrites;
	}

	if (options.reduce_equivalent)
		Pass::call_on_module(design, module, "opt_reduce -fine");
	Pass::call_on_module(design, module, "opt_clean");
}

static int map_with_custom_abc(Design *design, Module *module,
		const PmuxOptions &options)
{
	std::string script = options.abc_script.empty()
			? default_area_script(options.lut_size)
			: options.abc_script;
	Pass::call_on_module(design, module, "techmap");
	Pass::call_on_module(design, module, "opt -fast");
	Pass::call_on_module(design, module,
			{"abc", "-lut", std::to_string(options.lut_size),
			 "-script", "+" + script});
	Pass::call_on_module(design, module, "opt -fast");
	Pass::call_on_module(design, module, "opt_clean");
	return GetSize(module->cells());
}

static int map_with_default_abc(Design *design, Module *module, int lut_size)
{
	Pass::call_on_module(design, module, "techmap");
	Pass::call_on_module(design, module, "opt -fast");
	Pass::call_on_module(design, module,
			{"abc", "-lut", std::to_string(lut_size)});
	Pass::call_on_module(design, module, "opt -fast");
	Pass::call_on_module(design, module, "opt_clean");
	return GetSize(module->cells());
}

struct PmuxOptPass : public Pass
{
	PmuxOptPass() : Pass("pmux_opt", "recognise, decompose and optimise PMUX structures") { }

	void help() override
	{
		//   |---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|
		log("\n");
		log("    pmux_opt [options] [selection]\n");
		log("\n");
		log("Optimise priority multiplexer structures in RTLIL. The pass packs eligible\n");
		log("mux cascades, canonicalises one-hot $pmux cells, factors vector PMUX cones by\n");
		log("output-bit rule pattern, and runs local logic cleanup.\n");
		log("\n");
		log("    -no-pack\n");
		log("        do not run muxpack before PMUX analysis.\n");
		log("\n");
		log("    -no-parallel\n");
		log("        disable merging PMUX cells with identical select vectors.\n");
		log("\n");
		log("    -no-reduce\n");
		log("        do not run opt_reduce -fine after the structural rewrite.\n");
		log("\n");
		log("    -no-refactor\n");
		log("        pack and canonicalise PMUX cells without bit-plane splitting.\n");
		log("\n");
		log("    -explore\n");
		log("        with -abc, also try custom ABC on an unmodified clone. This can\n");
		log("        improve area further but roughly increases mapping time by 50%%.\n");
		log("\n");
		log("    -abc\n");
		log("        remap selected modules with ABC after structural optimisation.\n");
		log("\n");
		log("    -lut <n>\n");
		log("        LUT width for -abc (default: 4).\n");
		log("\n");
		log("    -abc-script <commands>\n");
		log("        override the built-in high-effort area script for -abc.\n");
		log("\n");
		log("    -max-cells <n>\n");
		log("        skip modules larger than this cell count (default: 200000).\n");
		log("\n");
		log("    -verbose\n");
		log("        print every structural candidate.\n");
		log("\n");
		log("Typical Yosys script:\n");
		log("    proc; opt -full; pmux_opt -abc -lut 4; opt -full; stat\n");
		log("\n");
	}

	void execute(std::vector<std::string> args, RTLIL::Design *design) override
	{
		PmuxOptions options;
		size_t argidx;
		for (argidx = 1; argidx < args.size(); argidx++) {
			if (args[argidx] == "-no-pack") {
				options.pack_chains = false;
				continue;
			}
			if (args[argidx] == "-no-parallel") {
				options.pack_parallel = false;
				continue;
			}
			if (args[argidx] == "-no-reduce") {
				options.reduce_equivalent = false;
				continue;
			}
			if (args[argidx] == "-no-refactor") {
				options.bit_plane_refactor = false;
				continue;
			}
			if (args[argidx] == "-no-explore") {
				options.explore_structural = false;
				continue;
			}
			if (args[argidx] == "-explore") {
				options.explore_structural = true;
				continue;
			}
			if (args[argidx] == "-abc") {
				options.remap = true;
				continue;
			}
			if (args[argidx] == "-lut" && argidx + 1 < args.size()) {
				options.lut_size = std::stoi(args[++argidx]);
				if (options.lut_size < 2 || options.lut_size > 8)
					log_cmd_error("LUT width must be in the range 2..8.\n");
				continue;
			}
			if (args[argidx] == "-abc-script" && argidx + 1 < args.size()) {
				options.abc_script = args[++argidx];
				continue;
			}
			if (args[argidx] == "-max-cells" && argidx + 1 < args.size()) {
				options.max_cells = std::stoi(args[++argidx]);
				if (options.max_cells < 1)
					log_cmd_error("-max-cells must be positive.\n");
				continue;
			}
			if (args[argidx] == "-verbose") {
				options.verbose = true;
				continue;
			}
			break;
		}
		extra_args(args, argidx, design);

		log_header(design, "Executing PMUX_OPT pass.\n");
		PmuxStats total;
		int module_count = 0;
		int skipped = 0;
		int temp_id = 0;

		std::vector<Module *> modules;
		for (auto module : design->selected_modules())
			modules.push_back(module);

		for (auto module : modules) {
			if (GetSize(module->cells()) > options.max_cells) {
				log_warning("Skipping %s: %d cells exceeds -max-cells %d.\n",
						module->name, GetSize(module->cells()), options.max_cells);
				skipped++;
				continue;
			}

			module_count++;
			if (!options.remap) {
				run_structural(design, module, options, total);
				continue;
			}

			if (module->has_processes_warn() || module->has_memories_warn()) {
				log_warning("Skipping ABC remap for %s; run proc and memory_map first.\n",
						module->name);
				run_structural(design, module, options, total);
				continue;
			}

			/*
			 * Mapping can be heuristic-sensitive. Evaluate the safe default
			 * mapping as a fallback, but never return a network with more
			 * cells than the default flow. The default command retains the
			 * structural transformations as its primary behaviour.
			 */
			IdString original_name = module->name;
			Module *reference = clone_temp_module(design, module, temp_id);
			Module *transformed = clone_temp_module(design, module, temp_id);
			run_structural(design, transformed, options, total);

			Module *plain_custom = nullptr;
			if (options.explore_structural)
				plain_custom = clone_temp_module(design, module, temp_id);

			int reference_cells = map_with_default_abc(design, reference, options.lut_size);
			int transformed_cells = map_with_custom_abc(design, transformed, options);
			int plain_custom_cells = INT_MAX;
			if (plain_custom)
				plain_custom_cells = map_with_custom_abc(design, plain_custom, options);

			Module *best = reference;
			int best_cells = reference_cells;
			const char *best_name = "default";
			if (transformed_cells < best_cells) {
				best = transformed;
				best_cells = transformed_cells;
				best_name = "structural+custom-abc";
			}
			if (plain_custom && plain_custom_cells < best_cells) {
				best = plain_custom;
				best_cells = plain_custom_cells;
				best_name = "custom-abc";
			}

			if (options.verbose)
				log("    Mapping %s: default=%d, structural+custom=%d, custom=%d; keep %s\n",
						original_name, reference_cells, transformed_cells,
						plain_custom ? plain_custom_cells : -1, best_name);

			if (reference != best)
				design->remove(reference);
			if (transformed != best)
				design->remove(transformed);
			if (plain_custom && plain_custom != best)
				design->remove(plain_custom);
			design->remove(module);
			design->rename(best, original_name);
		}

		if (skipped)
			log("Skipped %d oversized module(s).\n", skipped);
		log("PMUX_OPT: %d module(s), %d input $pmux, %d rewritten plan(s).\n",
				module_count, total.input_pmux, total.rewrites);
		log("  bit-planes=%d, removed-branches=%d, merged-branches=%d, "
				"parallel-merged=%d.\n",
				total.indexed_bits, total.removed_branches, total.merged_branches,
				total.parallel_groups);
	}
} PmuxOptPass;

PRIVATE_NAMESPACE_END
