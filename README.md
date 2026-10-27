# PMUX 结构优化器

完整安装、构建、Tcl/Python 调用、面积复现和故障排查见
[docs/USAGE_GUIDE.md](docs/USAGE_GUIDE.md)。

本工程实现 Yosys 自定义 Pass `pmux_opt`，用于识别 `$mux/$pmux`
结构、合并共享选择信号的多路选择器、按输出位规则重建 PMUX 锥，并在
需要时执行 ABC 面积映射。所有结构变换都通过 Yosys SAT 等价性检查。

## 功能

- `pmux_opt [selection]`：一条自定义命令完成 PMUX 识别、拆解与重构。
- 识别同一选择向量上的并行 PMUX，并合并为一个宽决策锥。
- 基于 `$eq` 常量比较和 `onehot` 属性识别一热选择信号。
- 按输出位分支模式做位平面分解，消除无作用分支并合并等价分支。
- `-abc` 模式执行多轮 ABC 面积优化，并在多个候选映射间择优。
- 通过 `keep`、`proc/memory` 状态检查及保守一热证明避免不安全变换。

## 构建

Linux 动态插件：

```bash
make
make test
```

或使用 CMake：

```bash
cmake -S . -B build \
  -DYOSYS_BUILD_DIR=/path/to/yosys/build \
  -DYOSYS_LIBRARY=/path/to/yosys/build/libyosys.so
cmake --build build
```

若目标 Yosys 不方便加载动态插件，可将 `src/pmux_opt.cc` 放入
`passes/opt/`，并在 `passes/opt/CMakeLists.txt` 中加入：

```cmake
yosys_pass(pmux_opt
    pmux_opt.cc
)
```

本项目在 Yosys 0.70、MSVC 19.44、Windows x64 下完成了源码集成编译和测试。

### Windows 已配置运行

本工程已在 `tools/yosys/` 中保存可运行的 Yosys 0.70（含集成
`pmux_opt`、ABC、`share` 和运行库）。无需额外配置 `PATH`：

```powershell
pwsh scripts/run-project.ps1 -Action verify
pwsh scripts/run-project.ps1 -Action benchmark -Lut 4
pwsh scripts/run-project.ps1 -Action stress -Lut 4
```

也可以直接调用 `tools/yosys/yosys.exe -p "help pmux_opt"`。

## 使用

推荐先完成 Yosys 的 coarse 阶段，再执行优化：

```yosys
read_verilog design.v
synth -top top -lut 4 -run begin:fine
pmux_opt -abc -lut 4
opt -fast
stat
```

如果只使用结构变换，让后续原始综合流程负责映射：

```yosys
read_verilog design.v
synth -top top -lut 4 -run begin:fine
pmux_opt
synth -top top -lut 4 -run fine:
opt -fast
stat
```

常用选项：

```text
-abc             执行自定义 ABC 面积映射
-lut <n>          ABC LUT 宽度，默认 4
-no-refactor      禁用位平面拆分
-no-parallel      禁用同选择向量 PMUX 合并
-no-pack          禁用 muxpack
-explore          额外尝试无结构改写候选，耗时约增加 50%
-max-cells <n>    跳过超大模块
```

## 验证

```powershell
pwsh scripts/verify.ps1 -Yosys C:\path\to\yosys.exe -Plugin C:\path\to\pmux_opt.dll
```

测试内容包括：

- 单级 PMUX；
- 混合组合逻辑 PMUX；
- 位平面差异明显的 PMUX；
- 多分支高宽度压力用例；
- 赛题附件中的 `test1` 至 `test4`。

求解器使用 `equiv_make`、`equiv_simple`、`equiv_induct` 和
`equiv_status -assert`。附件测试集全部通过形式等价检查。

## 测试集结果

详细报告见 [optimization_report.md](docs/optimization_report.md)。

核心结论：

- 以原始 Yosys 默认 `synth` 流程为基线，附件的四个用例合计从
  1220 个单元降至 869 个单元，减少 28.8%。
- `test1/test2/test3/test4` 分别减少 26.7%、42.3%、17.2% 和 56.2%。
- 附件测试集全部通过形式等价检查。
- 参数化压力电路（优化前 coarse 网表 984 个单元）实测
  优化耗时 28.98 s，峰值内存 225.9 MiB，满足 60 s / 2 GiB 限制。
