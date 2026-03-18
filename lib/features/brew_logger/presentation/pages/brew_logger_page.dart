import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/timer_utils.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../shared/helpers/brew_param_defaults.dart';
import '../../../inventory/presentation/widgets/template_picker.dart';
import '../../../rating/presentation/widgets/brew_rating_sheet.dart';
import '../../brew_logger_providers.dart';
import '../../domain/entities/brew_record.dart';
import '../controllers/brew_logger_controller.dart';
import '../controllers/brew_timer_controller.dart';
import '../widgets/brew_timer_widget.dart';
import '../widgets/brew_method_selector.dart';
import '../widgets/param_input_section.dart';

/// Main brew logging page.
///
/// The page coordinates timer, parameter inputs, template reuse, and save flow.
class BrewLoggerPage extends ConsumerStatefulWidget {
  const BrewLoggerPage({super.key, this.templateRecordId});

  final int? templateRecordId;

  @override
  ConsumerState<BrewLoggerPage> createState() => _BrewLoggerPageState();
}

class _BrewLoggerPageState extends ConsumerState<BrewLoggerPage>
    with WidgetsBindingObserver {
  int _currentElapsed = 0;
  int? _appliedTemplateRecordId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _applyTemplateFromRouteIfNeeded();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    ref
        .read(brewTimerControllerProvider.notifier)
        .handleAppLifecycleStateChanged(state);
  }

  @override
  void didUpdateWidget(covariant BrewLoggerPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.templateRecordId != widget.templateRecordId) {
      _applyTemplateFromRouteIfNeeded();
    }
  }

  @override
  Widget build(BuildContext context) {
    final loggerState = ref.watch(brewLoggerControllerProvider);
    final timerState = ref.watch(brewTimerControllerProvider);
    final timerProfile = BrewParamDefaults.timerProfileForMethod(
      loggerState.brewMethod,
    );
    final templatesAsync = ref.watch(recentBrewTemplatesProvider);
    final methodConfigsAsync = ref.watch(brewMethodConfigsProvider);

    ref.listen<BrewLoggerState>(brewLoggerControllerProvider, (previous, next) {
      if (next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: AppColors.error,
          ),
        );
        ref.read(brewLoggerControllerProvider.notifier).clearError();
      }
      if (next.savedRecordId != null &&
          next.savedRecordId != previous?.savedRecordId &&
          !next.isSaving) {
        _onSaveSuccess(next.savedRecordId!);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.pageHorizontal,
                  AppSpacing.pageTop,
                  AppSpacing.pageHorizontal,
                  0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'OneBrew',
                      style: AppTextStyles.displayMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    methodConfigsAsync.when(
                      data: (configs) => BrewMethodSelector(configs: configs),
                      loading: () => const LinearProgressIndicator(
                        color: AppColors.primary,
                      ),
                      error: (_, _) => AppCard(
                        child: Text(
                          'Brew methods unavailable.',
                          style: AppTextStyles.bodySmall,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.sm)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.pageHorizontal,
                ),
                child: templatesAsync.when(
                  data: (records) => TemplatePicker(
                    templates: _toTemplateOptions(records),
                    onTemplateSelected: (option) {
                      _onTemplateSelected(option.brewRecordId, records);
                    },
                  ),
                  loading: () => TemplatePicker(
                    templates: const [],
                    isLoading: true,
                    onTemplateSelected: (_) {},
                  ),
                  error: (error, stackTrace) => AppCard(
                    child: Text(
                      'Templates unavailable right now.',
                      style: AppTextStyles.bodySmall,
                    ),
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),
            const SliverToBoxAdapter(child: ParamInputSection()),
            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.pageHorizontal,
                ),
                child: AppCard(
                  child: BrewTimerWidget(
                    targetSeconds: timerProfile.recommendedTargetSeconds,
                    bloomSeconds:
                        loggerState.bloomTimeS ??
                        timerProfile.recommendedBloomSeconds,
                    onElapsedChanged: (elapsed) {
                      setState(() => _currentElapsed = elapsed);
                    },
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),
            SliverToBoxAdapter(
              child: _SaveActionBar(
                isRunning: timerState.isRunning,
                isSaving: loggerState.isSaving,
                elapsed: _currentElapsed,
                onSave: _onSaveTapped,
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: AppSpacing.pageBottom),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onSaveTapped() async {
    ref.read(brewTimerControllerProvider.notifier).pause();
    await ref
        .read(brewLoggerControllerProvider.notifier)
        .saveNewRecord(elapsedSeconds: _currentElapsed);
  }

  Future<void> _applyTemplateFromRouteIfNeeded() async {
    final recordId = widget.templateRecordId;
    if (recordId == null || _appliedTemplateRecordId == recordId) {
      return;
    }
    _appliedTemplateRecordId = recordId;
    final applied = await ref
        .read(brewLoggerControllerProvider.notifier)
        .applyTemplateByRecordId(recordId);
    if (!applied || !mounted) {
      return;
    }

    ref.read(brewTimerControllerProvider.notifier).reset();
    setState(() => _currentElapsed = 0);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Template loaded from history'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  Future<void> _onTemplateSelected(
    int templateId,
    List<BrewRecord> templates,
  ) async {
    BrewRecord? selected;
    for (final template in templates) {
      if (template.id == templateId) {
        selected = template;
        break;
      }
    }
    if (selected == null) return;

    await ref
        .read(brewLoggerControllerProvider.notifier)
        .applyTemplate(selected);
    if (!mounted) return;

    ref.read(brewTimerControllerProvider.notifier).reset();
    setState(() => _currentElapsed = 0);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Template applied: ${selected.beanName}'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  List<BrewTemplateOption> _toTemplateOptions(List<BrewRecord> records) {
    return records
        .map((record) {
          final title = record.beanName.trim().isEmpty
              ? 'Untitled Brew'
              : record.beanName;
          final subtitle =
              '${record.coffeeWeightG.toStringAsFixed(1)}g -> '
              '${record.waterWeightG.toStringAsFixed(0)}g | '
              '${TimerUtils.formatSeconds(record.brewDurationS)}';
          return BrewTemplateOption(
            brewRecordId: record.id,
            title: title,
            subtitle: subtitle,
          );
        })
        .toList(growable: false);
  }

  void _onSaveSuccess(int savedId) {
    if (!mounted) return;

    ref.read(brewTimerControllerProvider.notifier).reset();
    ref.read(brewLoggerControllerProvider.notifier).resetForm();
    setState(() => _currentElapsed = 0);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _showSaveSuccessSnackBar(savedId);
    });
  }

  void _showSaveSuccessSnackBar(int savedId) {
    final rootNavigator = Navigator.of(context, rootNavigator: true);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Brew saved. You can rate now or later in History detail.',
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        persist: false,
        action: SnackBarAction(
          label: 'Rate now',
          textColor: Colors.white,
          onPressed: () {
            _openOptionalRatingSheet(
              rootContext: rootNavigator.context,
              brewRecordId: savedId,
            );
          },
        ),
      ),
    );
  }

  Future<void> _openOptionalRatingSheet({
    required BuildContext rootContext,
    required int brewRecordId,
  }) async {
    final messenger = ScaffoldMessenger.maybeOf(rootContext);
    final didSaveRating = await _openRatingSheet(
      rootContext: rootContext,
      brewRecordId: brewRecordId,
    );
    if (didSaveRating != true || messenger == null) {
      return;
    }

    messenger.showSnackBar(
      const SnackBar(
        content: Text('Rating saved!'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<bool?> _openRatingSheet({
    required BuildContext rootContext,
    required int brewRecordId,
  }) {
    FocusManager.instance.primaryFocus?.unfocus();
    return showModalBottomSheet<bool>(
      context: rootContext,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BrewRatingSheet(brewRecordId: brewRecordId),
    );
  }
}

class _SaveActionBar extends StatefulWidget {
  const _SaveActionBar({
    required this.isRunning,
    required this.isSaving,
    required this.elapsed,
    required this.onSave,
  });

  final bool isRunning;
  final bool isSaving;
  final int elapsed;
  final VoidCallback onSave;

  @override
  State<_SaveActionBar> createState() => _SaveActionBarState();
}

class _SaveActionBarState extends State<_SaveActionBar> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final canSave = widget.elapsed > 0 && !widget.isSaving;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.pageHorizontal,
      ),
      child: GestureDetector(
        onTapDown: canSave ? (_) => setState(() => _pressed = true) : null,
        onTapUp: canSave
            ? (_) {
                setState(() => _pressed = false);
                widget.onSave();
              }
            : null,
        onTapCancel: () => setState(() => _pressed = false),
        child: Semantics(
          button: true,
          label: 'Save brew record',
          enabled: canSave,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            height: AppSpacing.buttonHeight,
            decoration: BoxDecoration(
              color: canSave ? AppColors.primary : AppColors.shadowDark,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              boxShadow: canSave
                  ? (_pressed ? AppColors.pressedShadow : AppColors.softShadow)
                  : [],
            ),
            child: Center(
              child: widget.isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.save_rounded,
                          color: canSave
                              ? Colors.white
                              : AppColors.textDisabled,
                          size: AppSpacing.iconAction,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          canSave ? 'Save Brew' : 'Start timer to save',
                          style: AppTextStyles.labelLarge.copyWith(
                            color: canSave
                                ? Colors.white
                                : AppColors.textDisabled,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
