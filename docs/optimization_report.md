# PMUX 优化算法测试集报告

日期：2026-10-26

## 1. 结论

以原始 Yosys 默认综合流程 `synth` 为基线，附件四个测试用例的单元总数
由 **1220** 降至 **869**，减少 **28.8%**，满足赛题要求的最低 10%，
并高于 20% 的面积优化目标。

| 用例 | 默认 `synth` | PMUX 优化流程 | 减少 |
|---|---:|---:|---:|
| test1 | 1047 | 767 | 26.7% |
| test2 | 26 | 15 | 42.3% |
| test3 | 58 | 48 | 17.2% |
| test4 | 89 | 39 | 56.2% |
| 合计 | 1220 | 869 | 28.8% |

四个用例均通过形式等价检查。

## 2. 测试环境

| 项目 | 配置 |
|---|---|
| Yosys | 0.70+post |
| 编译器 | MSVC 19.44 / x64 |
| ABC | Yosys 源码随附版本 |
| 优化映射 | 4 输入 LUT |
| 等价检查 | `equiv_make/equiv_simple/equiv_induct` |
| 输入 | `pmux_case(1).rar` 中的 `test1` 至 `test4` |

## 3. 对照流程

基线使用原始 Yosys 默认流程：

```yosys
read_verilog testN.v
synth -top testN
stat
```

优化流程：

```yosys
read_verilog testN.v
synth -top testN -run begin:fine
opt -fast -full
memory_map
opt -full
pmux_opt -abc -lut 4
opt -fast
stat
```

统计对象为网表中全部 cell，包括 LUT、触发器、MUX 和内存映射后单元。
未使用空模块、黑盒或未展开内存冒充面积结果。

## 4. 算法实现

### 4.1 选择信号规范化

使用 `SigMap` 合并线网别名，消除常量选择位，并让后续比较使用同一
canonical signal。

### 4.2 严格一热识别

仅接受以下两类证明：

1. 同一基向量的 `$eq` 结果，且比较常量互不相同；
2. 选择线属于 Yosys 显式标记的 `onehot` wire。

无法证明时不做可能改变多选一语义的重复分支合并。

### 4.3 同选择向量 PMUX 合并

对选择向量完全相同的多个 `$pmux` 单元，将默认值和每个分支的数据切片
拼接，重构为一个宽 PMUX。该变换不改变分支顺序，因此保留优先级。

### 4.4 位平面规则分解

对每个输出位建立“默认值 + 有效分支”规则序列：

- 删除选择恒为 0、恒为未定义或数据等于默认值的分支；
- 在严格一热条件下合并相同数据对应的控制位；
- 根据 `宽度 x 有效分支数 + 控制 OR 代价` 决定是否拆分；
- 合并规则完全相同的输出位，避免重复 PMUX 锥。

### 4.5 技术分解与 ABC 面积映射

优化后的 PMUX 锥先经 `techmap` 分解为标准组合单元，再由 ABC 执行：

- AIG 结构散列与功能约简；
- 两轮 area recovery；
- LUT4 映射；
- `mfs2` 和 `lutpack`。

ABC 运行两轮并保留较小结果，避免单轮启发式造成面积回退。

### 4.6 安全回退

`-abc` 将默认映射和优化映射放在独立模块副本中执行。至少保留一个
使用默认 ABC 脚本的候选，最终采用单元数更少的网表，防止启发式映射
在个别电路上增加面积。

## 5. 等价性验证

附件四个用例均采用以下流程：

1. 对原始 RTL 执行 `prep`，保存 gold；
2. 执行优化和 LUT4 映射，保存 gate；
3. 执行 `equiv_make`；
4. 对时序边界执行 `async2sync`；
5. 对 ROM 执行 `memory_map`；
6. 执行 `equiv_simple` 和 `equiv_induct`；
7. 使用 `equiv_status -assert` 自动判定。

| 用例 | 性质 | 等价结果 |
|---|---|---|
| test1 | 状态机与多周期数据通路 | 通过 |
| test2 | 组合优先级 PMUX | 通过 |
| test3 | 串行移位和状态保持 | 通过 |
| test4 | 时序 ROM/PMUX 查找表 | 通过 |

## 6. 运行效率

参数化压力电路：

- 44 条并行 PMUX 数据通路；
- 每路 16 个分支、32 bit 数据；
- 优化前 coarse 网表 984 个单元；
- LUT4 映射。

| 指标 | 实测 | 限制 |
|---|---:|---:|
| 完整优化耗时 | 28.98 s | <= 60 s |
| 峰值内存 | 225.9 MiB | <= 2 GiB |
| 等价性 | 通过 | 必须通过 |

完整三候选探索模式耗时约 62.5 s，因此默认关闭额外候选；
`-explore` 作为可选的高质量模式保留。默认模式在本压力用例上满足
时间与内存要求。

## 7. 复现

```powershell
pwsh scripts/build.ps1 -YosysBuildDir C:\work\yosys\build
pwsh tests/run_competition.ps1 `
  -Yosys C:\work\yosys\build\yosys.exe `
  -Plugin C:\work\pmux-opt\build\pmux_opt.dll `
  -Lut 4
```

等价性：

```powershell
pwsh scripts/verify.ps1 `
  -Yosys C:\work\yosys\build\yosys.exe `
  -Plugin C:\work\pmux-opt\build\pmux_opt.dll
```

结果数据：`docs/competition_results_lut4.csv`、`docs/performance.csv`。

## 8. 适用范围

本报告的基线严格指 Yosys 默认 `synth` 流程。若评测方强制基线也为
LUT4，则触发器数量较多的 `test1/test3` 会稀释总单元降幅，不能直接
引用本报告的 28.8%。这一点应在提交文档中明确，避免将不同映射口径
混用。
