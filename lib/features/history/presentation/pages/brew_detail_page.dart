import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/router/app_route_paths.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../l10n/l10n.dart';
import '../../../brew_logger/domain/entities/brew_record.dart';
import '../../../brew_logger/presentation/models/brew_param_display.dart';
import '../../../brew_logger/presentation/models/grind_simple_label_localizer.dart';
import '../../../rating/presentation/constants/rating_presets.dart';
import '../../../rating/presentation/widgets/brew_rating_sheet.dart';
import '../../domain/entities/brew_detail.dart';
import '../controllers/brew_detail_controller.dart';
import '../controllers/history_controller.dart';
import '../widgets/share_preview_bottom_sheet.dart';

class BrewDetailPage extends ConsumerWidget {
  const BrewDetailPage({
    super.key,
    required this.brewId,
    this.onBrewAgain,
    this.onDelete,
  });

  final int brewId;
  final VoidCallback? onBrewAgain;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(brewDetailControllerProvider(brewId));
    final controller = ref.read(brewDetailControllerProvider(brewId).notifier);

    return Scaffold(
      key: const Key('brew-detail-page'),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Builder(
          builder: (context) {
            if (state.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }
            if (state.errorMessage != null) {
              return _ErrorState(
                message: state.errorMessage!,
                onRetry: controller.load,
              );
            }

            final detail = state.detail;
            if (detail == null) {
              final l10n = context.l10n;
              return _ErrorState(
                message: l10n.brewDetailNotFound,
                onRetry: controller.load,
              );
            }

            return _Content(
              detail: detail,
              paramEntries: state.paramEntries,
              onBrewAgain: () {
                if (onBrewAgain != null) {
                  onBrewAgain!.call();
                  return;
                }
                context.go(AppRoutePaths.brewWithTemplate(detail.id));
              },
              onEditRating: () {
                _openRatingEditor(
                  context,
                  brewRecordId: detail.id,
                  controller: controller,
                );
              },
              onDelete: () {
                _handleDelete(context, ref: ref, controller: controller);
              },
              onShare: () => showSharePreviewBottomSheet(
                context,
                detail: detail,
                paramEntries: state.paramEntries,
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _openRatingEditor(
    BuildContext context, {
    required int brewRecordId,
    required BrewDetailController controller,
  }) async {
    final didSave = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BrewRatingSheet(brewRecordId: brewRecordId),
    );
    if (didSave != true) {
      return;
    }

    await controller.load();
    if (!context.mounted) {
      return;
    }
    final l10n = context.l10n;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.brewDetailRatingUpdated),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _handleDelete(
    BuildContext context, {
    required WidgetRef ref,
    required BrewDetailController controller,
  }) async {
    if (onDelete != null) {
      onDelete!.call();
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.deleteBrewDialogTitle),
        content: Text(context.l10n.deleteBrewDialogBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(context.l10n.actionCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(context.l10n.actionDelete),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) {
      return;
    }

    final deleteResult = await controller.deleteCurrentBrew();
    if (!context.mounted) {
      return;
    }
    if (!deleteResult.didDelete) {
      final l10n = context.l10n;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            deleteResult.errorMessage ?? l10n.brewDetailDeleteFailed,
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    await ref.read(historyControllerProvider.notifier).load();
    if (!context.mounted) {
      return;
    }

    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(l10n.brewDetailDeleted),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );

    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.history);
  }
}

class _Content extends StatelessWidget {
  const _Content({
    required this.detail,
    required this.paramEntries,
    required this.onBrewAgain,
    required this.onEditRating,
    required this.onDelete,
    required this.onShare,
  });

  final BrewDetail detail;
  final List<BrewParamEntry> paramEntries;
  final VoidCallback onBrewAgain;
  final VoidCallback onEditRating;
  final VoidCallback onDelete;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final localeName = Localizations.localeOf(context).toString();
    final hasParamEntries = paramEntries.isNotEmpty;
    final basicRows = <Widget>[
      _DataRow(
        label: l10n.brewDetailLabelBrewedAt,
        value: AppDateUtils.formatDateTimeFull(
          detail.brewDate,
          localeName: localeName,
        ),
      ),
      _DataRow(label: l10n.brewDetailLabelBean, value: _text(detail.beanName)),
      if (_hasText(detail.roaster))
        _DataRow(
          label: l10n.brewDetailLabelRoaster,
          value: _text(detail.roaster),
        ),
      if (_hasText(detail.origin))
        _DataRow(
          label: l10n.brewDetailLabelOrigin,
          value: _text(detail.origin),
        ),
      if (_hasText(detail.roastLevel))
        _DataRow(
          label: l10n.brewDetailLabelRoastLevel,
          value: _text(detail.roastLevel),
        ),
      _DataRow(
        label: l10n.brewDetailLabelDuration,
        value: l10n.historySecondsSuffix(detail.brewDurationS),
      ),
    ];
    final environmentRows = _buildEnvironmentRows(detail, l10n: l10n);
    final fallbackParamRows = _buildFallbackParamRows(detail, l10n: l10n);
    final grindRows = _buildGrindRows(detail, l10n: l10n);
    final ratingRows = _buildRatingRows(detail, l10n: l10n);
    final hasRating = ratingRows.isNotEmpty;
    final metaRows = <Widget>[
      if (_hasText(detail.notes))
        _DataRow(label: l10n.brewDetailLabelNotes, value: _text(detail.notes)),
      _DataRow(
        label: l10n.brewDetailLabelCreatedAt,
        value: AppDateUtils.formatDateTimeFull(
          detail.createdAt,
          localeName: localeName,
        ),
      ),
      _DataRow(
        label: l10n.brewDetailLabelUpdatedAt,
        value: AppDateUtils.formatDateTimeFull(
          detail.updatedAt,
          localeName: localeName,
        ),
      ),
    ];

    final bottomContentInset =
        AppSpacing.buttonSmallHeight + AppSpacing.xxxl + AppSpacing.xxl;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.pageHorizontal,
              AppSpacing.pageTop,
              AppSpacing.pageHorizontal,
              bottomContentInset,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => _handleBackToHistory(context),
                      icon: const Icon(Icons.arrow_back_rounded),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: Text(
                        l10n.brewDetailTitle,
                        style: AppTextStyles.displayMedium.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      key: const Key('brew-detail-delete-icon-button'),
                      tooltip: l10n.brewDetailDeleteTooltip,
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete_outline_rounded),
                      color: AppColors.error,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                _SectionCard(
                  title: l10n.brewDetailSectionBasic,
                  children: basicRows,
                ),
                const SizedBox(height: AppSpacing.md),
                if (hasParamEntries) ...[
                  _SectionCard(
                    title: l10n.brewDetailSectionRecordedParams,
                    children: paramEntries
                        .map(
                          (entry) => _DataRow(
                            label: localizedParamLabel(
                              l10n: l10n,
                              paramKey: entry.paramKey,
                              fallbackName: entry.name,
                            ),
                            value: localizedParamValue(
                              l10n: l10n,
                              paramKey: entry.paramKey,
                              value: entry.value,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  if (environmentRows.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.md),
                    _SectionCard(
                      title: l10n.brewDetailSectionEnvironment,
                      children: environmentRows,
                    ),
                  ],
                ] else ...[
                  _SectionCard(
                    title: l10n.brewDetailSectionBrewParams,
                    children: fallbackParamRows,
                  ),
                  if (environmentRows.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.md),
                    _SectionCard(
                      title: l10n.brewDetailSectionEnvironment,
                      children: environmentRows,
                    ),
                  ],
                ],
                if (grindRows.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.md),
                  _SectionCard(
                    title: l10n.brewDetailSectionGrind,
                    children: grindRows,
                  ),
                ],
                const SizedBox(height: AppSpacing.md),
                _SectionCard(
                  title: l10n.brewDetailSectionRating,
                  children: [
                    if (hasRating)
                      ...ratingRows
                    else
                      Text(
                        l10n.brewDetailRatingEmpty,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    const SizedBox(height: AppSpacing.sm),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        key: const Key('brew-detail-edit-rating'),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(
                            AppSpacing.buttonHeight,
                          ),
                        ),
                        onPressed: onEditRating,
                        icon: const Icon(Icons.edit_note_rounded),
                        label: Text(
                          hasRating
                              ? l10n.brewDetailEditRating
                              : l10n.brewDetailAddRating,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                _SectionCard(
                  title: l10n.brewDetailSectionMeta,
                  children: metaRows,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _BottomActions(onShare: onShare, onBrewAgain: onBrewAgain),
      ],
    );
  }

  void _handleBackToHistory(BuildContext context) {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.history);
  }

  List<Widget> _buildEnvironmentRows(
    BrewDetail detail, {
    required dynamic l10n,
  }) {
    final rows = <Widget>[];
    if (_hasText(detail.waterType)) {
      rows.add(
        _DataRow(
          label: l10n.brewDetailLabelWaterType as String,
          value: _text(detail.waterType),
        ),
      );
    }
    final roomTemp = _double(detail.roomTempC, suffix: '°C');
    if (_isRecorded(roomTemp)) {
      rows.add(
        _DataRow(
          label: l10n.brewDetailLabelRoomTemp as String,
          value: roomTemp,
        ),
      );
    }
    return rows;
  }

  List<Widget> _buildFallbackParamRows(
    BrewDetail detail, {
    required dynamic l10n,
  }) {
    final rows = <Widget>[
      _DataRow(
        label: l10n.brewDetailLabelCoffee as String,
        value: '${detail.coffeeWeightG.toStringAsFixed(1)}g',
      ),
      _DataRow(
        label: l10n.brewDetailLabelWater as String,
        value: '${detail.waterWeightG.toStringAsFixed(0)}g',
      ),
    ];
    final ratio = _ratio(detail.coffeeWeightG, detail.waterWeightG);
    if (_isRecorded(ratio)) {
      rows.add(
        _DataRow(label: l10n.brewDetailLabelRatio as String, value: ratio),
      );
    }
    final waterTemp = _double(detail.waterTempC, suffix: '°C');
    if (_isRecorded(waterTemp)) {
      rows.add(
        _DataRow(
          label: l10n.brewDetailLabelWaterTemp as String,
          value: waterTemp,
        ),
      );
    }
    final bloomTime = _int(detail.bloomTimeS, suffix: 's');
    if (_isRecorded(bloomTime)) {
      rows.add(
        _DataRow(
          label: l10n.brewDetailLabelBloomTime as String,
          value: bloomTime,
        ),
      );
    }
    if (_hasText(detail.pourMethod)) {
      rows.add(
        _DataRow(
          label: l10n.brewDetailLabelPourMethod as String,
          value: _text(detail.pourMethod),
        ),
      );
    }
    return rows;
  }

  List<Widget> _buildGrindRows(BrewDetail detail, {required dynamic l10n}) {
    switch (detail.grindMode) {
      case GrindMode.equipment:
        final equipment = _text(detail.equipmentName);
        final click = _double(detail.grindClickValue);
        final unit = _text(
          detail.grindClickUnit ??
              l10n.brewDetailGrindClickUnitDefault as String,
        );
        if (!_isRecorded(equipment) && !_isRecorded(click)) {
          return const <Widget>[];
        }
        return <Widget>[
          _DataRow(
            label: l10n.brewDetailLabelGrindMode as String,
            value: _grindMode(detail.grindMode, l10n: l10n),
          ),
          if (_isRecorded(equipment))
            _DataRow(
              label: l10n.brewDetailLabelGrindEquipment as String,
              value: equipment,
            ),
          if (_isRecorded(click))
            _DataRow(
              label: l10n.brewDetailLabelGrindClick as String,
              value:
                  '$click ${_isRecorded(unit) ? unit : (l10n.brewDetailGrindClickUnitDefault as String)}',
            ),
        ];
      case GrindMode.simple:
        final rawLabel = _text(detail.grindSimpleLabel);
        final label = _isRecorded(rawLabel)
            ? localizeGrindSimpleLabel(l10n, rawLabel)
            : rawLabel;
        if (!_isRecorded(label)) {
          return const <Widget>[];
        }
        return <Widget>[
          _DataRow(
            label: l10n.brewDetailLabelGrindMode as String,
            value: _grindMode(detail.grindMode, l10n: l10n),
          ),
          _DataRow(
            label: l10n.brewDetailLabelGrindLabel as String,
            value: label,
          ),
        ];
      case GrindMode.pro:
        final microns = _int(detail.grindMicrons, suffix: ' μm');
        if (!_isRecorded(microns)) {
          return const <Widget>[];
        }
        return <Widget>[
          _DataRow(
            label: l10n.brewDetailLabelGrindMode as String,
            value: _grindMode(detail.grindMode, l10n: l10n),
          ),
          _DataRow(
            label: l10n.brewDetailLabelGrindMicrons as String,
            value: microns,
          ),
        ];
    }
  }

  List<Widget> _buildRatingRows(BrewDetail detail, {required dynamic l10n}) {
    final rows = <Widget>[];
    final hasQuick = detail.quickScore != null || _hasText(detail.emoji);
    if (hasQuick) {
      rows.add(
        _DataRow(
          label: l10n.brewDetailLabelQuick as String,
          value: _quickRating(detail.quickScore, detail.emoji, l10n: l10n),
        ),
      );
    }
    final acidity = _double(detail.acidity);
    if (_isRecorded(acidity)) {
      rows.add(
        _DataRow(label: l10n.brewDetailLabelAcidity as String, value: acidity),
      );
    }
    final sweetness = _double(detail.sweetness);
    if (_isRecorded(sweetness)) {
      rows.add(
        _DataRow(
          label: l10n.brewDetailLabelSweetness as String,
          value: sweetness,
        ),
      );
    }
    final bitterness = _double(detail.bitterness);
    if (_isRecorded(bitterness)) {
      rows.add(
        _DataRow(
          label: l10n.brewDetailLabelBitterness as String,
          value: bitterness,
        ),
      );
    }
    final body = _double(detail.body);
    if (_isRecorded(body)) {
      rows.add(
        _DataRow(label: l10n.brewDetailLabelBody as String, value: body),
      );
    }
    if (_hasText(detail.flavorNotes)) {
      rows.add(
        _DataRow(
          label: l10n.brewDetailLabelFlavorNotes as String,
          value: _localizedFlavorNotes(detail.flavorNotes, l10n: l10n),
        ),
      );
    }
    return rows;
  }
}

class _BottomActions extends StatelessWidget {
  const _BottomActions({required this.onShare, required this.onBrewAgain});

  final VoidCallback onShare;
  final VoidCallback onBrewAgain;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pageHorizontal,
        0,
        AppSpacing.pageHorizontal,
        AppSpacing.lg,
      ),
      child: Row(
        children: [
          Expanded(
            child: FilledButton.icon(
              key: const Key('brew-detail-brew-again'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(
                  AppSpacing.buttonSmallHeight,
                ),
                textStyle: AppTextStyles.buttonSecondary,
              ),
              onPressed: onBrewAgain,
              icon: const Icon(Icons.replay_rounded),
              label: Text(l10n.actionBrewAgain),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: OutlinedButton.icon(
              key: const Key('brew-detail-share-button'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(
                  AppSpacing.buttonSmallHeight,
                ),
              ),
              onPressed: onShare,
              icon: const Icon(Icons.ios_share_rounded),
              label: Text(l10n.actionShare),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      borderRadius: AppSpacing.radiusMd,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.headlineSmall),
          const SizedBox(height: AppSpacing.sm),
          ...children,
        ],
      ),
    );
  }
}

class _DataRow extends StatelessWidget {
  const _DataRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(label, style: AppTextStyles.labelMedium),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            OutlinedButton.icon(
              key: const Key('brew-detail-retry'),
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(l10n.actionRetry),
            ),
          ],
        ),
      ),
    );
  }
}

String _text(String? value) {
  final trimmed = value?.trim();
  if (trimmed == null || trimmed.isEmpty) {
    return '--';
  }
  return trimmed;
}

String _double(double? value, {String suffix = ''}) {
  if (value == null) {
    return '--';
  }
  final text = value % 1 == 0
      ? value.toStringAsFixed(0)
      : value.toStringAsFixed(1);
  return '$text$suffix';
}

String _int(int? value, {String suffix = ''}) {
  if (value == null) {
    return '--';
  }
  return '$value$suffix';
}

String _ratio(double coffeeWeight, double waterWeight) {
  if (coffeeWeight <= 0) {
    return '--';
  }
  return '1:${(waterWeight / coffeeWeight).toStringAsFixed(1)}';
}

String _quickRating(int? score, String? emoji, {required dynamic l10n}) {
  if (score == null && (emoji == null || emoji.trim().isEmpty)) {
    return l10n.brewDetailUnrated as String;
  }
  final emojiText = _text(emoji);
  if (score == null) {
    return emojiText;
  }
  final scoreText = l10n.brewDetailQuickScore(score) as String;
  return '$scoreText ${emojiText == '--' ? '' : emojiText}'.trim();
}

String _localizedFlavorNotes(String? raw, {required dynamic l10n}) {
  final trimmed = raw?.trim();
  if (trimmed == null || trimmed.isEmpty) {
    return '--';
  }

  final parts = trimmed
      .split(RegExp(r'[,;/·]'))
      .map((value) => value.trim())
      .where((value) => value.isNotEmpty)
      .map((value) => flavorNoteLabel(value, l10n))
      .toList();
  if (parts.isEmpty) {
    return trimmed;
  }
  return parts.join('、');
}

bool _hasText(String? value) {
  final trimmed = value?.trim();
  return trimmed != null && trimmed.isNotEmpty;
}

bool _isRecorded(String value) => value != '--';

String _grindMode(GrindMode mode, {required dynamic l10n}) {
  switch (mode) {
    case GrindMode.equipment:
      return l10n.brewDetailGrindModeEquipment as String;
    case GrindMode.simple:
      return l10n.brewDetailGrindModeSimple as String;
    case GrindMode.pro:
      return l10n.brewDetailGrindModePro as String;
  }
}
