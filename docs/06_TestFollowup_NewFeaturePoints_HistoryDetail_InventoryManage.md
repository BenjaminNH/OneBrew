# OneCoffee 功能澄清文档（History 详情 + Inventory 管理）

- 文档版本: v1.0
- 日期: 2026-03-09
- 状态: 待评审
- 来源: `docs/CR_2026-03-08_FeatureGap.md` 缺口项澄清（非 CR 时效信息）
- 关联文档:
  - `docs/00_Product_Brief.md`
  - `docs/01_Architecture.md`
  - `docs/03_UI_Specification.md`
  - `docs/05_Development_Plan.md`

## 1. 文档目标
将此前未明确的两项功能补充为可开发、可测试、可验收的规格：
- 功能 A: `History` 冲泡详情查看
- 功能 B: 豆子管理与磨豆器管理

## 2. 统一约束与假设

### 2.1 约束
- 保持 MVP 原则：`Local-First`、低摩擦录入、不阻塞冲煮主流程。
- 与当前架构一致：Feature-First + Clean Architecture + Riverpod + Drift。
- 不引入云同步，主导航保留 Brew / History 并新增中间 Manage 页面。

### 2.2 假设
- 管理能力为“可选后置能力”，不得强制用户先建库存再冲煮。
- History 详情本期为只读，不在详情内编辑冲泡记录。
- Bean 重命名需要同步历史记录中的 `brewRecords.beanName`。
- Grinder 删除时应自动解除历史记录中的器具引用（`equipmentId -> null`）。
- 目标规模（MVP）：
  - 冲泡记录 <= 10,000
  - Beans <= 500
  - Grinders <= 200

## 3. 功能 A：History 冲泡详情查看

### 3.1 目标
用户可从 History 列表进入单条记录详情，查看完整参数并执行“再冲一次”。

### 3.2 用户故事
- 作为用户，我点击 History 中任一记录时，可以看到完整冲泡详情。
- 作为用户，我可以在详情中点击“再冲一次”，将参数回填到 Brew 页重新冲煮。

### 3.3 范围（In Scope）
- History 记录卡片支持点击进入详情（独立页面或底部详情弹层，项目内保持一种实现）。
- 详情展示字段覆盖：
  - 基础信息: 时间、豆子名、烘焙商、产地、烘焙度、冲煮时长、是否 Quick 模式
  - 冲煮参数: 粉量、水量、粉水比、水温、闷蒸时间、注水方式、水质、室温
  - 研磨信息: `grindMode` + 对应值（equipment/simple/pro）
  - 评价信息: quickScore、emoji、acidity/sweetness/bitterness/body、flavorNotes
  - 元信息: notes、createdAt、updatedAt
- 提供“再冲一次”操作：回填 Brew 表单，不修改历史记录本身。

### 3.4 非范围（Out of Scope）
- 详情内编辑记录（后续迭代再考虑）
- 详情内删除记录（后续迭代再考虑）
- 分享、导出、云同步

### 3.5 功能需求（FR）
- `FR-HD-01`：点击 History 记录必须可打开详情。
- `FR-HD-02`：详情加载失败时，必须有错误提示与重试动作。
- `FR-HD-03`：空值字段统一显示占位（如 `--`），不得出现 `null`。
- `FR-HD-04`：`grindMode` 展示规则必须一致：
  - `equipment`: 设备名 + click 数值 + 单位
  - `simple`: 粗细标签
  - `pro`: 微米值
- `FR-HD-05`：点击“再冲一次”后，Brew 页参数回填成功，原历史记录不变。

### 3.6 非功能需求（NFR）
- 性能: 本地详情打开目标 < 300ms。
- 可靠性: 详情查询与回填链路需有自动化测试覆盖。
- 可维护性: 保持 Domain/Data/Presentation 分层边界。
- 隐私: 仅本地读写，不新增网络传输。

### 3.7 验收标准（AC）
- `AC-HD-01`: Given 有历史记录，When 点击卡片，Then 显示对应详情。
- `AC-HD-02`: Given 记录有评分，When 打开详情，Then 快速评分和专业评分均正确展示。
- `AC-HD-03`: Given 记录无评分，When 打开详情，Then 显示“未评分”占位而非异常。
- `AC-HD-04`: Given 点击“再冲一次”，When 返回 Brew 页，Then 参数与所选记录一致。

## 4. 功能 B：豆子管理与磨豆器管理

### 4.1 目标
在不破坏“自动入库”体验前提下，提供库存数据的可视化管理与修正能力。

### 4.2 用户故事
- 作为用户，我可以管理豆子信息（新增、编辑、查看使用次数）。
- 作为用户，我可以管理磨豆器刻度配置，确保后续冲煮可复现。

### 4.3 范围（In Scope）
- 新增 Inventory 管理界面（建议单页双 Tab）：
  - Beans 管理
  - Grinders 管理（仅 `isGrinder=true`）
- Beans 管理能力：
  - 列表/搜索/新增/编辑（name、roaster、origin、roastLevel）
  - 展示 useCount、addedAt
- Grinders 管理能力：
  - 列表/搜索/新增/编辑（name、grindMinClick、grindMaxClick、grindClickStep、grindClickUnit）
  - 展示 useCount、addedAt
- 入口要求：
  - Inventory Manage 为底部导航独立页面
  - 底部导航顺序固定为：Brew -> Manage -> History

### 4.4 非范围（Out of Scope）
- Bean 合并（merge duplicates）
- 软删除/归档机制
- 全量 Equipment 管理（本期仅 Bean + Grinder）

### 4.5 功能需求（FR）
- `FR-IM-01`：管理能力不得阻塞冲煮主流程。
- `FR-IM-02`：Beans 默认排序：`useCount desc, addedAt desc`。
- `FR-IM-03`：Grinders 默认排序：`useCount desc, addedAt desc`。
- `FR-IM-04`：Bean 重命名必须校验唯一性，并事务化同步 `brewRecords.beanName`。
- `FR-IM-05`：Grinder 参数校验：
  - `grindMinClick < grindMaxClick`
  - `grindClickStep > 0`
  - `(max-min)/step` 必须处于合理范围（防止极端分段）
- `FR-IM-06`：删除规则：Bean 删除不应影响历史记录（历史中的 `beanName` 作为快照保留）；Grinder 若有历史引用则软删除（保留历史可见且不清理 `equipmentId`），无历史引用则硬删除
- `FR-IM-07`：保存后自动补全候选应同会话即时生效。

### 4.6 非功能需求（NFR）
- 性能: 500 Beans / 200 Grinders 下首屏加载目标 < 300ms。
- 可靠性: 重命名联动更新必须事务化，避免部分成功。
- 可维护性: 管理逻辑经 Repository/UseCase 下沉，避免 Presentation 直接拼 SQL。
- 可测试性: CRUD、校验、重命名联动、删除解关联必须有自动化测试。

### 4.7 验收标准（AC）
- `AC-IM-01`: Given 新建 Bean/Grinder，When 保存成功，Then Brew 自动补全可立即检索到。
- `AC-IM-02`: Given Bean 被历史记录引用，When 删除，Then 删除成功且历史展示保持原 beanName。
- `AC-IM-03`: Given Grinder 被历史记录引用，When 删除，Then 删除成功且历史详情仍显示该设备。
- `AC-IM-04`: Given Bean 重命名成功，When 查看历史详情，Then 相关记录名称一致更新。
- `AC-IM-05`: Given Grinder 配置非法，When 保存，Then 阻止提交并显示校验错误。

## 5. 决策记录

| ID | 决策 | 备选 | 结论理由 |
|---|---|---|---|
| D-01 | History 详情能力纳入 MVP 补齐项 | 仅保留列表摘要 | 摘要不足以支持复盘和复现 |
| D-02 | 管理能力先聚焦 Bean + Grinder | 扩展到所有 Equipment | 当前问题集中于 Bean/Grinder，先收敛 |
| D-03 | 管理功能为可选后置能力 | 强制先建库存 | 与“无摩擦录入”原则冲突 |
| D-04 | 详情本期只读 | 详情直接可编辑 | 控制复杂度，先保证查询与复用链路闭环 |

## 6. 对开发计划的映射建议
- 在 `docs/05_Development_Plan.md` 增加：
  - `Phase 3A`: Inventory Manage（Bean/Grinder 管理页 + 校验 + 删除解关联 + 事务）
  - `Phase 6A`: History Detail（详情聚合查询 + UI + 再冲一次回填）
- 在 `docs/01_Architecture.md` 补充：
  - `HistoryDetail` 对应实体/用例描述
  - Bean 重命名联动、删除解关联的业务规则说明
