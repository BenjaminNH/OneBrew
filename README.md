# OneBrew

[简体中文](./docs/README_CN.md) | English

---

**Focus on one brew at a time.**

OneBrew is a **Local-First** pour-over and espresso coffee brewing logger designed with a "Neumorphism" aesthetic. It aims to provide an elegant, frictionless, and zero-pressure way for coffee enthusiasts—from beginners to hardcore geeks—to record brewing parameters and flavor feedback, helping you consistently replicate that perfect cup of coffee.

### ✨ Key Features

- **Quick Logger**: A frictionless timer with progressive parameter input. Log the essentials first, expand for advanced parameters later.
- **Frictionless Inventory**: Type a coffee bean or equipment name once, and it's saved. Smart auto-completion and "Brew Again" templates make logging effortless.
- **Tiered Rating System**: Quick emoji/star ratings for beginners, and separated flavor sliders/flavor wheels for advanced users.
- **History Wall & Filtering**: Browse past brews with highlights for high-scoring cups. Build your brewing achievements locally.
- **100% Local-First**: All data is securely stored on your device using an embedded SQLite database. No account required, no cloud syncing issues.

### 🧰 Tech Stack

- **Framework**: [Flutter](https://flutter.dev/) (SDK 3.x)
- **Language**: [Dart](https://dart.dev/) (3.11+)
- **Database**: [Drift](https://drift.simonbinder.eu/) (Type-safe ORM for SQLite)
- **State Management**: [Riverpod](https://riverpod.dev/) (`riverpod_annotation`, `flutter_riverpod`)
- **Routing**: [GoRouter](https://pub.dev/packages/go_router)
- **Immutability / Code Generation**: [Freezed](https://pub.dev/packages/freezed), `build_runner`
- **UI & Animations**: `flutter_animate`, `gap`, custom Neumorphism design system

### 🛠️ Prerequisites

- Flutter SDK 3.11.1 or higher
- Android Studio or Xcode (depending on your target platform)
- Active Android emulator, iOS simulator, or a physical device

### 🚀 Getting Started

#### 1. Clone & Install Dependencies
```bash
git clone https://github.com/your-username/OneBrew.git
cd OneBrew
flutter pub get
```

#### 2. Run Code Generation
OneBrew utilizes Drift and Freezed for code generation. You must build these generated files before running the application:
```bash
dart run build_runner build --delete-conflicting-outputs
```
*(Tip: during active development, you can use `dart run build_runner watch --delete-conflicting-outputs`)*

#### 3. Run the App
```bash
flutter run
```

### 🧪 Testing

The project includes unit tests, widget tests, and integration tests.

```bash
# Run unit and widget tests
flutter test

# Run integration tests (requires a running emulator/device)
flutter test integration_test/timer_background_test.dart
flutter test integration_test/brew_history_inventory_flow_test.dart
```

### 🏗 Architecture & Code Structure

The project follows a **Feature-First + Clean Architecture** approach.

```text
lib/
 ├── core/          # App-wide themes, routing, database configurations
 ├── features/      # Business logic grouped by feature (brew_logger, inventory, rating, history)
 ├── shared/        # Shared presentation logic (dumb widgets, generic dialogs)
test/               # Unit and component tests
integration_test/   # End-to-end user flow integration tests
docs/               # Detailed product specs, UI/UX specs, and architecture documents
```

**Key Routes:**
- `/brew`: The main brewing logger and timer.
- `/manage`: Equipment inventory and brewing preferences.
- `/history`: The wall of past brews and their details.
- `/onboarding`: First-time user setup flow.

### 📚 Documentation
Check the `docs/` folder for deeper architectural decisions and UI specifications:
- `00_Product_Brief.md` - Core product philosophy.
- `01_Architecture.md` - Detailed architectural diagrams.
- `03_UI_Specification.md` - Neumorphism design principles and thumb-zone ergonomics.
