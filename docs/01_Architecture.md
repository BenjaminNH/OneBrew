# OneBrew — 项目架构设计文档

> **版本**: v1.1 · **日期**: 2026-03-06 · **状态**: MVP 架构方案 · **变更**: 数据库选型由 Isar 改为 Drift ([ADR_01](./ADR_01_Database_Selection.md))

---

## 1. 架构总览

### 1.1 设计哲学

基于 Product Brief 的核心诉求——**"优雅、丝滑、无压迫感"**，本架构遵循以下设计原则：

| 原则 | 描述 |
|---|---|
| **Local-First** | 纯本地离线优先，零云端依赖，秒级响应 |
| **Clean Architecture** | 关注点分离，三层架构（Presentation → Domain → Data） |
| **Feature-First** | 按功能模块组织代码，非按技术类型分桶 |
| **Progressive Complexity** | UI 与数据模型均支持渐进式展开，入门极简、进阶丰富 |
| **Testability** | 每一层均可独立测试，满足 OKR 中 90%+ 覆盖率要求 |

### 1.2 技术栈确认

| 层级 | 技术选型 | 理由 |
|---|---|---|
| **框架** | Flutter 3.x | 跨平台，初期主攻 Android |
| **语言** | Dart 3.x | 空安全、pattern matching |
| **本地数据库** | Drift (基于 SQLite) | 类型安全 ORM，Reactive Stream，编译时 SQL 校验 ([ADR_01](./ADR_01_Database_Selection.md)) |
| **状态管理** | Riverpod 2.x | 编译时安全、可测试、支持 code generation |
| **路由** | GoRouter | 声明式路由，Deep Link 支持 |
| **DI/Service Locator** | Riverpod (自带) | 无需额外 DI 框架 |
| **代码生成** | build_runner + freezed | 不可变模型、JSON 序列化 |
| **测试** | flutter_test + integration_test | Widget/Unit/Integration 覆盖 |
| **CI/CD** | GitHub Actions | 自动化构建 APK |

### 1.3 架构图 (C4-Component 级别)

```
┌─────────────────────────────────────────────────────┐
│               🎨 Presentation Layer                 │
│  ┌──────────┐  ┌──────────────┐  ┌───────────────┐  │
│  │  Pages   │  │   Widgets    │  │  Controllers  │  │
│  │ (Screens)│  │ (Reusable)   │  │  (Riverpod    │  │
│  │          │  │              │  │   Notifiers)  │  │
│  └────┬─────┘  └──────────────┘  └───────┬───────┘  │
│       │                                  │          │
└───────│──────────────────────────────────│──────────┘
        │                                  │
        │         ┌────────────┐           │
        └────────►│  Use Cases │◄──────────┘
                  └─────┬──────┘
                        │
┌───────────────────────│─────────────────────────────┐
│               ⚙️ Domain Layer                       │
│  ┌──────────┐  ┌──────┴──────┐  ┌────────────────┐  │
│  │ Entities │  │  Use Cases  │  │  Repository    │  │
│  │(Brew,Bean│  │(CRUD, Query)│  │  Interfaces    │  │
│  │Equipment)│  │             │  │                │  │
│  └──────────┘  └─────────────┘  └───────┬────────┘  │
│                                         │           │
└─────────────────────────────────────────│───────────┘
                              implements  │
                                 ┌────────┘
                                 ▼
┌────────────────────────────────────────────────────┐
│               💾 Data Layer                         │
│  ┌──────────────┐  ┌──────────────┐  ┌───────────┐ │
│  │  Repository   │  │ Local Data   │  │   Data    │ │
│  │  Implements   │  │ Sources      │  │  Models   │ │
│  │               │  │ (Drift)      │  │  (Table)  │ │

│  └───────────────┘  └──────────────┘  └───────────┘ │
└────────────────────────────────────────────────────┘
```

---

## 2. 项目目录结构

```
onecoffee/
├── android/                          # Android 原生配置
├── ios/                              # iOS 原生配置 (预留)
├── lib/
│   ├── main.dart                     # 应用入口
│   ├── app.dart                      # MaterialApp / GoRouter 配置
│   │
│   ├── core/                         # 🔧 核心基础设施 (跨功能共享)
│   │   ├── constants/
│   │   │   ├── app_colors.dart       # 色彩系统
│   │   │   ├── app_text_styles.dart  # 排版系统
│   │   │   ├── app_spacing.dart      # 间距 & 尺寸 tokens
│   │   │   └── app_durations.dart    # 动画时长常量
│   │   ├── theme/
│   │   │   ├── app_theme.dart        # ThemeData 组装
│   │   │   └── dark_theme.dart       # 暗色主题
│   │   ├── router/
│   │   │   └── app_router.dart       # GoRouter 路由表
│   │   ├── database/
│   │   │   └── drift_database.dart   # Drift 数据库定义 & Provider
│   │   ├── utils/
│   │   │   ├── date_utils.dart       # 日期格式化
│   │   │   ├── timer_utils.dart      # 计时器辅助
│   │   │   └── extensions.dart       # Dart 扩展方法
│   │   └── widgets/                  # 全局通用 Widget
│   │       ├── app_card.dart         # 统一卡片组件
│   │       ├── app_slider.dart       # 自定义滑块 (用于评分)
│   │       ├── app_chip_input.dart   # 标签输入组件 (智能补全)
│   │       ├── app_timer_display.dart# 计时器显示组件
│   │       └── progressive_expand.dart # 渐进式展开容器
│   │
│   ├── features/                     # 📦 功能模块 (Feature-First)
│   │   │
│   │   ├── brew_logger/              # ☕ 极简心流记录器
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── brew_record.dart       # 冲煮记录实体
│   │   │   │   ├── repositories/
│   │   │   │   │   └── brew_repository.dart    # 仓库接口
│   │   │   │   └── usecases/
│   │   │   │       ├── create_brew_record.dart # 创建记录
│   │   │   │       ├── update_brew_record.dart # 更新记录
│   │   │   │       └── delete_brew_record.dart # 删除记录
│   │   │   ├── data/
│   │   │   │   ├── models/
│   │   │   │   │   └── brew_record_model.dart  # Drift Table 定义
│   │   │   │   ├── datasources/
│   │   │   │   │   └── brew_local_datasource.dart
│   │   │   │   └── repositories/
│   │   │   │       └── brew_repository_impl.dart
│   │   │   └── presentation/
│   │   │       ├── pages/
│   │   │       │   └── brew_logger_page.dart   # 记录器主页面
│   │   │       ├── widgets/
│   │   │       │   ├── brew_timer_widget.dart   # 正/倒计时器
│   │   │       │   ├── param_input_section.dart # 参数输入区 (渐进展开)
│   │   │       │   ├── quick_params_bar.dart    # 必备参数快捷条
│   │   │       │   └── advanced_params_panel.dart # 高级参数面板
│   │   │       └── controllers/
│   │   │           ├── brew_logger_controller.dart  # 页面状态
│   │   │           └── brew_timer_controller.dart   # 计时器状态
│   │   │
│   │   ├── inventory/                # 📋 无摩擦力录入机制
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── bean.dart              # 咖啡豆实体
│   │   │   │   │   └── equipment.dart         # 器具实体
│   │   │   │   ├── repositories/
│   │   │   │   │   └── inventory_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── get_suggestions.dart     # 智能下拉补全
│   │   │   │       ├── create_bean.dart
│   │   │   │       └── create_equipment.dart
│   │   │   ├── data/
│   │   │   │   ├── models/
│   │   │   │   │   ├── bean_model.dart         # Drift Table
│   │   │   │   │   └── equipment_model.dart    # Drift Table
│   │   │   │   ├── datasources/
│   │   │   │   │   └── inventory_local_datasource.dart
│   │   │   │   └── repositories/
│   │   │   │       └── inventory_repository_impl.dart
│   │   │   └── presentation/
│   │   │       ├── widgets/
│   │   │       │   ├── smart_tag_field.dart     # 自动补全标签输入
│   │   │       │   └── template_picker.dart     # "再冲一次" 模板选择
│   │   │       └── controllers/
│   │   │           └── inventory_controller.dart
│   │   │
│   │   ├── rating/                   # ⭐ 分层风味评价体系
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── brew_rating.dart       # 评价实体 (含简单+专业)
│   │   │   │   └── usecases/
│   │   │   │       └── save_rating.dart
│   │   │   ├── data/
│   │   │   │   ├── models/
│   │   │   │   │   └── brew_rating_model.dart  # 嵌入式对象/关联
│   │   │   │   └── datasources/
│   │   │   │       └── rating_local_datasource.dart
│   │   │   └── presentation/
│   │   │       ├── widgets/
│   │   │       │   ├── quick_rating_bar.dart    # 滑动星级/表情
│   │   │       │   ├── flavor_wheel.dart        # 风味轮组件
│   │   │       │   └── flavor_sliders.dart      # 酸甜苦分离滑块
│   │   │       └── controllers/
│   │   │           └── rating_controller.dart
│   │   │
│   │   └── history/                  # 📊 本地数据墙与历史过滤
│   │       ├── domain/
│   │       │   ├── entities/
│   │       │   │   └── brew_summary.dart       # 聚合视图实体
│   │       │   ├── repositories/
│   │       │   │   └── history_repository.dart
│   │       │   └── usecases/
│   │       │       ├── get_brew_history.dart    # 获取历史列表
│   │       │       ├── filter_brews.dart        # 按豆种/评分筛选
│   │       │       └── get_top_brews.dart       # 高分冲煮
│   │       ├── data/
│   │       │   ├── datasources/
│   │       │   │   └── history_local_datasource.dart
│   │       │   └── repositories/
│   │       │       └── history_repository_impl.dart
│   │       └── presentation/
│   │           ├── pages/
│   │           │   └── history_page.dart        # 历史数据墙
│   │           ├── widgets/
│   │           │   ├── brew_record_card.dart    # 记录卡片 (高分高亮)
│   │           │   ├── history_filter_bar.dart  # 筛选栏
│   │           │   └── brew_stats_header.dart   # 统计摘要头部
│   │           └── controllers/
│   │               └── history_controller.dart
│   │
│   └── shared/                       # 🤝 跨模块共享 (非UI)
│       ├── providers/
│       │   └── database_providers.dart    # Drift Database Provider 定义
│       └── helpers/
│           └── brew_param_defaults.dart   # 默认参数预设值
│
├── test/                             # 🧪 测试目录 (镜像 lib/ 结构)
│   ├── core/
│   │   └── database/
│   │       └── drift_database_test.dart
│   ├── features/
│   │   ├── brew_logger/
│   │   │   ├── domain/
│   │   │   │   └── usecases/
│   │   │   │       └── create_brew_record_test.dart
│   │   │   ├── data/
│   │   │   │   └── repositories/
│   │   │   │       └── brew_repository_impl_test.dart
│   │   │   └── presentation/
│   │   │       ├── pages/
│   │   │       │   └── brew_logger_page_test.dart   # Widget Test
│   │   │       └── controllers/
│   │   │           └── brew_timer_controller_test.dart
│   │   ├── inventory/
│   │   │   └── data/
│   │   │       └── repositories/
│   │   │           └── inventory_repository_impl_test.dart
│   │   ├── rating/
│   │   │   └── presentation/
│   │   │       └── widgets/
│   │   │           └── quick_rating_bar_test.dart
│   │   └── history/
│   │       └── domain/
│   │           └── usecases/
│   │               └── get_brew_history_test.dart
│   └── helpers/                      # 测试辅助工具
│       ├── test_fixtures.dart        # 测试数据工厂
│       └── mock_repositories.dart    # Mock 仓库
│
├── integration_test/                 # 🔗 集成测试
│   ├── app_cold_start_test.dart      # KR: 冷启动 ≤2 次点击到计时器
│   ├── brew_flow_test.dart           # 完整冲煮流程测试
│   ├── timer_background_test.dart    # 后台挂起计时异常测试
│   └── progressive_expand_test.dart  # 参数面板展开测试
│
├── docs/                             # 📄 项目文档
│   ├── 00_Product_Brief.md           # 产品简要
│   ├── 01_Architecture.md            # 本文档
│   ├── ADR_01_Database_Selection.md   # 数据库选型决策记录
│   ├── ADR_02_Testing_Framework.md   # 测试框架选型决策记录
│   ├── 02_Data_Model.md              # 数据模型设计
│   ├── 03_UI_Specification.md        # UI 交互规格
│   └── 04_Testing_Strategy.md        # 测试策略
│
├── scripts/                          # 🛠️ 构建与工具脚本
│   └── build_apk.sh                  # 构建 APK 脚本
│
├── pubspec.yaml                      # Dart 依赖管理
├── analysis_options.yaml             # Lint 规则
├── .github/
│   └── workflows/
│       └── ci.yml                    # CI: Test → Build → APK
├── .gitignore
└── README.md
```

---

## 3. 核心数据模型设计

### 3.1 实体关系

```
BREW_RECORD ──1:0..1──► BREW_RATING    (一条冲煮记录有零或一个评价)
BREW_RECORD ──*:1──────► BEAN          (多条冲煮记录使用同一种豆子)
BREW_RECORD ──*:0..1──► EQUIPMENT     (多条冲煮记录关联磨豆机/滤杯等器具)
                                        └── 研磨度可引用该器具的刻度范围
BREW_METHOD_CONFIG ──1:1..*──► BREW_PARAM_DEFINITION (某冲煮方式拥有一组参数定义)
BREW_PARAM_DEFINITION ──1:0..1──► BREW_PARAM_VISIBILITY (参数是否显示)
BREW_RECORD ──1:0..*──► BREW_PARAM_VALUE ──*:1──► BREW_PARAM_DEFINITION
```

### 3.2 实体字段

#### BrewRecord (冲煮记录)
| 字段                | 类型                         | 必填 | 说明                                              |
| ------------------ | --------------------------- | --- | ------------------------------------------------ |
| id                 | int (PK)                    | ✅  | 自增主键                                           |
| brewDate           | DateTime                    | ✅  | 冲煮时间                                           |
| beanName           | String (FK)                 | ✅  | 关联的咖啡豆名称                                     |
| equipmentId        | int? (FK)                   | ⬜  | 关联的磨豆机器具 ID，用于器具刻度模式                    |
| **brewMethod**     | **enum (BrewMethod)**       | ✅  | **冲煮方式：`pour_over` / `espresso` / `custom`** |
| **grindMode**      | **enum (GrindMode)**        | ✅  | **研磨度记录模式：`equipment` / `simple` / `pro`**    |
| grindClickValue    | double?                     | ⬜  | 器具模式：具体刻度值 (如 24.5 格)                      |
| grindSimpleLabel   | String?                     | ⬜  | 极简模式："极细" / "较细" / "中细" / "中" / "中粗" / "较粗" / "极粗" |
| grindMicrons       | int?                        | ⬜  | 专业模式：研磨粒径 (μm)                               |
| coffeeWeight_g     | double                      | ✅  | 咖啡粉重 (克)                                       |
| waterWeight_g      | double                      | ✅  | 水量 (克)                                          |
| waterTemp_C        | double                      | ⬜  | 水温 (℃)                                          |
| brewDuration_s     | int                         | ✅  | 总冲煮时长 (秒)                                     |
| bloomTime_s        | int                         | ⬜  | 闷蒸时间 (秒)                                       |
| pourMethod         | String                      | ⬜  | 注水方式                                            |
| waterType          | String                      | ⬜  | 水质                                               |
| roomTemp_C         | double                      | ⬜  | 室温 (℃)                                           |
| notes              | String                      | ⬜  | 备注                                               |
| createdAt          | DateTime                    | ✅  | 创建时间                                            |
| updatedAt          | DateTime                    | ✅  | 更新时间                                            |

> **GrindMode 枚举** — 三种研磨度记录模式：
> - `equipment` (默认)：关联磨豆机，在该器具的 `grindMinClick`~`grindMaxClick` 范围内选取刻度
> - `simple`：不关联器具，从 7 级粗略描述中选择（极细 → 极粗）
> - `pro`：直接输入微米值 (μm)，适合追求精确的硬核玩家

#### Bean (咖啡豆)
| 字段 | 类型 | 必填 | 说明 |
|---|---|---|---|
| id | int (PK) | ✅ | 自增主键 |
| name | String (UK) | ✅ | 豆名 (唯一) |
| roaster | String | ⬜ | 烘焙商 |
| origin | String | ⬜ | 产地 |
| roastLevel | String | ⬜ | 烘焙度 |
| addedAt | DateTime | ✅ | 首次添加时间 |
| useCount | int | ✅ | 使用次数 |

#### Equipment (器具)
| 字段            | 类型           | 必填 | 说明                                       |
| -------------- | ------------- | --- | ----------------------------------------- |
| id             | int (PK)      | ✅  | 自增主键                                    |
| name           | String (UK)   | ✅  | 器具名 (唯一，如 "C40", "Comandante")       |
| category       | String        | ⬜  | 类别：`grinder` / `dripper` / `kettle` 等   |
| **isGrinder**  | **bool**      | ✅  | **是否为磨豆机（决定是否展示研磨度配置）**        |
| grindMinClick  | double?       | ⬜  | 磨豆机最小刻度 (如 0)                         |
| grindMaxClick  | double?       | ⬜  | 磨豆机最大刻度 (如 40)                        |
| grindClickStep | double?       | ⬜  | 每格步进值 (如 1 = 整格, 0.5 = 半格)           |
| grindClickUnit | String?       | ⬜  | 刻度单位标签 (如 "格", "clicks", "数字")     |
| addedAt        | DateTime      | ✅  | 首次添加时间                                  |
| useCount       | int           | ✅  | 使用次数                                     |

> **磨豆机配置说明**：用户添加一台磨豆机器具时（`isGrinder=true`），可选配置刻度范围。例如 Comandante C40 的刻度为 0~40 格、步进 1 格，则 `grindMinClick=0, grindMaxClick=40, grindClickStep=1`。创建冲煮记录时选择该器具后，UI 会自动展示对应范围的滑块/数字选择器。若未配置刻度，则回退到极简模式。

#### BrewRating (冲煮评价)
| 字段 | 类型 | 必填 | 说明 |
|---|---|---|---|
| id | int (PK) | ✅ | 自增主键 |
| brewRecordId | int (FK) | ✅ | 关联的冲煮记录 |
| quickScore | int | ⬜ | 快速评分 (1-5) |
| emoji | String | ⬜ | 表情评价 |
| acidity | double | ⬜ | 酸度 (专业) |
| sweetness | double | ⬜ | 甜度 (专业) |
| bitterness | double | ⬜ | 苦度 (专业) |
| body | double | ⬜ | 醇厚度 (专业) |
| flavorNotes | String | ⬜ | 风味标签 |

#### BrewMethodConfig (冲煮方式配置)
| 字段 | 类型 | 必填 | 说明 |
|---|---|---|---|
| id | int (PK) | ✅ | 自增主键 |
| method | enum (BrewMethod) | ✅ | 方式标识：`pour_over` / `espresso` / `custom` |
| displayName | String | ✅ | 显示名称（如“手冲”“意式”） |
| isEnabled | bool | ✅ | 是否启用（至少保留一个启用） |

#### BrewParamDefinition (参数定义)
| 字段 | 类型 | 必填 | 说明 |
|---|---|---|---|
| id | int (PK) | ✅ | 自增主键 |
| method | enum (BrewMethod) | ✅ | 归属冲煮方式 |
| name | String | ✅ | 参数名（如“水温”“闷蒸时间”） |
| type | enum (ParamType) | ✅ | 参数类型：`number` / `text` |
| unit | String? | ⬜ | 单位（用户自填） |
| isSystem | bool | ✅ | 是否系统预设 |
| sortOrder | int | ✅ | 参数排序 |

#### BrewParamVisibility (参数显示配置)
| 字段 | 类型 | 必填 | 说明 |
|---|---|---|---|
| id | int (PK) | ✅ | 自增主键 |
| method | enum (BrewMethod) | ✅ | 冲煮方式 |
| paramId | int (FK) | ✅ | 关联参数定义 |
| isVisible | bool | ✅ | 是否在记录页显示 |

#### BrewParamValue (参数值)
| 字段 | 类型 | 必填 | 说明 |
|---|---|---|---|
| id | int (PK) | ✅ | 自增主键 |
| brewRecordId | int (FK) | ✅ | 关联冲煮记录 |
| paramId | int (FK) | ✅ | 关联参数定义 |
| valueNumber | double? | ⬜ | 数字值 |
| valueText | String? | ⬜ | 文本值 |

### 3.3 关键设计决策

| 决策 | 选择 | 理由 |
|---|---|---|
| **Bean/Equipment 创建方式** | 首次手打即自动入库，useCount 追踪使用频次 | 满足 "无摩擦力录入" 需求 |
| **研磨度三模式** | `equipment`(默认) / `simple` / `pro`，BrewRecord 存三类字段 | 满足从入门到极客的全谱系用户；器具刻度关联让"重现上次好味道"更精确 |
| **评价模型** | 通过评分字段是否为空区分快速/专业评分 | 满足 "分层评价" 需求 |
| **参数默认值** | 按可见参数写入，仅保存当前启用参数 | 渐进式入参 |
| **参数自定义与显示** | 参数定义/可见性/值三表分离 | 支持用户自定义参数与按需显示，避免“详细模式全量字段”臃肿 |
| **历史不可变** | 历史记录仅展示已记录参数 | 用户设置变化不影响历史记录展示 |
| **数据库选型** | Drift (基于 SQLite) | 类型安全 ORM，Reactive Stream，编译时 SQL 校验，活跃维护 ([ADR_01](./ADR_01_Database_Selection.md)) |

> **记录模式说明**：`quick/detail/pro` 记录模式在后续迭代中移除（2026-03-11），
> 统一由“冲煮方式 + 参数清单/可见性”控制记录内容与展示。

---

## 4. 状态管理策略

### 4.1 Riverpod Provider 层次

```
driftDatabaseProvider (单例)
    └── brewLocalDatasourceProvider
        └── brewRepositoryProvider
            └── createBrewRecordProvider
                └── brewLoggerControllerProvider (StateNotifier)
```

### 4.2 状态管理规则

1. **Controller (Notifier/AsyncNotifier)** 持有页面级 UI 状态
2. **UseCase** 编排业务逻辑（无 UI 依赖）
3. **Repository Interface** 定义在 Domain 层，实现在 Data 层
4. **所有 Provider 均以 `@riverpod` 注解生成**（使用 riverpod_generator）

---

## 5. 路由设计

```dart
// lib/core/router/app_router.dart

GoRouter appRouter = GoRouter(
  initialLocation: '/brew',       // 🔑 首页即"开始冲煮" — 秒开体验
  routes: [
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: '/brew',
          builder: (_, __) => const BrewLoggerPage(),
        ),
        GoRoute(
          path: '/manage',
          builder: (_, __) => const InventoryManagePage(), // 导航名称：Manage（含库存 + 记录偏好）
        ),
        GoRoute(
          path: '/history',
          builder: (_, __) => const HistoryPage(),
        ),
      ],
    ),
  ],
);
```

> **关键**: 首页直达冲煮记录器，满足 OKR 要求 "启动应用 → 触发开始冲煮计时 ≤ 2 次点击"

---

## 6. 测试策略映射到 OKR

| OKR | 测试类型 | 对应文件 | 覆盖重点 |
|---|---|---|---|
| **O1-KR1** 核心 CRUD 覆盖率 ≥90% | Unit Test | `test/features/*/data/repositories/*_test.dart` | BrewRecord / Bean / Equipment 增删改查 |
| **O1-KR2** UI 组件断言 100% | Widget Test | `test/features/*/presentation/pages/*_test.dart` | 按钮渲染、滑动条交互、页面跳转 |
| **O1-KR3** APK 构建验证 | CI Pipeline | `.github/workflows/ci.yml` | `flutter build apk --release` 无 Error |
| **O2-KR1** 冷启动 ≤2 次点击 | Integration Test | `integration_test/app_cold_start_test.dart` | 计时器可达性验证 |
| **O2-KR2** 边界测试 0 Error | Integration Test | `integration_test/timer_background_test.dart` | 后台挂起、模式切换 |

---

## 7. 关键依赖清单

> ⚠️ **不指定版本号** — 以下仅列出包名与选型理由。实际开发时请通过 `flutter pub add <package>` 获取最新稳定版，或到 [pub.dev](https://pub.dev) 确认维护状态。
>
> **知识来源声明**：所有依赖选型均基于 AI 模型的训练知识，而非 senior-architect skill 的内容（该 skill 的参考文档为通用模板，未包含 Flutter 特定指导）。请在采纳前自行验证各包的最新状态与社区评价。

#### 运行时依赖 (dependencies)

| 包名 | 用途 | 选型理由 |
|---|---|---|
| `flutter_riverpod` | 状态管理 | 编译时安全，原生支持 Dependency Override 便于测试 |
| `riverpod_annotation` | Riverpod 代码生成注解 | 配合 riverpod_generator 减少样板代码 |
| `go_router` | 声明式路由 | Flutter 官方推荐，支持 Deep Link 和 ShellRoute |
| `drift` / `sqlite3_flutter_libs` | 本地数据库 (类型安全 SQLite ORM) | 编译时 SQL 校验，Reactive Stream，内置迁移系统 ([ADR_01](./ADR_01_Database_Selection.md)) |
| `freezed_annotation` | 不可变数据类注解 | 配合 freezed 生成 copyWith / == / toString |
| `json_annotation` | JSON 序列化注解 | 数据导出支持 |
| `flutter_animate` | 微动画 | 链式 API 构建 UI 过渡动画 |
| `gap` | 间距组件 | 替代 SizedBox，语义更清晰 |
| `intl` | 国际化 / 日期格式化 | 日期时间展示 |

#### 开发依赖 (dev_dependencies)

| 包名 | 用途 | 选型理由 |
|---|---|---|
| `flutter_test` | Widget / Unit 测试 | Flutter SDK 内置 |
| `integration_test` | 集成测试 | Flutter SDK 内置 |
| `build_runner` | 代码生成执行器 | freezed / riverpod_generator / drift_dev 共用 |
| `freezed` | 不可变数据类生成器 | 自动生成 copyWith / == / hashCode |
| `json_serializable` | JSON 序列化生成器 | 自动生成 fromJson / toJson |
| `riverpod_generator` | Riverpod Provider 生成器 | 从 @riverpod 注解生成 Provider |
| `drift_dev` | Drift 代码生成器 | 从 Table 定义类生成类型安全的数据库代码 |
| `mockito` | M ock 测试框架 | Dart官方维护，已有build_runner无额外负担 ([ADR_02](./ADR_02_Testing_Framework.md)) |
| `flutter_lints` | 静态分析规则 | Flutter 官方推荐的 Lint 规则集 |

---

## 8. CI/CD Pipeline

```
Push/PR → Install Deps → Analyze → Lint → Unit Tests → Widget Tests → Integration Tests
    │
    ├── All Pass? → YES → Build APK → Upload Artifact 📦
    │
    └── All Pass? → NO  → ❌ Fail & Report
```

---

## 9. 架构决策记录 (ADRs)

### ADR-001: Feature-First 而非 Layer-First 目录组织

- **背景**: Flutter 项目常见 `models/`, `screens/`, `services/` 平铺式组织
- **决策**: 采用 `features/{feature}/domain|data|presentation` 结构
- **收益**: 功能内聚，团队可并行开发不同模块，删除功能时整目录移除
- **代价**: 跨模块共享逻辑需要放到 `core/` 或 `shared/`

### ADR-002: Drift 替代 Isar

- **背景**: 初版选型 Isar，经人工验证发现 Isar 约两年未更新，存在维护风险
- **决策**: 改用 Drift (基于 SQLite 的类型安全 ORM)
- **收益**: 编译时 SQL 校验、Reactive Stream 内建、内置迁移系统、活跃维护 (每 2-4 周更新)
- **代价**: 需要 build_runner 代码生成 (项目已依赖 build_runner，代价可接受)
- **详细分析**: 见 [ADR_01_Database_Selection.md](./ADR_01_Database_Selection.md)

### ADR-003: Riverpod 而非 BLoC

- **背景**: BLoC 是 Flutter 官方推荐的状态管理方案之一
- **决策**: 使用 Riverpod 2.x + code generation
- **收益**: 编译时安全（不依赖 BuildContext 查找），减少样板代码，原生支持 Dependency Override（便于测试）
- **代价**: 学习曲线陡峭，code generation 增加构建时间

### ADR-004: 研磨度三模式设计 (Equipment-Linked / Simple / Pro)

- **背景**: 研磨度是手冲咖啡最核心的参数之一，但不同用户群差异极大：入门者只知道"粗细"，中级玩家记磨豆机刻度，硬核极客追踪微米值
- **决策**: 引入 `GrindMode` 枚举，BrewRecord 同时存储三种字段（`grindClickValue`, `grindSimpleLabel`, `grindMicrons`），根据 mode 只填充对应字段
- **默认模式**: `equipment` — 关联磨豆机器具，从器具配置的刻度范围中选值
- **回退逻辑**: 若器具未配置刻度 → 自动回退为 `simple` 模式；用户随时可手动切换
- **收益**: 覆盖全谱系用户需求，同时让"重现上次好味道"更精确（因为刻度值直接关联具体器具）
- **代价**: BrewRecord 增加了 4 个可空字段，Equipment 增加了 4 个磨豆机专属字段，查询逻辑需处理多模式分支

### ADR-005: Mock 测试框架改用 mockito 与集成测试选定

- **背景**: 原定选用的 `mocktail` 已近 20 个月未更新，存在长期维护隐患。需要重新评估 mock 对象以及 E2E 集成测试框架。
- **决策**: Unit/Widget 测试的 mock 框架改用 `mockito`，MVP 阶段继续沿用 SDK 内置的 `integration_test`，暂不引入 `patrol` 框架。
- **收益**: `mockito` 为 Dart 官方发布，随 SDK 稳定更新；本项目已高度依赖 `build_runner`，引入其代码生成零额外负担。暂缓引 `patrol` 可保持初期应用集成简单。
- **代价**: 编写 Mock 代码和更新接口时，需要运行 `build_runner` 重新生成代码。
- **详细分析**: 见 [ADR_02_Testing_Framework.md](./ADR_02_Testing_Framework.md)

---

## 10. 未来演进路线 (Post-MVP)

| 阶段 | 功能 | 架构影响 |
|---|---|---|
| **v1.1** | 数据导出 (CSV/JSON) | 新增 `features/export/` 模块 |
| **v1.2** | iOS 发布 | 无架构变化，增加 iOS CI |
| **v2.0** | 云端同步 (可选) | Data 层新增 RemoteDataSource，Repository 实现合并策略 |
| **v2.1** | 社区功能 (分享冲煮方案) | 新增 `features/community/`，引入 REST/GraphQL 客户端 |
| **v3.0** | AI 推荐 (基于历史数据推荐参数) | 新增 `features/recommendations/`，Domain 层策略模式 |

> Clean Architecture 的分层使得未来新增 RemoteDataSource 时，只需实现新的 Repository 而无需修改 Domain 或 Presentation 层。
