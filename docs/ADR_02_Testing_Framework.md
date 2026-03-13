	# ADR 005: Mock 测试框架选型与 E2E 测试工具评估

## 1. 状态 (Status)
**已接受 (Accepted)**
日期：2026-03-06

## 2. 背景 (Context)
在最初架构设计阶段（见 `01_Architecture.md` v1.0），我们拟选用了 `mocktail` 作为所有单元和组件测试的 Mock 工具，并沿用 Flutter 原生的 `integration_test` 框架。
然而经人工与AI代码分析二次校验，发现：
1. `mocktail` 的最新的稳定版本已接近 20 个月未更新（截至 2026 年初，最后版本发布于 2024 年中）。
2. [@flutter-expert](../../C:/Users/Benjamin%20N/.gemini/antigravity/skills/flutter-expert/SKILL.md) 内部给出的最佳实践同时推荐了 `mockito` 和 `patrol` 测试框架。
基于这两个信息线索，为了防止测试设施引入潜在的技术债与平台兼容风险，决定对该方向进行重新研判。

## 3. 决策 (Decision)
1. **废弃 `mocktail`，改用官方维护的 `mockito`** 应对项目内所有的 Unit/Widget mock 需求。
2. **MVP 阶段（阶段一）暂缓引入 `patrol`**，继续依靠 Flutter 原生 `integration_test` 实现核心可用性覆盖；将 `patrol` 作为 Post-MVP 的技术储备（例如后期的系统通知交互、云端扫码等场景）。

## 4. 论证过程 (Rationale)

### 4.1 Mock 框架：mockito vs mocktail

| 维度 | mockito | mocktail |
|---|---|---|
| **维护方** | dart.dev (官方维护) | 社区 (felangel.dev) |
| **更新频率** | 活跃（每1-3个月） | 停滞（约20个月未更新）|
| **代码生成** | 必须 (通过 build_runner) | 无需 (基于空安全特性) |
| **项目适配** | **无额外配置负担** | 零配置优势不明显 |

**核心理由：**
由于本项目深度依赖 `freezed`、`riverpod_generator` 和 `drift_dev`，**早已引入了 `build_runner`，我们开发链路必然要经过代码生成这一环节。因此 `mocktail` 主打的“无需代码生成”在本作中提供的差异化收益被大幅削弱。** 反之，作为基础设施的测试框架，官方维护的 `mockito` 在可靠性、长期社区支持和远期升级踩坑率上具有压倒性优势。

### 4.2 集成测试：integration_test vs patrol

| 维度 | integration_test | patrol |
|---|---|---|
| **交互能力** | 仅限于 Flutter 渲染树内 | 完整支持原生弹窗、WebView、通知中心 |
| **配置复杂度** | SDK内置，零额外配置 | 需额外引入 patrol_cli 及双端 Runner 配置 |

**核心理由：**
`patrol` 是极其优秀的跨端 E2E 测试工具，能实现 Flutter 与原生 OS 层双向打通。但 OneBrew 在 **MVP 阶段（冲煮日志/豆库录入/历史数据墙）是一个典型的完全自治离线 App**。我们当前没有：
- 动态的原生权限交互（例如相册、相机扫码申请）
- 原生的系统 Notification 弹窗交互
- WebView 混合模块验证

对于像【App退到后台挂起的计时器行为】这类边界测试，我们通过模拟生命周期来覆盖即可，不值得为少量的边缘 case 而在极早期引入 Native Automator 级别的重型工具。等到未来版本若增加设备联动功能，再行平滑迁入 Patrol。

## 5. 后果 (Consequences)
**正面：**
- **稳健性提升**：核心测试依赖全部回拨到 Dart/Flutter 官方标准通道，未来架构迭代不留隐患。
- **CI 配置精简**：无须在早期即配置复杂的 patrol 运行态和 CLI 环境，利于聚焦 MVP 核心业务逻辑开发。

**负面：**
- 每次修改 Repository 接口或相关逻辑来补充 Mock 时，需要触发或持续运行一次 `dart run build_runner build -d`。不过本项目实体与状态模型修改本身也强依赖于此命令，在一致性上符合开发习惯。
