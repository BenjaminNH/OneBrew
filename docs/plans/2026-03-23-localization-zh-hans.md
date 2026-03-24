# OneBrew Localization (en + zh-Hans) Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Add official Flutter localization infrastructure, ship a Simplified Chinese UI, and support in-app language switching without breaking persisted business data.

**Architecture:** Use Flutter `gen_l10n` as the runtime localization layer, but keep translation source split by feature in mergeable fragments so multiple workers can translate in parallel safely. Persist locale override separately from display strings, and keep business keys stable for brew params, presets, and history data.

**Tech Stack:** Flutter `flutter_localizations`, `gen_l10n`, Drift, Riverpod, widget/integration tests

---

### Task 1: Localization Infrastructure

**Files:**
- Create: `l10n.yaml`
- Create: `lib/l10n/fragments/*.json`
- Create: `lib/l10n/app_en.arb`
- Create: `lib/l10n/app_zh_Hans.arb`
- Create: `tool/merge_l10n.dart`
- Modify: `pubspec.yaml`
- Modify: `lib/app.dart`

**Steps:**
1. Add Flutter localization dependency and generation config.
2. Add feature-split translation fragments and merge script.
3. Generate merged ARB files.
4. Wire `MaterialApp.router` to `AppLocalizations`.
5. Verify `flutter gen-l10n` / `flutter analyze` pass.

### Task 2: Locale Override Persistence

**Files:**
- Modify: `lib/core/database/models/app_setting_model.dart`
- Modify: `lib/core/database/drift_database.dart`
- Modify: `lib/shared/providers/database_providers.dart`
- Create: `lib/core/localization/*.dart`

**Steps:**
1. Extend persisted settings to support string locale values.
2. Add Riverpod locale controller/provider.
3. Define system-follow vs explicit locale override behavior.
4. Verify launch behavior and reads/writes through tests.

### Task 3: Shared Widgets + Test Harness

**Files:**
- Modify: `lib/core/router/app_router.dart`
- Modify: `lib/core/utils/date_utils.dart`
- Modify: `lib/core/widgets/*.dart`
- Create: `test/helpers/localized_test_app.dart`
- Modify: `test/core/router/app_router_test.dart`
- Modify: `test/widget_test.dart`

**Steps:**
1. Replace shared hard-coded strings with localization lookups.
2. Make date/time/relative-time formatting locale-aware.
3. Add test helpers that pump widgets with delegates and supported locales.
4. Convert core tests off hard-coded English assumptions.

### Task 4: Brew / Onboarding / Preferences Copy

**Files:**
- Modify: `lib/features/brew_logger/presentation/pages/*.dart`
- Modify: `lib/features/brew_logger/presentation/widgets/*.dart`
- Modify: `test/features/brew_logger/presentation/pages/*.dart`

**Steps:**
1. Localize brew flow, onboarding, preferences, and parameter dialogs.
2. Keep stored method/parameter keys stable and localize labels only.
3. Update affected widget tests.

### Task 5: Inventory / Manage Copy

**Files:**
- Modify: `lib/features/inventory/presentation/pages/*.dart`
- Modify: `lib/features/inventory/presentation/widgets/*.dart`
- Modify: `test/features/inventory/presentation/**/*.dart`

**Steps:**
1. Localize manage tabs, forms, dialogs, snackbars, and about sheet.
2. Stop leaking repository/domain English error messages directly to UI.
3. Update inventory tests and shared widget expectations.

### Task 6: History / Rating / Poster Copy

**Files:**
- Modify: `lib/features/history/presentation/pages/*.dart`
- Modify: `lib/features/history/presentation/widgets/*.dart`
- Modify: `lib/features/rating/presentation/widgets/*.dart`
- Modify: `test/features/history/presentation/pages/*.dart`
- Modify: `test/features/rating/presentation/widgets/*.dart`

**Steps:**
1. Localize history, brew detail, rating sheet, and filter controls.
2. Localize poster copy with dedicated keys and verify CJK layout.
3. Keep rating preset storage keys stable while localizing display labels.
4. Update page/widget tests.

### Task 7: Language Switch UI

**Files:**
- Modify: `lib/features/inventory/presentation/pages/inventory_manage_page.dart`
- Modify: related preferences/settings widgets
- Modify: affected tests

**Steps:**
1. Add a language switch entry under Manage/Preferences.
2. Support `System Default`, `English`, `简体中文`.
3. Verify override survives restart and propagates across routes.

### Task 8: Final Verification

**Files:**
- Modify: only as needed from prior tasks

**Steps:**
1. Run merge + codegen.
2. Run targeted widget tests, then full `flutter test`.
3. Run critical integration flows.
4. Review zh-Hans UI for overflow/truncation hotspots.
5. Commit in logical slices.
