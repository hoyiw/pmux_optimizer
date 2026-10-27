# pmux_opt 完整使用教程

本文对应 `pmux_opt` Yosys 插件工程。命令名和可执行文件名均为
`pmux_opt`。

## 1. 功能与适用阶段

`pmux_opt` 在 Yosys RTLIL 网表阶段工作，完成以下处理：

1. 识别 `$mux` 级联和 `$pmux`；
2. 识别同选择向量的并行 PMUX；
3. 删除无作用分支；
4. 在严格证明一热语义后，合并相同数据的分支；
5. 按输出位规则拆分或合并 PMUX 锥；
6. 在 `-abc` 模式下执行 ABC 面积映射。

推荐调用位置：

```text
read_verilog -> proc -> coarse optimization -> pmux_opt -> technology mapping
```

不要在已经完成 LUT/标准单元映射的网表上期待它还能找到 `$pmux`。

## 2. 目录结构

```text
pmux-opt/
├── CMakeLists.txt                 # 动态插件构建
├── Makefile                       # Linux/macOS yosys-config 构建
├── README.md
├── docs/
│   ├── USAGE_GUIDE.md
│   ├── optimization_report.md
│   ├── competition_results_lut4.csv
│   └── performance.csv
├── scripts/
│   ├── build.ps1                  # Windows 构建辅助
│   ├── benchmark.ps1              # 单用例面积对照
│   ├── verify.ps1                 # 全部等价性检查
│   └── gen_stress.py              # 压力测试电路生成器
├── src/
│   └── pmux_opt.cc                # Pass 实现
└── tests/
    ├── equivalence.ys
    ├── equivalence_mapped.ys
    ├── competition_equivalence.ys
    ├── run_competition.ps1
    ├── competition_case/
    └── verilog/
```

## 3. 环境要求

- Yosys 0.70 或 API 兼容版本；
- C++20 编译器；
- CMake 3.20 或更新版本；
- 可用的 ABC 后端；
- Linux/macOS 动态插件方式需要编译器支持共享库；
- Windows 推荐将源码编入 Yosys，不建议依赖无法解析的 Windows DLL 导入表。

最好使用与插件相同版本的 Yosys 源码构建产物。不要将不同 Yosys 版本编译
出的插件和主程序混用。

Ubuntu/Debian 可安装：

```bash
sudo apt update
sudo apt install -y build-essential cmake ninja-build bison flex \
  libreadline-dev tcl-dev zlib1g-dev
```

## 4. 构建 Yosys

插件通常应针对 Yosys 的本地构建目录编译：

```bash
git clone --recursive https://github.com/YosysHQ/yosys.git
cd yosys
git checkout v0.70

cmake -S . -B build -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DYOSYS_WITH_TCL=ON
cmake --build build -j

./build/yosys -V
./build/yosys-abc -c "quit"
```

如果系统有独立的 `yosys` 和 `yosys-abc`，请确认它们 ABI 匹配，并使用对应
的 `yosys-config` 构建插件。

## 5. 构建插件

### 5.1 Linux/macOS：动态插件

进入 `pmux-opt` 目录：

```bash
make YOSYS_CONFIG=/path/to/yosys/build/yosys-config
```

生成：

```text
build/pmux_opt.so
```

也可使用 CMake：

```bash
cmake -S . -B build \
  -DYOSYS_BUILD_DIR=/path/to/yosys/build \
  -DCMAKE_BUILD_TYPE=Release
cmake --build build -j
```

加载测试：

```bash
/path/to/yosys/build/yosys \
  -m "$PWD/build/pmux_opt.so" \
  -p "help pmux_opt"
```

看到 `pmux_opt [options] [selection]` 即加载成功。

macOS 插件后缀通常为 `.dylib`；Linux 为 `.so`。

### 5.2 Windows 或静态集成

Windows 下建议把 Pass 编入 Yosys 主程序：

1. 将 `src/pmux_opt.cc` 复制到：

```text
<yosys>/passes/opt/pmux_opt.cc
```

2. 在 `<yosys>/passes/opt/CMakeLists.txt` 的 Pass 列表中增加：

```cmake
yosys_pass(pmux_opt
    pmux_opt.cc
)
```

3. 重新构建：

```powershell
cmake --build <yosys-build-dir> --target yosys -j 2
```

4. 不再需要 `-m`，直接运行：

```powershell
& C:\path\to\yosys.exe -p "help pmux_opt"
```

本工程的实际 Windows 验证采用这种静态集成方式，工具链为
MSVC 19.44、Yosys 0.70。

## 6. 最简使用

动态插件：

```bash
yosys -m /absolute/path/pmux_opt.so \
  -p "read_verilog design.v; synth -top top -lut 4 -run begin:fine; pmux_opt; stat"
```

静态集成：

```bash
yosys \
  -p "read_verilog design.v; synth -top top -lut 4 -run begin:fine; pmux_opt; stat"
```

## 7. 推荐面积优化脚本

新建 `optimize.ys`：

```yosys
read_verilog -sv design.sv
synth -top top -run begin:fine
opt -fast -full
memory_map
opt -full
pmux_opt -abc -lut 4
opt -fast
stat
write_verilog -noattr optimized.v
```

运行：

```bash
yosys -m /absolute/path/pmux_opt.so -s optimize.ys
```

这条流程与原版 Yosys 默认 `synth` 的对照关系已写入
`docs/optimization_report.md`。

如果只希望执行结构变换，并由后续原始 `synth` 完成技术映射：

```yosys
read_verilog -sv design.sv
synth -top top -run begin:fine
pmux_opt
synth -top top -run fine:
opt -fast
stat
```

## 8. Tcl 调用

Yosys 的 Tcl 接口用 `yosys <command>` 转发 Pass。新建 `optimize.tcl`：

```tcl
yosys read_verilog -sv design.sv
yosys synth -top top -run begin:fine
yosys opt -fast -full
yosys memory_map
yosys opt -full
yosys pmux_opt -abc -lut 4
yosys opt -fast
yosys stat
yosys write_verilog -noattr optimized.v
```

运行：

```bash
yosys -m /absolute/path/pmux_opt.so -c optimize.tcl
```

如果 Yosys 已静态集成插件，去掉 `-m ...` 即可。

## 9. Python/Pyosys 调用

若 Yosys 构建启用了 Pyosys，并且插件已经静态编入或由启动环境加载：

```python
import pyosys

pyosys.run_pass("read_verilog -sv design.sv")
pyosys.run_pass("synth -top top -run begin:fine")
pyosys.run_pass("opt -fast -full")
pyosys.run_pass("memory_map")
pyosys.run_pass("opt -full")
pyosys.run_pass("pmux_opt -abc -lut 4")
pyosys.run_pass("opt -fast")
pyosys.run_pass("stat")
```

动态插件的路径和 Pyosys 构建方式有关；比赛提交建议优先使用 `.ys` 或
静态集成，减少运行环境差异。

## 10. 命令参数

| 参数 | 说明 |
|---|---|
| `-abc` | 结构优化后执行 ABC 面积映射 |
| `-lut <n>` | ABC 目标 LUT 输入数，默认 4 |
| `-abc-script <commands>` | 覆盖内置 ABC 脚本 |
| `-no-pack` | 不先执行 `muxpack` |
| `-no-parallel` | 不合并同选择向量的 PMUX |
| `-no-refactor` | 不做逐输出位规则拆分 |
| `-no-reduce` | 不执行后续 `opt_reduce -fine` |
| `-explore` | 额外尝试一个 ABC 候选，耗时更高 |
| `-max-cells <n>` | 跳过超过 n 个单元的模块，默认 200000 |
| `-verbose` | 输出每个已重构 PMUX 的细节 |

推荐先使用默认参数，确认正确性和耗时后，再根据面积需要开启
`-explore`。`-explore` 不能用于接近 60 秒上限的设计。

## 11. Yosys 选择器

Pass 遵循 Yosys 当前 selection。例如只处理一个模块：

```yosys
select -module top
pmux_opt -abc -lut 4
select -clear
```

也可以在命令后直接给选择表达式：

```yosys
pmux_opt -abc -lut 4 top
```

只有被选中的 module/cell 会参与优化。

## 12. 面积对照

标准基线：

```bash
yosys -p "read_verilog test.v; synth -top test; stat"
```

优化候选：

```bash
yosys -m pmux_opt.so -p "\
read_verilog test.v;\
synth -top test -run begin:fine;\
opt -fast -full;\
memory_map;\
opt -full;\
pmux_opt -abc -lut 4;\
opt -fast;\
stat"
```

查看最终 `stat` 中的：

```text
<N> cells
```

不要手工排除未映射 memory、黑盒或其他单元；否则会高估面积收益。

## 13. 批量测量附件测试集

Windows PowerShell：

```powershell
pwsh tests/run_competition.ps1 `
  -Yosys C:\path\to\yosys.exe `
  -Plugin C:\path\to\pmux_opt.dll `
  -Lut 4
```

静态集成构建时省略 `-Plugin`：

```powershell
pwsh tests/run_competition.ps1 `
  -Yosys C:\path\to\yosys.exe `
  -Lut 4
```

结果写入：

```text
build/competition_results.csv
```

附件测试集的实测结果：

| 用例 | 默认 `synth` | 优化后 | 缩减 |
|---|---:|---:|---:|
| test1 | 1047 | 767 | 26.7% |
| test2 | 26 | 15 | 42.3% |
| test3 | 58 | 48 | 17.2% |
| test4 | 89 | 39 | 56.2% |
| 合计 | 1220 | 869 | 28.8% |

## 14. 形式等价检查

运行全部检查：

```powershell
pwsh scripts/verify.ps1 `
  -Yosys C:\path\to\yosys.exe `
  -Plugin C:\path\to\pmux_opt.dll
```

或静态集成：

```powershell
pwsh scripts/verify.ps1 -Yosys C:\path\to\yosys.exe
```

包括：

- `tests/equivalence.ys`：PMUX 结构级等价；
- `tests/equivalence_mapped.ys`：完整优化与 LUT 映射等价；
- `tests/competition_equivalence.ys`：附件四个用例等价。

时序设计使用 `async2sync`、`memory_map`、`equiv_simple` 和
`equiv_induct`。命令失败会返回非零退出码。

## 15. 运行压力测试

生成接近 1000 coarse 单元的 PMUX 电路：

```bash
python scripts/gen_stress.py build/pmux_stress.v \
  --lanes 44 --branches 16 --width 32
```

执行面积优化：

```bash
yosys -m build/pmux_opt.so -p "\
read_verilog -sv build/pmux_stress.v;\
synth -top pmux_stress -run begin:fine;\
opt -fast -full;\
memory_map;\
opt -full;\
pmux_opt -abc -lut 4;\
opt -fast;\
stat"
```

当前 Windows 验证结果：

- coarse 单元数：984；
- 耗时：28.98 秒；
- 峰值内存：225.9 MiB。

## 16. 常见问题

### 16.1 `No such command: pmux_opt`

原因通常是插件没有加载，或插件与 Yosys ABI 不匹配。

检查：

```bash
yosys -m /absolute/path/pmux_opt.so -p "help pmux_opt"
```

应使用与插件完全相同的 Yosys 源码/构建目录。

### 16.2 Windows 无法链接插件

如果缺少 `libyosys.lib`，优先采用第 5.2 节的静态集成方式。不要链接
其他版本的 Yosys 主程序。

### 16.3 ABC 报错 `pthreadVC2.dll` 缺失

将对应架构的 `pthreadVC2.dll` 放到 `yosys-abc.exe` 同目录，并确保
主程序能找到正确的 `yosys-abc.exe`。

### 16.4 提示含 process 或 memory

先执行：

```yosys
proc
memory_map
opt -full
```

如果只做结构分析，run `proc` 后调用 `pmux_opt`；`-abc` 模式要求模块
没有未映射 memory。

### 16.5 面积没有下降

检查：

- 是否在技术映射前调用；
- 是否使用了正确的 `begin:fine` 分段；
- 输入是否真的包含 `$pmux`/选择树；
- 是否被 `keep` 属性保护；
- 是否使用了不匹配的 LUT 宽度。

可用 `pmux_opt -verbose` 查看识别和改写细节。

### 16.6 运行超过 60 秒

移除 `-explore`，降低并发候选数量；对超大模块设置 `-max-cells`；或先
用 `hierarchy`/`flatten` 控制设计规模。默认模式已关闭额外候选。

## 17. 推荐提交方式

比赛现场建议：

1. 使用 Linux 构建静态集成或 `.so` 插件；
2. 固定 Yosys 版本和 ABC 路径；
3. 使用 `.ys` 脚本复现基线、优化和 `stat`；
4. 对四个官方测试用例运行形式等价；
5. 保存 `stat` 原始日志和 CSV；
6. 报告目标 LUT 架构与 cell 统计口径；
7. 不以未映射 memory 或黑盒单元计入最终面积。

