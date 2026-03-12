import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_spacing.dart';
import 'advanced_params_panel.dart';
import 'quick_params_bar.dart';

/// Combines [QuickParamsBar] with [AdvancedParamsPanel].
///
/// All user-selected parameters are shown without a progressive expand toggle.
class ParamInputSection extends ConsumerWidget {
  const ParamInputSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.pageHorizontal,
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          QuickParamsBar(),
          SizedBox(height: AppSpacing.md),
          AdvancedParamsPanel(),
        ],
      ),
    );
  }
}
