import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../brew_logger_providers.dart';
import '../../domain/entities/brew_param_definition.dart';
import '../../domain/entities/brew_param_key.dart';
import '../controllers/brew_logger_controller.dart';
import 'brew_param_value_field.dart';

class BrewParamExtraInputs extends ConsumerWidget {
  const BrewParamExtraInputs({super.key, required this.definitions});

  final List<BrewParamDefinition> definitions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(brewLoggerControllerProvider);
    final controller = ref.read(brewLoggerControllerProvider.notifier);

    final extras = definitions
        .where(
          (def) => !isSystemBoundParam(paramKey: def.paramKey, name: def.name),
        )
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
              loadTextSuggestions: (definition) async {
                final paramKey = definition.resolvedParamKey;
                if (paramKey == null) {
                  return const [];
                }
                return ref
                    .read(brewParamRepositoryProvider)
                    .getTopTextParamSuggestions(
                      method: definition.method,
                      paramKey: paramKey,
                    );
              },
              onNumberChanged: (value) =>
                  controller.setParamNumberValueByDefinition(def, value),
              onTextChanged: (value) =>
                  controller.setParamTextValue(def.id, value),
            ),
          );
        }),
      ],
    );
  }
}
