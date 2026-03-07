import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_spacing.dart';
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
  const ParamInputSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExpanded = ref.watch(
      brewLoggerControllerProvider.select((s) => s.isAdvancedExpanded),
    );
    final ctrl = ref.read(brewLoggerControllerProvider.notifier);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.pageHorizontal,
      ),
      child: ProgressiveExpand(
        isExpanded: isExpanded,
        onExpandChanged: (_) => ctrl.toggleAdvancedExpanded(),
        expandLabel: 'Show more parameters',
        collapseLabel: 'Hide parameters',
        collapsedChild: const QuickParamsBar(),
        expandedChild: const AdvancedParamsPanel(),
      ),
    );
  }
}
