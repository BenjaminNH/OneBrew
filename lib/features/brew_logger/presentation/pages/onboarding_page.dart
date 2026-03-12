import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../brew_logger_providers.dart';
import '../../domain/entities/brew_method.dart';
import '../../domain/entities/brew_method_config.dart';
import '../controllers/brew_preferences_controller.dart';
import '../widgets/brew_preferences_widgets.dart';

class BrewOnboardingPage extends ConsumerStatefulWidget {
  const BrewOnboardingPage({super.key});

  @override
  ConsumerState<BrewOnboardingPage> createState() => _BrewOnboardingPageState();
}

class _BrewOnboardingPageState extends ConsumerState<BrewOnboardingPage> {
  final PageController _pageController = PageController();
  int _pageIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(brewPreferencesControllerProvider);
    final controller = ref.read(brewPreferencesControllerProvider.notifier);

    ref.listen<BrewPreferencesState>(brewPreferencesControllerProvider, (_, next) {
      if (next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage!)),
        );
        controller.clearError();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: state.isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              )
            : Column(
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
                            'Welcome to OneCoffee',
                            style: AppTextStyles.displayMedium,
                          ),
                        ),
                        TextButton(
                          onPressed: _skipOnboarding,
                          child: const Text('Skip'),
                        ),
                      ],
                    ),
                  ),
                  _StepIndicator(currentStep: _pageIndex),
                  const SizedBox(height: AppSpacing.sm),
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (index) =>
                          setState(() => _pageIndex = index),
                      children: [
                        _StepContainer(
                          title: 'Choose brew methods',
                          subtitle: 'Select at least one method to start.',
                          child: BrewMethodToggleList(
                            methodConfigs: _visibleMethodConfigs(
                              state.methodConfigs,
                            ),
                            onToggle: (method, enabled) =>
                                _handleMethodToggle(
                                  context,
                                  controller,
                                  method,
                                  enabled,
                                  state.methodConfigs,
                                ),
                          ),
                          footer: Align(
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: () => _addCustomMethod(
                                context,
                                controller,
                                state.methodConfigs,
                              ),
                              child: Text(
                                'Want another method? click here',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.primary,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                        ),
                        _StepContainer(
                          title: 'Parameter list',
                          subtitle: 'Hide defaults or add custom parameters.',
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BrewMethodSegmented(
                                methodConfigs: state.methodConfigs,
                                selectedMethod: state.selectedMethod,
                                onSelected: controller.selectMethod,
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              BrewParamListEditor(
                                items: state.paramItemsFor(state.selectedMethod),
                                onVisibilityChanged: (item, visible) =>
                                    controller.setParamVisibility(
                                      state.selectedMethod,
                                      item.definition.id,
                                      visible,
                                    ),
                                onDelete: (item) =>
                                    controller.deleteCustomParam(
                                      state.selectedMethod,
                                      item.definition.id,
                                    ),
                              ),
                              const SizedBox(height: AppSpacing.md),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  onPressed: () => _showAddParamSheet(
                                    context,
                                    state.selectedMethod,
                                    controller,
                                  ),
                                  icon: const Icon(Icons.add_rounded),
                                  label: const Text('Add Custom Parameter'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.pageHorizontal,
                      AppSpacing.sm,
                      AppSpacing.pageHorizontal,
                      AppSpacing.pageBottom,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _canProceed(state)
                          ? () => _advance(state)
                          : null,
                      child: Text(_pageIndex == 1 ? 'Finish' : 'Next'),
                    ),
                  ),
                ),
              ],
            ),
      ),
    );
  }

  bool _canProceed(BrewPreferencesState state) {
    if (_pageIndex == 0) {
      return state.hasEnabledMethod;
    }
    return true;
  }

  void _advance(BrewPreferencesState state) {
    if (_pageIndex < 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _skipOnboarding() {
    _finishOnboarding();
  }

  void _finishOnboarding() {
    ref.invalidate(brewParamBootstrapProvider);
    if (!mounted) return;
    context.go('/brew');
  }

  List<BrewMethodConfig> _visibleMethodConfigs(
    List<BrewMethodConfig> configs,
  ) {
    return configs
        .where(
          (config) =>
              config.method != BrewMethod.custom ||
              config.isEnabled ||
              !_isDefaultCustomName(config.displayName),
        )
        .toList();
  }

  bool _isDefaultCustomName(String name) =>
      name.trim().toLowerCase() == 'custom';

  Future<void> _handleMethodToggle(
    BuildContext context,
    BrewPreferencesController controller,
    BrewMethod method,
    bool enabled,
    List<BrewMethodConfig> configs,
  ) async {
    if (method != BrewMethod.custom || !enabled) {
      await controller.toggleMethodEnabled(method, enabled);
      return;
    }

    final current = configs.firstWhere((c) => c.method == method);
    if (!_isDefaultCustomName(current.displayName)) {
      await controller.toggleMethodEnabled(method, true);
      return;
    }
    final name = await _promptCustomMethodName(
      context,
      current.displayName,
    );
    if (name == null) return;
    await controller.toggleMethodEnabled(method, true, displayName: name);
  }

  Future<void> _addCustomMethod(
    BuildContext context,
    BrewPreferencesController controller,
    List<BrewMethodConfig> configs,
  ) async {
    final current = configs.firstWhere(
      (c) => c.method == BrewMethod.custom,
      orElse: () => const BrewMethodConfig(
        id: 0,
        method: BrewMethod.custom,
        displayName: 'Custom',
        isEnabled: false,
      ),
    );
    final name = await _promptCustomMethodName(
      context,
      current.displayName,
    );
    if (name == null) return;
    await controller.toggleMethodEnabled(
      BrewMethod.custom,
      true,
      displayName: name,
    );
  }

  Future<String?> _promptCustomMethodName(
    BuildContext context,
    String currentName,
  ) async {
    final resolvedName =
        currentName.trim().toLowerCase() == 'custom' ? '' : currentName;
    final controller = TextEditingController(text: resolvedName);
    String draft = resolvedName;

    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.pageHorizontal,
            right: AppSpacing.pageHorizontal,
            bottom: MediaQuery.of(context).viewInsets.bottom +
                AppSpacing.pageBottom,
            top: AppSpacing.pageTop,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              final canSubmit = draft.trim().isNotEmpty;
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Custom Brew Method', style: AppTextStyles.headlineSmall),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      labelText: 'Method name',
                      hintText: 'e.g. AeroPress',
                    ),
                    onChanged: (value) => setState(() => draft = value),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      ElevatedButton(
                        onPressed: canSubmit
                            ? () => Navigator.of(context).pop(draft.trim())
                            : null,
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _showAddParamSheet(
    BuildContext context,
    BrewMethod method,
    BrewPreferencesController controller,
  ) async {
    final nameController = TextEditingController();
    final unitController = TextEditingController();
    ParamType selectedType = ParamType.number;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.pageHorizontal,
            right: AppSpacing.pageHorizontal,
            bottom: MediaQuery.of(context).viewInsets.bottom +
                AppSpacing.pageBottom,
            top: AppSpacing.pageTop,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('New Parameter', style: AppTextStyles.headlineSmall),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      hintText: 'e.g. Flow Rate',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text('Type', style: AppTextStyles.labelMedium),
                  const SizedBox(height: AppSpacing.xs),
                  Wrap(
                    spacing: AppSpacing.xs,
                    children: ParamType.values.map((type) {
                      final selected = selectedType == type;
                      return ChoiceChip(
                        label: Text(type == ParamType.number ? 'Number' : 'Text'),
                        selected: selected,
                        onSelected: (_) => setState(() => selectedType = type),
                        selectedColor: AppColors.primary,
                        labelStyle: AppTextStyles.labelSmall.copyWith(
                          color: selected ? Colors.white : AppColors.textSecondary,
                        ),
                        side: BorderSide(
                          color: selected ? AppColors.primary : AppColors.shadowDark,
                        ),
                        backgroundColor: AppColors.background,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: unitController,
                    decoration: const InputDecoration(
                      labelText: 'Unit (optional)',
                      hintText: 'e.g. g, ml, bar',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        await controller.addCustomParam(
                          method: method,
                          name: nameController.text,
                          type: selectedType,
                          unit: unitController.text,
                        );
                        if (context.mounted) Navigator.of(context).pop();
                      },
                      child: const Text('Add Parameter'),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.currentStep});

  final int currentStep;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(2, (index) {
        final isActive = index == currentStep;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 18 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : AppColors.shadowDark,
            borderRadius: BorderRadius.circular(8),
          ),
        );
      }),
    );
  }
}

class _StepContainer extends StatelessWidget {
  const _StepContainer({
    required this.title,
    required this.subtitle,
    required this.child,
    this.footer,
  });

  final String title;
  final String subtitle;
  final Widget child;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pageHorizontal,
        AppSpacing.md,
        AppSpacing.pageHorizontal,
        AppSpacing.pageBottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.headlineLarge),
          const SizedBox(height: AppSpacing.xs),
          Text(
            subtitle,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          child,
          if (footer != null) ...[
            const SizedBox(height: AppSpacing.md),
            footer!,
          ],
        ],
      ),
    );
  }
}
