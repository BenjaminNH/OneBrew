import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Builder(
        builder: (context) {
          final tabController = DefaultTabController.of(context);

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
                              ),
                            ),
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
                          BeanManageList(controller: _beanListController),
                          GrinderManageList(controller: _grinderListController),
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
