import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/router/app_route_paths.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../brew_logger/domain/entities/brew_record.dart';
import '../../../rating/presentation/widgets/brew_rating_sheet.dart';
import '../../domain/entities/brew_detail.dart';
import '../controllers/brew_detail_controller.dart';
import '../controllers/history_controller.dart';

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
              return _ErrorState(
                message: 'Brew record not found.',
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
              onShare: () => _handleShare(context),
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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Rating updated.'),
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
        title: const Text('Delete Brew'),
        content: const Text(
          'Delete this brew record? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Delete'),
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(deleteResult.errorMessage ?? 'Failed to delete brew.'),
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
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Brew deleted.'),
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

  void _handleShare(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Share is coming soon.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
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
    final hasParamEntries = paramEntries.isNotEmpty;
    final basicRows = <Widget>[
      _DataRow(
        label: 'Brewed At',
        value: AppDateUtils.formatDateTimeFull(detail.brewDate),
      ),
      _DataRow(label: 'Bean', value: _text(detail.beanName)),
      if (_hasText(detail.roaster))
        _DataRow(label: 'Roaster', value: _text(detail.roaster)),
      if (_hasText(detail.origin))
        _DataRow(label: 'Origin', value: _text(detail.origin)),
      if (_hasText(detail.roastLevel))
        _DataRow(label: 'Roast Level', value: _text(detail.roastLevel)),
      _DataRow(label: 'Duration', value: '${detail.brewDurationS}s'),
    ];
    final environmentRows = _buildEnvironmentRows(detail);
    final fallbackParamRows = _buildFallbackParamRows(detail);
    final grindRows = _buildGrindRows(detail);
    final ratingRows = _buildRatingRows(detail);
    final hasRating = ratingRows.isNotEmpty;
    final metaRows = <Widget>[
      if (_hasText(detail.notes))
        _DataRow(label: 'Notes', value: _text(detail.notes)),
      _DataRow(
        label: 'Created At',
        value: AppDateUtils.formatDateTimeFull(detail.createdAt),
      ),
      _DataRow(
        label: 'Updated At',
        value: AppDateUtils.formatDateTimeFull(detail.updatedAt),
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
                        'Brew Detail',
                        style: AppTextStyles.displayMedium.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      key: const Key('brew-detail-delete-icon-button'),
                      tooltip: 'Delete brew',
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete_outline_rounded),
                      color: AppColors.error,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                _SectionCard(title: 'Basic', children: basicRows),
                const SizedBox(height: AppSpacing.md),
                if (hasParamEntries) ...[
                  _SectionCard(
                    title: 'Recorded Params',
                    children: paramEntries
                        .map(
                          (entry) =>
                              _DataRow(label: entry.name, value: entry.value),
                        )
                        .toList(),
                  ),
                  if (environmentRows.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.md),
                    _SectionCard(
                      title: 'Environment',
                      children: environmentRows,
                    ),
                  ],
                ] else ...[
                  _SectionCard(
                    title: 'Brew Params',
                    children: fallbackParamRows,
                  ),
                  if (environmentRows.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.md),
                    _SectionCard(
                      title: 'Environment',
                      children: environmentRows,
                    ),
                  ],
                ],
                if (grindRows.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.md),
                  _SectionCard(title: 'Grind', children: grindRows),
                ],
                const SizedBox(height: AppSpacing.md),
                _SectionCard(
                  title: 'Rating',
                  children: [
                    if (hasRating)
                      ...ratingRows
                    else
                      Text(
                        'No rating recorded yet.',
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
                        label: Text(hasRating ? 'Edit Rating' : 'Add Rating'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                _SectionCard(title: 'Meta', children: metaRows),
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

  List<Widget> _buildEnvironmentRows(BrewDetail detail) {
    final rows = <Widget>[];
    if (_hasText(detail.waterType)) {
      rows.add(_DataRow(label: 'Water Type', value: _text(detail.waterType)));
    }
    final roomTemp = _double(detail.roomTempC, suffix: '°C');
    if (_isRecorded(roomTemp)) {
      rows.add(_DataRow(label: 'Room Temp', value: roomTemp));
    }
    return rows;
  }

  List<Widget> _buildFallbackParamRows(BrewDetail detail) {
    final rows = <Widget>[
      _DataRow(
        label: 'Coffee',
        value: '${detail.coffeeWeightG.toStringAsFixed(1)}g',
      ),
      _DataRow(
        label: 'Water',
        value: '${detail.waterWeightG.toStringAsFixed(0)}g',
      ),
    ];
    final ratio = _ratio(detail.coffeeWeightG, detail.waterWeightG);
    if (_isRecorded(ratio)) {
      rows.add(_DataRow(label: 'Ratio', value: ratio));
    }
    final waterTemp = _double(detail.waterTempC, suffix: '°C');
    if (_isRecorded(waterTemp)) {
      rows.add(_DataRow(label: 'Water Temp', value: waterTemp));
    }
    final bloomTime = _int(detail.bloomTimeS, suffix: 's');
    if (_isRecorded(bloomTime)) {
      rows.add(_DataRow(label: 'Bloom Time', value: bloomTime));
    }
    if (_hasText(detail.pourMethod)) {
      rows.add(_DataRow(label: 'Pour Method', value: _text(detail.pourMethod)));
    }
    return rows;
  }

  List<Widget> _buildGrindRows(BrewDetail detail) {
    switch (detail.grindMode) {
      case GrindMode.equipment:
        final equipment = _text(detail.equipmentName);
        final click = _double(detail.grindClickValue);
        final unit = _text(detail.grindClickUnit ?? 'clicks');
        if (!_isRecorded(equipment) && !_isRecorded(click)) {
          return const <Widget>[];
        }
        return <Widget>[
          _DataRow(label: 'Mode', value: _grindMode(detail.grindMode)),
          if (_isRecorded(equipment))
            _DataRow(label: 'Equipment', value: equipment),
          if (_isRecorded(click))
            _DataRow(
              label: 'Click',
              value: '$click ${_isRecorded(unit) ? unit : 'clicks'}',
            ),
        ];
      case GrindMode.simple:
        final label = _text(detail.grindSimpleLabel);
        if (!_isRecorded(label)) {
          return const <Widget>[];
        }
        return <Widget>[
          _DataRow(label: 'Mode', value: _grindMode(detail.grindMode)),
          _DataRow(label: 'Label', value: label),
        ];
      case GrindMode.pro:
        final microns = _int(detail.grindMicrons, suffix: ' μm');
        if (!_isRecorded(microns)) {
          return const <Widget>[];
        }
        return <Widget>[
          _DataRow(label: 'Mode', value: _grindMode(detail.grindMode)),
          _DataRow(label: 'Microns', value: microns),
        ];
    }
  }

  List<Widget> _buildRatingRows(BrewDetail detail) {
    final rows = <Widget>[];
    final hasQuick = detail.quickScore != null || _hasText(detail.emoji);
    if (hasQuick) {
      rows.add(
        _DataRow(
          label: 'Quick',
          value: _quickRating(detail.quickScore, detail.emoji),
        ),
      );
    }
    final acidity = _double(detail.acidity);
    if (_isRecorded(acidity)) {
      rows.add(_DataRow(label: 'Acidity', value: acidity));
    }
    final sweetness = _double(detail.sweetness);
    if (_isRecorded(sweetness)) {
      rows.add(_DataRow(label: 'Sweetness', value: sweetness));
    }
    final bitterness = _double(detail.bitterness);
    if (_isRecorded(bitterness)) {
      rows.add(_DataRow(label: 'Bitterness', value: bitterness));
    }
    final body = _double(detail.body);
    if (_isRecorded(body)) {
      rows.add(_DataRow(label: 'Body', value: body));
    }
    if (_hasText(detail.flavorNotes)) {
      rows.add(
        _DataRow(label: 'Flavor Notes', value: _text(detail.flavorNotes)),
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
              label: const Text('Brew Again'),
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
              label: const Text('Share'),
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
              label: const Text('Retry'),
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

String _quickRating(int? score, String? emoji) {
  if (score == null && (emoji == null || emoji.trim().isEmpty)) {
    return 'Unrated';
  }
  final emojiText = _text(emoji);
  if (score == null) {
    return emojiText;
  }
  return '$score/5 ${emojiText == '--' ? '' : emojiText}'.trim();
}

bool _hasText(String? value) {
  final trimmed = value?.trim();
  return trimmed != null && trimmed.isNotEmpty;
}

bool _isRecorded(String value) => value != '--';

String _grindMode(GrindMode mode) {
  switch (mode) {
    case GrindMode.equipment:
      return 'Equipment';
    case GrindMode.simple:
      return 'Simple';
    case GrindMode.pro:
      return 'Pro';
  }
}
