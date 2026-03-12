import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../domain/entities/brew_param_definition.dart';
import '../controllers/brew_logger_controller.dart';
import '../models/brew_param_names.dart';
import 'brew_param_value_field.dart';

class BrewParamExtraInputs extends ConsumerWidget {
  const BrewParamExtraInputs({super.key, required this.definitions});

  final List<BrewParamDefinition> definitions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(brewLoggerControllerProvider);
    final controller = ref.read(brewLoggerControllerProvider.notifier);

    final extras = definitions
        .where((def) => !systemBoundParamNames.contains(def.name))
        .toList();

    if (extras.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.md),
        ...extras.map((def) {
          final draft = state.paramValues[def.id];
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: BrewParamValueField(
              definition: def,
              value: draft,
              onNumberChanged: (value) =>
                  controller.setParamNumberValue(def.id, value),
              onTextChanged: (value) =>
                  controller.setParamTextValue(def.id, value),
            ),
          );
        }),
      ],
    );
  }
}
