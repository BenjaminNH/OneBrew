import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/progressive_expand.dart';
import '../controllers/brew_logger_controller.dart';
import 'advanced_params_panel.dart';
import 'quick_params_bar.dart';

/// Combines [QuickParamsBar] (always visible) with [AdvancedParamsPanel]
/// (hidden behind a progressive expand toggle).
///
/// The expand/collapse state is synced with [BrewLoggerController.isAdvancedExpanded].
///
/// Ref: docs/03_UI_Specification.md § 4.2 — Progressive Disclosure Inputs
class ParamInputSection extends ConsumerWidget {
  const ParamInputSection({super.key, this.onOpenInventoryManage});

  final VoidCallback? onOpenInventoryManage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExpanded = ref.watch(
      brewLoggerControllerProvider.select((s) => s.isAdvancedExpanded),
    );
    final ctrl = ref.read(brewLoggerControllerProvider.notifier);
    final router = GoRouter.maybeOf(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.pageHorizontal,
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton.icon(
              key: const Key('brew-open-inventory-manage'),
              onPressed: () {
                if (onOpenInventoryManage != null) {
                  onOpenInventoryManage!.call();
                  return;
                }
                router?.push(AppRoutePaths.inventoryManage);
              },
              icon: const Icon(Icons.inventory_2_outlined),
              label: const Text('Manage Inventory'),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          ProgressiveExpand(
            isExpanded: isExpanded,
            onExpandChanged: (_) => ctrl.toggleAdvancedExpanded(),
            expandLabel: 'Show more parameters',
            collapseLabel: 'Hide parameters',
            collapsedChild: const QuickParamsBar(),
            expandedChild: const AdvancedParamsPanel(),
          ),
        ],
      ),
    );
  }
}
