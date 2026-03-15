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
import '../widgets/custom_method_actions.dart';

class BrewOnboardingPage extends ConsumerStatefulWidget {
  const BrewOnboardingPage({super.key});

  @override
  ConsumerState<BrewOnboardingPage> createState() => _BrewOnboardingPageState();
}

class _BrewOnboardingPageState extends ConsumerState<BrewOnboardingPage> {
  final PageController _pageController = PageController();
  final ScrollController _paramScrollController = ScrollController();
  int _pageIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    _paramScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(brewPreferencesControllerProvider);
    final controller = ref.read(brewPreferencesControllerProvider.notifier);
    final bottomInset = MediaQuery.of(context).padding.bottom;

    ref.listen<BrewPreferencesState>(brewPreferencesControllerProvider, (
      _,
      next,
    ) {
      if (next.errorMessage != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.errorMessage!)));
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
                  _OnboardingHero(
                    compact: _pageIndex == 1,
                    onSkip: _skipOnboarding,
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
                          subtitle:
                              'Select at least one method to start. You can add one custom method for your workflow.',
                          topSpacer: AppSpacing.huge,
                          footer: CustomMethodActions(
                            customConfig: state.customMethodConfig,
                            onAdd: () => _addCustomMethod(
                              context,
                              controller,
                              state.customMethodConfig,
                            ),
                            onRename: () => _renameCustomMethod(
                              context,
                              controller,
                              state.customMethodConfig,
                            ),
                            onDelete: controller.deleteCustomMethod,
                          ),
                          child: BrewMethodToggleList(
                            methodConfigs: _visibleMethodConfigs(
                              state.methodConfigs,
                            ),
                            onToggle: (method, enabled) => _handleMethodToggle(
                              context,
                              controller,
                              method,
                              enabled,
                              state.methodConfigs,
                            ),
                          ),
                        ),
                        _OnboardingParamStep(
                          state: state,
                          controller: controller,
                          scrollController: _paramScrollController,
                          onAddParam: () => _showAddParamSheet(
                            context,
                            state.selectedMethod,
                            controller,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.pageHorizontal,
                      AppSpacing.sm,
                      AppSpacing.pageHorizontal,
                      AppSpacing.lg + bottomInset,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        key: const Key('onboarding-primary-action'),
                        onPressed: _canProceed(state)
                            ? () => _advance(state)
                            : null,
                        child: Text(_primaryActionLabel(state)),
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

  String _primaryActionLabel(BrewPreferencesState state) {
    if (_pageIndex == 0) return 'Next';
    return _hasNextEnabledMethod(state) ? 'Next Method' : 'Finish';
  }

  bool _hasNextEnabledMethod(BrewPreferencesState state) {
    final enabled = state.enabledMethodConfigs;
    final index = enabled.indexWhere(
      (config) => config.method == state.selectedMethod,
    );
    return index >= 0 && index < enabled.length - 1;
  }

  void _advance(BrewPreferencesState state) {
    if (_pageIndex == 0) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeInOutCubic,
      );
      return;
    }

    final advancedToNext = _goToNextMethod(state);
    if (!advancedToNext) {
      _finishOnboarding();
    }
  }

  bool _goToNextMethod(BrewPreferencesState state) {
    final enabled = state.enabledMethodConfigs;
    final currentIndex = enabled.indexWhere(
      (config) => config.method == state.selectedMethod,
    );
    if (currentIndex < 0 || currentIndex >= enabled.length - 1) {
      return false;
    }

    final nextMethod = enabled[currentIndex + 1].method;
    ref
        .read(brewPreferencesControllerProvider.notifier)
        .selectMethod(nextMethod);
    if (_paramScrollController.hasClients) {
      _paramScrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    }
    return true;
  }

  void _skipOnboarding() {
    _finishOnboarding();
  }

  void _finishOnboarding() {
    ref.invalidate(brewParamBootstrapProvider);
    if (!mounted) return;
    context.go('/brew');
  }

  List<BrewMethodConfig> _visibleMethodConfigs(List<BrewMethodConfig> configs) {
    return configs
        .where(
          (config) =>
              config.method != BrewMethod.custom ||
              config.isEnabled ||
              !isDefaultCustomMethodName(config.displayName),
        )
        .toList();
  }

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

    BrewMethodConfig? current;
    for (final config in configs) {
      if (config.method == BrewMethod.custom) {
        current = config;
        break;
      }
    }
    final currentName = current?.displayName ?? 'Custom';
    if (!isDefaultCustomMethodName(currentName)) {
      await controller.toggleMethodEnabled(method, true);
      return;
    }
    final name = await showCustomMethodNameSheet(
      context,
      currentName: currentName,
    );
    if (name == null) return;
    await controller.renameCustomMethod(name);
  }

  Future<void> _addCustomMethod(
    BuildContext context,
    BrewPreferencesController controller,
    BrewMethodConfig? customConfig,
  ) async {
    final name = await showCustomMethodNameSheet(
      context,
      currentName: customConfig?.displayName ?? 'Custom',
    );
    if (name == null) return;
    await controller.renameCustomMethod(name);
  }

  Future<void> _renameCustomMethod(
    BuildContext context,
    BrewPreferencesController controller,
    BrewMethodConfig? customConfig,
  ) async {
    final name = await showCustomMethodNameSheet(
      context,
      currentName: customConfig?.displayName ?? 'Custom',
      title: 'Rename Custom Method',
    );
    if (name == null) return;
    await controller.renameCustomMethod(name);
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
            bottom:
                MediaQuery.of(context).viewInsets.bottom +
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
                        label: Text(
                          type == ParamType.number ? 'Number' : 'Text',
                        ),
                        selected: selected,
                        onSelected: (_) => setState(() => selectedType = type),
                        selectedColor: AppColors.primary,
                        labelStyle: AppTextStyles.labelSmall.copyWith(
                          color: selected
                              ? Colors.white
                              : AppColors.textSecondary,
                        ),
                        side: BorderSide(
                          color: selected
                              ? AppColors.primary
                              : AppColors.shadowDark,
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

class _OnboardingHero extends StatelessWidget {
  const _OnboardingHero({required this.compact, required this.onSkip});

  final bool compact;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeInOutCubic,
      padding: EdgeInsets.fromLTRB(
        AppSpacing.pageHorizontal,
        compact ? AppSpacing.lg : AppSpacing.pageTop,
        AppSpacing.pageHorizontal,
        compact ? AppSpacing.xs : AppSpacing.md,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 240),
              curve: Curves.easeOut,
              style: compact
                  ? AppTextStyles.displayMedium
                  : AppTextStyles.displayLarge.copyWith(
                      height: 1.05,
                      fontWeight: FontWeight.w700,
                    ),
              child: const Text('Welcome to OneBrew'),
            ),
          ),
          TextButton(onPressed: onSkip, child: const Text('Skip')),
        ],
      ),
    );
  }
}

class _OnboardingParamStep extends StatelessWidget {
  const _OnboardingParamStep({
    required this.state,
    required this.controller,
    required this.scrollController,
    required this.onAddParam,
  });

  final BrewPreferencesState state;
  final BrewPreferencesController controller;
  final ScrollController scrollController;
  final VoidCallback onAddParam;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.pageHorizontal,
            AppSpacing.md,
            AppSpacing.pageHorizontal,
            AppSpacing.sm,
          ),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Parameter list', style: AppTextStyles.headlineLarge),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Hide defaults or add custom parameters. Continue with Next Method, then Finish on the last method.',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPersistentHeader(
          pinned: true,
          delegate: _MethodSelectorHeaderDelegate(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.pageHorizontal,
                AppSpacing.xs,
                AppSpacing.pageHorizontal,
                AppSpacing.sm,
              ),
              child: BrewMethodSegmented(
                methodConfigs: state.methodConfigs,
                selectedMethod: state.selectedMethod,
                onSelected: controller.selectMethod,
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.pageHorizontal,
            0,
            AppSpacing.pageHorizontal,
            AppSpacing.md,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate.fixed([
              BrewParamListEditor(
                items: state.paramItemsFor(state.selectedMethod),
                onVisibilityChanged: (item, visible) =>
                    controller.setParamVisibility(
                      state.selectedMethod,
                      item.definition.id,
                      visible,
                    ),
                onDelete: (item) => controller.deleteCustomParam(
                  state.selectedMethod,
                  item.definition.id,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: onAddParam,
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Add Custom Parameter'),
                ),
              ),
              const SizedBox(height: AppSpacing.huge),
            ]),
          ),
        ),
      ],
    );
  }
}

class _MethodSelectorHeaderDelegate extends SliverPersistentHeaderDelegate {
  const _MethodSelectorHeaderDelegate({required this.child});

  final Widget child;

  @override
  double get minExtent => 60;

  @override
  double get maxExtent => 60;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return DecoratedBox(
      decoration: const BoxDecoration(color: AppColors.background),
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant _MethodSelectorHeaderDelegate oldDelegate) {
    return true;
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
    this.topSpacer = 0,
  });

  final String title;
  final String subtitle;
  final Widget child;
  final Widget? footer;
  final double topSpacer;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pageHorizontal,
        AppSpacing.md,
        AppSpacing.pageHorizontal,
        AppSpacing.xxl,
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
          if (topSpacer > 0) SizedBox(height: topSpacer),
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
