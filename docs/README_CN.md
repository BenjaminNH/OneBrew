# 壹萃 (OneBrew)

**专注当下这一萃。**

壹萃 (OneBrew) 是一款采用 **轻拟物化 (Neumorphism)** 风格的 **本地优先 (Local-First)** 手冲/意式咖啡记录 App。它的目标是以“优雅、丝滑、无压迫感”的方式记录冲煮参数和风味反馈，帮助从“只需快速冲一杯”的入门者到“死磕参数”的极客玩家，都能轻松复现好喝的一杯。

### ✨ 核心特性

- **极简心流记录器 (Quick Logger)**：秒开计时器，结合渐进式参数输入（默认先记录必需项，展开后输入高阶参数，减少视觉抗拒）。
- **无摩擦力库存 (Frictionless Inventory)**：不再强制提前建库！手打一次豆子或器具名称即自动记忆，支持智能补全与“一键复刻昨日参数”功能。
- **分层评价体系 (Tiered Rating)**：小白专属的简单表情/星级好评，专业极客专属的酸甜苦分离滑块与风味轮。
- **历史记录墙 (History Wall)**：详细的历史过滤与展示，高分冲泡高亮显示，建立用户的冲煮成就感。
- **纯粹本地存储 (Local-First)**：数据全部保存在本地 SQLite 数据库中。无需注册账号，没有云端束缚，安全且极速。

### 🧰 技术栈选型

- **跨平台框架**: [Flutter](https://flutter.dev/) (SDK 3.x)
- **开发语言**: [Dart](https://dart.dev/) (3.11+)
- **本地数据库**: [Drift](https://drift.simonbinder.eu/) (类型安全的 SQLite ORM)
- **状态管理**: [Riverpod](https://riverpod.dev/) (`riverpod_annotation`, `flutter_riverpod`)
- **路由方案**: [GoRouter](https://pub.dev/packages/go_router)
- **不可变模型**: [Freezed](https://pub.dev/packages/freezed) / `json_serializable` / `build_runner`
- **动画与 UI**: `flutter_animate`, 定制的 Neumorphism 轻拟物组件系统

### 🛠️ 环境准备

- Flutter SDK 3.11.1 或更高版本
- Android Studio 或 Xcode
- 可用的 Android 模拟器、iOS 模拟器或真机

### 🚀 快速开始

#### 1. 拉取代码与安装依赖
```bash
git clone https://github.com/your-username/OneBrew.git
cd OneBrew
flutter pub get
```

#### 2. 生成底层代码
由于项目使用了 Drift 和 Freezed，你需要先运行 build_runner 生成相关代码文件：
```bash
dart run build_runner build --delete-conflicting-outputs
```
*(提示：在日常修改模型定义进行开发时，建议使用 `dart run build_runner watch --delete-conflicting-outputs`)*

#### 3. 运行应用
```bash
flutter run
```

### 🧪 测试指南

本项目包含由浅入深的自动化测试体系：

```bash
# 运行单元测试与组件测试
flutter test

# 运行集成测试（自动操作模拟器/真机，验证核心交互流）
flutter test integration_test/timer_background_test.dart
flutter test integration_test/brew_history_inventory_flow_test.dart
```

### 🏗 目录与架构

项目遵循 **按功能模块划分 (Feature-First)** + **整洁架构 (Clean Architecture)** 设计：

```text
lib/
 ├── core/          # 核心层（全局主题、路由声明、数据库初始化）
 ├── features/      # 业务特性层（如 brew_logger, inventory, rating, history 等）
 ├── shared/        # 共享层（跨模块公用的弹窗、UI 基础组件）
test/               # 各业务模块的单元与组件测试
integration_test/   # 端到端集成自动化测试脚本当
docs/               # 产品设计、架构、UI 规范等技术文档
```

**核心路由：**
- `/brew`：冲煮记录主页面（秒开计时器）
- `/manage`：豆子/器具库存管理与冲煮偏好设置
- `/history`：历史冲煮记录列表与详细回放
- `/onboarding`：首次使用的高级引导交互

### 📚 项目文档
想深入了解我们的思考过程与产品设计，请阅读 `docs/` 目录：
- `00_Product_Brief.md` - 产品立项核心理念与人群定位
- `01_Architecture.md` - 前端架构选型与分层图解
- `03_UI_Specification.md` - 轻拟物 (Neumorphism) UI/UX 规范与“拇指热区”交互法则
