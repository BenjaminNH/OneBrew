import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/localization/app_locale.dart';
import '../../../../core/localization/app_locale_controller.dart';
import '../../../../core/router/app_route_paths.dart';
import '../../../../l10n/l10n.dart';
import '../widgets/bean_manage_list.dart';
import '../widgets/grinder_manage_list.dart';

/// Inventory management page for Phase 7B.
///
/// Provides two tabs:
/// - Beans
/// - Grinders
class InventoryManagePage extends StatefulWidget {
  const InventoryManagePage({super.key});

  @override
  State<InventoryManagePage> createState() => _InventoryManagePageState();
}

class _InventoryManagePageState extends State<InventoryManagePage> {
  static const String _authorName = 'BenjaminNH';
  static const String _pageTitle = 'Manage';
  static final Uri _githubRepoUri = Uri.parse(
    'https://github.com/BenjaminNH/OneBrew',
  );
  static const double _fabSize = 56;

  final _beanListController = BeanManageListController();
  final _grinderListController = GrinderManageListController();

  @override
  void dispose() {
    _beanListController.unbindOpenCreateForm();
    _grinderListController.unbindOpenCreateForm();
    super.dispose();
  }

  void _openAddEntry(TabController tabController) {
    if (tabController.index == 0) {
      _beanListController.openCreateForm();
      return;
    }
    _grinderListController.openCreateForm();
  }

  Future<void> _openAboutSheet() async {
    final l10n = context.l10n;
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      builder: (sheetContext) => SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.pageHorizontal,
            AppSpacing.lg,
            AppSpacing.pageHorizontal,
            AppSpacing.xl,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.inventoryAboutTitle,
                style: AppTextStyles.headlineSmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                l10n.inventoryAboutAuthor(_authorName),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              FutureBuilder<PackageInfo>(
                future: PackageInfo.fromPlatform(),
                builder: (context, snapshot) {
                  final versionLabel = switch (snapshot.connectionState) {
                    ConnectionState.done when snapshot.hasData =>
                      'v${snapshot.data!.version} (${snapshot.data!.buildNumber})',
                    ConnectionState.done =>
                      l10n.inventoryAboutVersionUnavailable,
                    _ => l10n.inventoryAboutVersionLoading,
                  };
                  return Text(
                    l10n.inventoryAboutVersion(versionLabel),
                    key: const Key('manage-about-version-text'),
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  key: const Key('manage-about-github-button'),
                  onPressed: () => _openGithubRepo(sheetContext),
                  icon: const Icon(Icons.open_in_new_rounded),
                  label: Text(l10n.inventoryAboutOpenGithub),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openGithubRepo(BuildContext sheetContext) async {
    final l10n = sheetContext.l10n;
    final launched = await launchUrl(
      _githubRepoUri,
      mode: LaunchMode.externalApplication,
    );
    if (launched || !sheetContext.mounted) {
      return;
    }
    ScaffoldMessenger.of(sheetContext).showSnackBar(
      SnackBar(
        content: Text(l10n.inventoryAboutOpenGithubFailed),
        backgroundColor: AppColors.error,
      ),
    );
  }

  Future<void> _openLanguageSheet() async {
    final l10n = context.l10n;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Consumer(
            builder: (context, ref, _) {
              final selected = ref.watch(appLocaleOptionProvider);
              return Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.pageHorizontal,
                  AppSpacing.sm,
                  AppSpacing.pageHorizontal,
                  AppSpacing.lg,
                ),
                child: RadioGroup<AppLocaleOption>(
                  groupValue: selected,
                  onChanged: (value) async {
                    if (value == null) return;
                    await ref
                        .read(appLocaleControllerProvider)
                        .setLocaleOption(value);
                    if (sheetContext.mounted) {
                      Navigator.of(sheetContext).pop();
                    }
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.inventoryLanguageTitle,
                        style: AppTextStyles.headlineSmall,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      ...AppLocaleOption.values.map((option) {
                        final title = switch (option) {
                          AppLocaleOption.systemDefault =>
                            context.l10n.languageSystemDefault,
                          AppLocaleOption.english =>
                            context.l10n.languageEnglish,
                          AppLocaleOption.simplifiedChinese =>
                            context.l10n.languageSimplifiedChinese,
                        };
                        return RadioListTile<AppLocaleOption>(
                          value: option,
                          selected: option == selected,
                          title: Text(title),
                        );
                      }),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return DefaultTabController(
      length: 2,
      child: Builder(
        builder: (context) {
          final tabController = DefaultTabController.of(context);
          final safeBottom = MediaQuery.paddingOf(context).bottom;
          final listBottomAvoidance =
              safeBottom +
              kFloatingActionButtonMargin +
              _fabSize +
              AppSpacing.md;

          return AnimatedBuilder(
            animation: tabController,
            builder: (context, _) => Scaffold(
              backgroundColor: AppColors.background,
              floatingActionButton: FloatingActionButton(
                key: const Key('manage-add-fab'),
                onPressed: () => _openAddEntry(tabController),
                tooltip: tabController.index == 0
                    ? l10n.inventoryFabTooltipAddBean
                    : l10n.inventoryFabTooltipAddGrinder,
                child: const Icon(Icons.add),
              ),
              body: SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.pageHorizontal,
                        AppSpacing.pageTop,
                        AppSpacing.pageHorizontal,
                        AppSpacing.sm,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _pageTitle,
                              style: AppTextStyles.displayMedium.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          if (kDebugMode)
                            IconButton(
                              key: const Key('manage-debug-onboarding-button'),
                              tooltip:
                                  l10n.inventoryTooltipDebugRerunOnboarding,
                              onPressed: () =>
                                  context.go(AppRoutePaths.onboarding),
                              icon: const Icon(Icons.bug_report_rounded),
                              color: AppColors.primary,
                            ),
                          IconButton(
                            key: const Key('manage-about-icon-button'),
                            tooltip: l10n.inventoryTooltipAbout,
                            onPressed: _openAboutSheet,
                            icon: const Icon(Icons.info_outline_rounded),
                            color: AppColors.primary,
                          ),
                          IconButton(
                            key: const Key('manage-preferences-icon-button'),
                            tooltip: l10n.inventoryTooltipRecordPreferences,
                            onPressed: () =>
                                context.push(AppRoutePaths.managePreferences),
                            icon: const Icon(Icons.tune_rounded),
                            color: AppColors.primary,
                          ),
                          IconButton(
                            key: const Key('manage-language-icon-button'),
                            tooltip: l10n.inventoryTooltipLanguage,
                            onPressed: _openLanguageSheet,
                            icon: const Icon(Icons.language_rounded),
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.pageHorizontal,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusLg,
                          ),
                        ),
                        child: TabBar(
                          dividerColor: Colors.transparent,
                          labelColor: AppColors.primary,
                          unselectedLabelColor: AppColors.textSecondary,
                          indicator: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusLg,
                            ),
                          ),
                          tabs: [
                            Tab(text: l10n.inventoryTabBeans),
                            Tab(text: l10n.inventoryTabGrinders),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Expanded(
                      child: TabBarView(
                        children: [
                          BeanManageList(
                            controller: _beanListController,
                            listBottomInset: listBottomAvoidance,
                          ),
                          GrinderManageList(
                            controller: _grinderListController,
                            listBottomInset: listBottomAvoidance,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
