import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../widgets/bean_manage_list.dart';
import '../widgets/grinder_manage_list.dart';

/// Inventory management page for Phase 7B.
///
/// Provides two tabs:
/// - Beans
/// - Grinders
class InventoryManagePage extends StatelessWidget {
  const InventoryManagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
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
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Inventory Manage',
                    style: AppTextStyles.displayMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.pageHorizontal,
                ),
                child: AppCard(
                  onTap: () => context.push('/manage/preferences'),
                  child: Row(
                    children: [
                      const Icon(Icons.tune_rounded, color: AppColors.primary),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Record Preferences',
                              style: AppTextStyles.titleMedium,
                            ),
                            const SizedBox(height: AppSpacing.xxs),
                            Text(
                              'Configure brew methods and parameter list.',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.pageHorizontal,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  ),
                  child: TabBar(
                    dividerColor: Colors.transparent,
                    labelColor: AppColors.primary,
                    unselectedLabelColor: AppColors.textSecondary,
                    indicator: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                    ),
                    tabs: const [
                      Tab(text: 'Beans'),
                      Tab(text: 'Grinders'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              const Expanded(
                child: TabBarView(
                  children: [BeanManageList(), GrinderManageList()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
