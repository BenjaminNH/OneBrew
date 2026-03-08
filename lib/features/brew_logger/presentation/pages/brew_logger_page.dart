import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/timer_utils.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../inventory/presentation/widgets/template_picker.dart';
import '../../../rating/presentation/widgets/brew_rating_sheet.dart';
import '../../domain/entities/brew_record.dart';
import '../controllers/brew_logger_controller.dart';
import '../controllers/brew_timer_controller.dart';
import '../widgets/brew_timer_widget.dart';
import '../widgets/param_input_section.dart';

/// Main brew logging page.
///
/// The page coordinates timer, parameter inputs, template reuse, and save flow.
class BrewLoggerPage extends ConsumerStatefulWidget {
  const BrewLoggerPage({super.key});

  @override
  ConsumerState<BrewLoggerPage> createState() => _BrewLoggerPageState();
}

class _BrewLoggerPageState extends ConsumerState<BrewLoggerPage>
    with WidgetsBindingObserver {
  int _currentElapsed = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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
  Widget build(BuildContext context) {
    final loggerState = ref.watch(brewLoggerControllerProvider);
    final timerState = ref.watch(brewTimerControllerProvider);
    final templatesAsync = ref.watch(recentBrewTemplatesProvider);

    ref.listen<BrewLoggerState>(brewLoggerControllerProvider, (_, next) {
      if (next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: AppColors.error,
          ),
        );
        ref.read(brewLoggerControllerProvider.notifier).clearError();
      }
      if (next.savedRecordId != null && !next.isSaving) {
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
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.pageHorizontal,
                  vertical: AppSpacing.pageTop,
                ),
                child: _PageHeader(beanName: loggerState.beanName),
              ),
            ),
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
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.pageHorizontal,
                ),
                child: AppCard(
                  child: BrewTimerWidget(
                    targetSeconds: loggerState.brewDurationS,
                    bloomSeconds: loggerState.bloomTimeS ?? 0,
                    onElapsedChanged: (elapsed) {
                      setState(() => _currentElapsed = elapsed);
                    },
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),
            const SliverToBoxAdapter(child: ParamInputSection()),
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
    ref.read(brewTimerControllerProvider.notifier).reset();
    setState(() => _currentElapsed = 0);

    if (!mounted) return;
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
    ref.read(brewTimerControllerProvider.notifier).reset();
    ref.read(brewLoggerControllerProvider.notifier).resetForm();
    setState(() => _currentElapsed = 0);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _showSaveSuccessFlow(savedId);
    });
  }

  Future<void> _showSaveSuccessFlow(int savedId) async {
    final didSaveRating = await _openRatingSheet(savedId);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          didSaveRating == true ? 'Brew and rating saved!' : 'Brew saved!',
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'View',
          textColor: Colors.white,
          onPressed: () {
            context.go('/history');
          },
        ),
      ),
    );
  }

  Future<bool?> _openRatingSheet(int brewRecordId) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BrewRatingSheet(brewRecordId: brewRecordId),
    );
  }
}

class _PageHeader extends StatelessWidget {
  const _PageHeader({required this.beanName});
  final String beanName;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          beanName.isEmpty ? 'Ready to Brew' : beanName,
          style: AppTextStyles.displayLarge.copyWith(
            color: beanName.isEmpty
                ? AppColors.textSecondary
                : AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          'OneCoffee',
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.primary.withValues(alpha: 0.7),
            letterSpacing: 3.0,
          ),
        ),
      ],
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
