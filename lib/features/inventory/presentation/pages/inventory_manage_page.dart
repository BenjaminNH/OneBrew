import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/router/app_route_paths.dart';
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
                'About OneBrew',
                style: AppTextStyles.headlineSmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Author: $_authorName',
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
                    ConnectionState.done => 'Unavailable',
                    _ => 'Loading...',
                  };
                  return Text(
                    'Version: $versionLabel',
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
                  label: const Text('Open GitHub Repository'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openGithubRepo(BuildContext sheetContext) async {
    final launched = await launchUrl(
      _githubRepoUri,
      mode: LaunchMode.externalApplication,
    );
    if (launched || !sheetContext.mounted) {
      return;
    }
    ScaffoldMessenger.of(sheetContext).showSnackBar(
      const SnackBar(
        content: Text('Unable to open GitHub link.'),
        backgroundColor: AppColors.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                tooltip: tabController.index == 0 ? 'Add bean' : 'Add grinder',
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
                              'Manage',
                              style: AppTextStyles.displayMedium.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          if (kDebugMode)
                            IconButton(
                              key: const Key('manage-debug-onboarding-button'),
                              tooltip: 'Debug: Re-run onboarding',
                              onPressed: () =>
                                  context.go(AppRoutePaths.onboarding),
                              icon: const Icon(Icons.bug_report_rounded),
                              color: AppColors.primary,
                            ),
                          IconButton(
                            key: const Key('manage-about-icon-button'),
                            tooltip: 'About',
                            onPressed: _openAboutSheet,
                            icon: const Icon(Icons.info_outline_rounded),
                            color: AppColors.primary,
                          ),
                          IconButton(
                            key: const Key('manage-preferences-icon-button'),
                            tooltip: 'Record Preferences',
                            onPressed: () =>
                                context.push(AppRoutePaths.managePreferences),
                            icon: const Icon(Icons.tune_rounded),
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
                          tabs: const [
                            Tab(text: 'Beans'),
                            Tab(text: 'Grinders'),
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
