import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gal/gal.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../l10n/l10n.dart';
import '../../../brew_logger/domain/entities/brew_record.dart';
import '../../../brew_logger/domain/entities/brew_param_key.dart';
import '../../../brew_logger/presentation/models/brew_param_display.dart';
import '../../../brew_logger/presentation/models/grind_simple_label_localizer.dart';
import '../../../rating/presentation/constants/rating_presets.dart';
import '../../domain/entities/brew_detail.dart';
import '../controllers/brew_detail_controller.dart';

const double _posterCardSize = 342;
const double _posterInnerHorizontalPadding = 24;
const double _posterInnerRightPadding = 20;

Future<void> showSharePreviewBottomSheet(
  BuildContext context, {
  required BrewDetail detail,
  required List<BrewParamEntry> paramEntries,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) =>
        SharePreviewBottomSheet(detail: detail, paramEntries: paramEntries),
  );
}

class SharePreviewBottomSheet extends StatefulWidget {
  const SharePreviewBottomSheet({
    super.key,
    required this.detail,
    required this.paramEntries,
  });

  final BrewDetail detail;
  final List<BrewParamEntry> paramEntries;

  @override
  State<SharePreviewBottomSheet> createState() =>
      _SharePreviewBottomSheetState();
}

class _SharePreviewBottomSheetState extends State<SharePreviewBottomSheet> {
  final GlobalKey _posterKey = GlobalKey();
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final mediaQuery = MediaQuery.of(context);
    final posterViewportSize = math.min(
      _posterCardSize,
      mediaQuery.size.width - (AppSpacing.lg * 2),
    );

    return Align(
      alignment: Alignment.bottomCenter,
      child: SingleChildScrollView(
        child: Container(
          key: const Key('share-preview-bottom-sheet'),
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F3),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppSpacing.radiusLg),
              topRight: Radius.circular(AppSpacing.radiusLg),
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A000000),
                offset: Offset(0, -4),
                blurRadius: 16,
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.xxl,
              AppSpacing.lg,
              mediaQuery.padding.bottom + AppSpacing.xl,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD1D5DB),
                    borderRadius: BorderRadius.circular(
                      AppSpacing.radiusCircle,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.sharePreviewTitle,
                        style: _inter(
                          20,
                          FontWeight.w600,
                          AppColors.textPrimary,
                        ),
                      ),
                    ),
                    _CloseButton(onPressed: () => Navigator.of(context).pop()),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                SizedBox.square(
                  dimension: posterViewportSize,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: RepaintBoundary(
                      key: _posterKey,
                      child: SizedBox.square(
                        dimension: _posterCardSize,
                        child: _PosterCard(
                          detail: widget.detail,
                          paramEntries: widget.paramEntries,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        key: const Key('share-preview-cancel-button'),
                        onPressed: _isSaving
                            ? null
                            : () => Navigator.of(context).pop(),
                        child: Text(l10n.actionCancel),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: FilledButton(
                        key: const Key('share-preview-save-button'),
                        style: FilledButton.styleFrom(
                          textStyle: AppTextStyles.buttonSecondary,
                        ),
                        onPressed: _isSaving ? null : _savePoster,
                        child: Text(
                          _isSaving
                              ? l10n.sharePreviewSaving
                              : l10n.sharePreviewSavePoster,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _savePoster() async {
    setState(() => _isSaving = true);

    try {
      final messenger = ScaffoldMessenger.of(context);
      final navigator = Navigator.of(context);
      final l10n = context.l10n;

      await WidgetsBinding.instance.endOfFrame;
      final boundary =
          _posterKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
      if (boundary == null) {
        throw StateError('Poster render tree is not ready.');
      }

      final image = await boundary.toImage(pixelRatio: 4);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      image.dispose();
      if (byteData == null) {
        throw StateError('Poster bytes are unavailable.');
      }

      final imageBytes = byteData.buffer.asUint8List();
      await Gal.putImageBytes(
        imageBytes,
        name:
            'brew-poster-${widget.detail.id}-${DateTime.now().millisecondsSinceEpoch}',
        album: 'OneBrew',
      );

      if (!mounted) {
        return;
      }

      navigator.pop();
      messenger.showSnackBar(
        SnackBar(
          content: Text(l10n.sharePreviewSaved),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      final l10n = context.l10n;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.sharePreviewSaveFailed(error.toString())),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}

class _PosterCard extends StatelessWidget {
  const _PosterCard({required this.detail, required this.paramEntries});

  final BrewDetail detail;
  final List<BrewParamEntry> paramEntries;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final rating = _buildPosterRating(context, detail);
    final allMetrics = _buildPosterMetrics(detail, paramEntries, l10n: l10n);
    final gridSpec = _gridSpecFor(allMetrics.length);
    final visibleMetrics = allMetrics.take(gridSpec.maxItems).toList();

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFFD1D5DB),
            offset: Offset(4, 4),
            blurRadius: 12,
          ),
          BoxShadow(
            color: Colors.white,
            offset: Offset(-4, -4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          _posterInnerHorizontalPadding,
          19,
          _posterInnerRightPadding,
          _posterInnerHorizontalPadding,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PosterTopBlock(detail: detail, rating: rating),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: _PosterMetricGrid(metrics: visibleMetrics, spec: gridSpec),
            ),
            _PosterFooter(
              date: _formatPosterDate(
                detail.brewDate,
                localeName: Localizations.localeOf(context).toString(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PosterTopBlock extends StatelessWidget {
  const _PosterTopBlock({required this.detail, required this.rating});

  final BrewDetail detail;
  final _PosterRating rating;

  @override
  Widget build(BuildContext context) {
    final overline = _posterOverline(detail);
    final isDetailed = rating.hasDetailed;
    final beanFontSize = isDetailed ? 22.0 : 22.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (overline != null)
          Text(
            overline,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: _inter(
              isDetailed ? 9 : 11,
              FontWeight.w700,
              AppColors.textSecondary,
              letterSpacing: 1,
            ),
          ),
        if (overline != null) SizedBox(height: isDetailed ? 6 : 6),
        Text(
          detail.beanName,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: _bodoni(
            beanFontSize,
            FontWeight.w700,
            AppColors.textPrimary,
            height: 0.94,
          ),
        ),
        if (isDetailed) ...[
          const SizedBox(height: 6),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 5,
            runSpacing: 5,
            children: _buildScoreSummaryWidgets(context, rating.summaries),
          ),
          if (rating.flavorTags.isNotEmpty) ...[
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: rating.flavorTags
                  .map((tag) => _FlavorTagChip(label: tag))
                  .toList(),
            ),
          ],
        ] else if (rating.quickLabel != null) ...[
          const SizedBox(height: 6),
          _QuickRatingStrip(rating: rating),
          if (rating.flavorTags.isNotEmpty) ...[
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: rating.flavorTags
                  .take(2)
                  .map((tag) => _FlavorTagChip(label: tag))
                  .toList(),
            ),
          ],
        ],
      ],
    );
  }
}

class _PosterMetricGrid extends StatelessWidget {
  const _PosterMetricGrid({required this.metrics, required this.spec});

  final List<_PosterMetric> metrics;
  final _MetricGridSpec spec;

  @override
  Widget build(BuildContext context) {
    final rows = _chunkMetrics(metrics, spec.columns);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var rowIndex = 0; rowIndex < rows.length; rowIndex += 1) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (
                var itemIndex = 0;
                itemIndex < rows[rowIndex].length;
                itemIndex += 1
              ) ...[
                Expanded(
                  child: _MetricCell(
                    metric: rows[rowIndex][itemIndex],
                    labelFontSize: spec.labelFontSize,
                    valueFontSize: spec.valueFontSize,
                    valueHeight: spec.valueHeight,
                  ),
                ),
                if (itemIndex < rows[rowIndex].length - 1)
                  SizedBox(width: spec.columnGap),
              ],
            ],
          ),
          if (rowIndex < rows.length - 1) SizedBox(height: spec.rowGap),
        ],
      ],
    );
  }
}

class _MetricCell extends StatelessWidget {
  const _MetricCell({
    required this.metric,
    required this.labelFontSize,
    required this.valueFontSize,
    required this.valueHeight,
  });

  final _PosterMetric metric;
  final double labelFontSize;
  final double valueFontSize;
  final double valueHeight;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: labelFontSize * 1.35,
          width: double.infinity,
          child: Align(
            alignment: Alignment.centerLeft,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                _posterMetricLabel(context, metric.label),
                maxLines: 1,
                softWrap: false,
                style: _inter(
                  labelFontSize,
                  FontWeight.w500,
                  AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 2),
        SizedBox(
          height: valueHeight,
          width: double.infinity,
          child: Align(
            alignment: Alignment.centerLeft,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                metric.value,
                maxLines: 1,
                softWrap: false,
                style: _outfit(
                  valueFontSize,
                  FontWeight.w700,
                  AppColors.textPrimary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PosterFooter extends StatelessWidget {
  const _PosterFooter({required this.date});

  final String date;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'OneBrew',
          style: _bodoni(14, FontWeight.w700, const Color(0xFFD2B48C)),
        ),
        const Spacer(),
        Text(date, style: _inter(10, FontWeight.w500, const Color(0xFFD1D5DB))),
      ],
    );
  }
}

class _FlavorTagChip extends StatelessWidget {
  const _FlavorTagChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Text(label, style: _inter(9, FontWeight.w600, AppColors.primary)),
    );
  }
}

class _QuickRatingStrip extends StatelessWidget {
  const _QuickRatingStrip({required this.rating});

  final _PosterRating rating;

  @override
  Widget build(BuildContext context) {
    final quickScoreValue = rating.quickScoreValue;
    if (quickScoreValue == null) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _RatingBadge(label: rating.quickLabel!),
          if (rating.quickEmoji != null) ...[
            const SizedBox(width: 10),
            Text(
              rating.quickEmoji!,
              style: _inter(16, FontWeight.w600, AppColors.primary),
            ),
          ],
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _StarRatingRow(score: quickScoreValue),
        const SizedBox(width: 10),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                quickScoreValue.toStringAsFixed(1),
                style: _bodoni(17, FontWeight.w700, AppColors.textPrimary),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(
                  '/5',
                  style: _inter(10, FontWeight.w700, AppColors.textSecondary),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StarRatingRow extends StatelessWidget {
  const _StarRatingRow({required this.score});

  final double score;

  @override
  Widget build(BuildContext context) {
    final clampedScore = score.clamp(0, 5).toDouble();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final fill = (clampedScore - index).clamp(0, 1).toDouble();
        return Padding(
          padding: EdgeInsets.only(right: index == 4 ? 0 : 2),
          child: _FractionalStar(fill: fill),
        );
      }),
    );
  }
}

class _FractionalStar extends StatelessWidget {
  const _FractionalStar({required this.fill});

  final double fill;

  @override
  Widget build(BuildContext context) {
    const size = 13.0;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          Icon(
            Icons.star_rounded,
            size: size,
            color: const Color(0xFFD2B48C).withValues(alpha: 0.24),
          ),
          ClipRect(
            clipper: _FractionalClipper(fill),
            child: Icon(
              Icons.star_rounded,
              size: size,
              color: const Color(0xFFD2B48C),
            ),
          ),
        ],
      ),
    );
  }
}

class _FractionalClipper extends CustomClipper<Rect> {
  const _FractionalClipper(this.fill);

  final double fill;

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, size.width * fill.clamp(0, 1), size.height);
  }

  @override
  bool shouldReclip(covariant _FractionalClipper oldClipper) {
    return oldClipper.fill != fill;
  }
}

class _RatingBadge extends StatelessWidget {
  const _RatingBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label, style: _inter(12, FontWeight.w700, Colors.white)),
    );
  }
}

class _CloseButton extends StatelessWidget {
  const _CloseButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      height: 32,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFFE5E7EB),
          borderRadius: BorderRadius.circular(16),
        ),
        child: IconButton(
          key: const Key('share-preview-close-button'),
          onPressed: onPressed,
          padding: EdgeInsets.zero,
          iconSize: 16,
          splashRadius: 18,
          color: AppColors.textSecondary,
          icon: const Icon(Icons.close_rounded),
        ),
      ),
    );
  }
}

class _PosterMetric {
  const _PosterMetric(this.label, this.value);

  final String label;
  final String value;
}

class _PosterRating {
  const _PosterRating({
    required this.quickLabel,
    required this.quickScoreValue,
    required this.quickEmoji,
    required this.summaries,
    required this.flavorTags,
  });

  final String? quickLabel;
  final double? quickScoreValue;
  final String? quickEmoji;
  final List<String> summaries;
  final List<String> flavorTags;

  bool get hasDetailed => summaries.isNotEmpty;
}

class _MetricGridSpec {
  const _MetricGridSpec({
    required this.columns,
    required this.maxItems,
    required this.labelFontSize,
    required this.valueFontSize,
    required this.valueHeight,
    required this.columnGap,
    required this.rowGap,
  });

  final int columns;
  final int maxItems;
  final double labelFontSize;
  final double valueFontSize;
  final double valueHeight;
  final double columnGap;
  final double rowGap;
}

_MetricGridSpec _gridSpecFor(int count) {
  if (count >= 7) {
    return const _MetricGridSpec(
      columns: 3,
      maxItems: 9,
      labelFontSize: 8.5,
      valueFontSize: 13,
      valueHeight: 20,
      columnGap: 16,
      rowGap: 12,
    );
  }
  if (count >= 5) {
    return const _MetricGridSpec(
      columns: 3,
      maxItems: 6,
      labelFontSize: 10.5,
      valueFontSize: 17.5,
      valueHeight: 26,
      columnGap: 24,
      rowGap: 16,
    );
  }
  return const _MetricGridSpec(
    columns: 2,
    maxItems: 4,
    labelFontSize: 10.5,
    valueFontSize: 20,
    valueHeight: 30,
    columnGap: 16,
    rowGap: 16,
  );
}

List<List<_PosterMetric>> _chunkMetrics(
  List<_PosterMetric> metrics,
  int columns,
) {
  final rows = <List<_PosterMetric>>[];
  for (var index = 0; index < metrics.length; index += columns) {
    final end = math.min(index + columns, metrics.length);
    rows.add(metrics.sublist(index, end));
  }
  return rows;
}

String? _posterOverline(BrewDetail detail) {
  final parts = <String>[
    if (_clean(detail.roaster) case final roaster?) roaster.toUpperCase(),
    if (_clean(detail.roastLevel) case final roast?) roast.toUpperCase(),
  ];
  if (parts.isEmpty) {
    return null;
  }
  return parts.join(' • ');
}

List<Widget> _buildScoreSummaryWidgets(
  BuildContext context,
  List<String> summaries,
) {
  final widgets = <Widget>[];
  for (var index = 0; index < summaries.length; index += 1) {
    widgets.add(
      Text(
        _posterScoreSummary(context, summaries[index]),
        style: _outfit(
          9,
          FontWeight.w700,
          AppColors.textPrimary,
          letterSpacing: 1,
        ),
      ),
    );
    if (index < summaries.length - 1) {
      widgets.add(
        Text('•', style: _inter(9, FontWeight.w400, const Color(0xFFD1D5DB))),
      );
    }
  }
  return widgets;
}

String _posterMetricLabel(BuildContext context, String label) {
  final l10n = context.l10n;
  switch (label) {
    case 'DOSE':
      return l10n.posterMetricDose;
    case 'YIELD':
      return l10n.posterMetricYield;
    case 'RATIO':
      return l10n.posterMetricRatio;
    case 'TIME':
      return l10n.posterMetricTime;
    case 'TEMP':
      return l10n.posterMetricTemp;
    case 'GRIND':
      return l10n.posterMetricGrind;
    case 'BLOOM':
      return l10n.posterMetricBloom;
    case 'POUR':
      return l10n.posterMetricPour;
    case 'WATER':
      return l10n.posterMetricWater;
    case 'ROOM':
      return l10n.posterMetricRoom;
    default:
      return label;
  }
}

String _posterScoreSummary(BuildContext context, String raw) {
  final l10n = context.l10n;
  final parts = raw.split(' ');
  if (parts.length < 2) {
    return raw;
  }
  final key = parts.first;
  final value = raw.substring(key.length).trimLeft();
  final label = switch (key) {
    'ACID' => l10n.posterScoreAcid,
    'SWEET' => l10n.posterScoreSweet,
    'BITTER' => l10n.posterScoreBitter,
    'BODY' => l10n.posterScoreBody,
    _ => key,
  };
  return '$label $value'.trim();
}

_PosterRating _buildPosterRating(BuildContext context, BrewDetail detail) {
  return _PosterRating(
    quickLabel: _hasQuickRating(detail) ? _quickBadge(detail) : null,
    quickScoreValue: detail.quickScore?.toDouble(),
    quickEmoji: _clean(detail.emoji),
    summaries: _scoreSummaries(detail),
    flavorTags: _flavorTags(context, detail).take(3).toList(),
  );
}

List<_PosterMetric> _buildPosterMetrics(
  BrewDetail detail,
  List<BrewParamEntry> paramEntries, {
  required AppLocalizations l10n,
}) {
  final metrics = <_PosterMetric>[];
  final semanticIds = <String>{};

  void addMetric(_PosterMetric? metric, {String? semanticId}) {
    if (metric == null) {
      return;
    }
    if (semanticId != null && !semanticIds.add(semanticId)) {
      return;
    }
    metrics.add(metric);
  }

  addMetric(_doseMetric(detail), semanticId: 'dose');
  addMetric(_yieldMetric(detail), semanticId: 'yield');

  for (final entry in paramEntries) {
    final metric = _metricFromEntry(entry, l10n: l10n);
    if (metric == null) {
      continue;
    }
    final semanticId = _semanticIdForEntry(entry);
    addMetric(metric, semanticId: semanticId);
  }

  addMetric(_ratioMetric(detail), semanticId: 'ratio');
  addMetric(_timeMetric(detail), semanticId: 'time');
  addMetric(_temperatureMetric(detail), semanticId: 'temp');
  addMetric(_grindMetric(detail, l10n: l10n), semanticId: 'grind');
  addMetric(_bloomMetric(detail), semanticId: 'bloom');
  addMetric(_pourMetric(detail), semanticId: 'pour');
  addMetric(_waterTypeMetric(detail), semanticId: 'water-type');
  addMetric(_roomTempMetric(detail), semanticId: 'room-temp');

  return metrics;
}

_PosterMetric _doseMetric(BrewDetail detail) =>
    _PosterMetric('DOSE', _formatWeight(detail.coffeeWeightG, decimals: 1));

_PosterMetric _yieldMetric(BrewDetail detail) =>
    _PosterMetric('YIELD', _formatWeight(detail.waterWeightG, decimals: 1));

_PosterMetric? _ratioMetric(BrewDetail detail) {
  if (detail.coffeeWeightG <= 0) {
    return null;
  }
  return _PosterMetric(
    'RATIO',
    '1:${(detail.waterWeightG / detail.coffeeWeightG).toStringAsFixed(1)}',
  );
}

_PosterMetric? _timeMetric(BrewDetail detail) {
  final value = _formatDuration(detail.brewDurationS);
  return value == null ? null : _PosterMetric('TIME', value);
}

_PosterMetric? _temperatureMetric(BrewDetail detail) {
  final value = _formatTemperature(detail.waterTempC);
  return value == null ? null : _PosterMetric('TEMP', value);
}

_PosterMetric? _grindMetric(
  BrewDetail detail, {
  required AppLocalizations l10n,
}) {
  final value = _formatGrind(detail, l10n: l10n);
  return value == null ? null : _PosterMetric('GRIND', value);
}

_PosterMetric? _bloomMetric(BrewDetail detail) {
  final seconds = detail.bloomTimeS;
  if (seconds == null || seconds <= 0) {
    return null;
  }
  return _PosterMetric('BLOOM', '${seconds}s');
}

_PosterMetric? _pourMetric(BrewDetail detail) {
  final value = _clean(detail.pourMethod);
  return value == null ? null : _PosterMetric('POUR', value);
}

_PosterMetric? _waterTypeMetric(BrewDetail detail) {
  final value = _clean(detail.waterType);
  return value == null ? null : _PosterMetric('WATER', value);
}

_PosterMetric? _roomTempMetric(BrewDetail detail) {
  final value = detail.roomTempC;
  if (value == null) {
    return null;
  }
  final text = value % 1 == 0
      ? value.toStringAsFixed(0)
      : value.toStringAsFixed(1);
  return _PosterMetric('ROOM', '$text°C');
}

_PosterMetric? _metricFromEntry(
  BrewParamEntry entry, {
  required AppLocalizations l10n,
}) {
  final rawValue = _clean(entry.value);
  if (rawValue == null) {
    return null;
  }
  final value = localizedParamValue(
    l10n: l10n,
    paramKey: entry.paramKey,
    value: rawValue,
  );
  return _PosterMetric(_displayMetricLabel(entry), value);
}

String _displayMetricLabel(BrewParamEntry entry) {
  final semanticId = resolveParamKey(
    paramKey: entry.paramKey,
    name: entry.name,
  );
  switch (semanticId) {
    case BrewParamKeys.coffeeWeight:
    case BrewParamKeys.coffeeDose:
      return 'DOSE';
    case BrewParamKeys.waterWeight:
    case BrewParamKeys.yieldAmount:
      return 'YIELD';
    case BrewParamKeys.brewRatio:
      return 'RATIO';
    case BrewParamKeys.brewTime:
    case BrewParamKeys.extractionTime:
      return 'TIME';
    case BrewParamKeys.waterTemp:
      return 'TEMP';
    case BrewParamKeys.grindSize:
      return 'GRIND';
    case BrewParamKeys.bloomTime:
    case BrewParamKeys.bloomWater:
      return 'BLOOM';
    case BrewParamKeys.pourMethod:
      return 'POUR';
    default:
      return _compactMetricLabel(entry.name);
  }
}

String? _semanticIdForEntry(BrewParamEntry entry) {
  final resolvedKey = resolveParamKey(
    paramKey: entry.paramKey,
    name: entry.name,
  );
  if (resolvedKey == BrewParamKeys.coffeeWeight ||
      resolvedKey == BrewParamKeys.coffeeDose) {
    return 'dose';
  }
  if (resolvedKey == BrewParamKeys.waterWeight ||
      resolvedKey == BrewParamKeys.yieldAmount) {
    return 'yield';
  }
  if (resolvedKey == BrewParamKeys.brewRatio) {
    return 'ratio';
  }
  if (resolvedKey == BrewParamKeys.brewTime ||
      resolvedKey == BrewParamKeys.extractionTime) {
    return 'time';
  }
  if (resolvedKey == BrewParamKeys.waterTemp) {
    return 'temp';
  }
  if (resolvedKey == BrewParamKeys.grindSize) {
    return 'grind';
  }
  if (resolvedKey == BrewParamKeys.bloomTime ||
      resolvedKey == BrewParamKeys.bloomWater) {
    return 'bloom';
  }
  if (resolvedKey == BrewParamKeys.pourMethod) {
    return 'pour';
  }
  return null;
}

String _compactMetricLabel(String raw) {
  final cleaned = raw.trim().replaceAll(RegExp(r'\s+'), ' ');
  if (cleaned.isEmpty) {
    return '--';
  }

  final upper = cleaned.toUpperCase();
  if (upper.length <= 12 && !RegExp(r'[/&_+-]').hasMatch(cleaned)) {
    return upper;
  }

  if (cleaned.contains('/')) {
    return cleaned
        .split('/')
        .map(_compactMetricChunk)
        .where((part) => part.isNotEmpty)
        .join('/');
  }

  if (cleaned.contains('&')) {
    return cleaned
        .split('&')
        .map(_compactMetricChunk)
        .where((part) => part.isNotEmpty)
        .join('&');
  }

  return _compactMetricChunk(cleaned);
}

String _compactMetricChunk(String raw) {
  final tokens = raw
      .split(RegExp(r'[\s+_-]+'))
      .map((token) => token.trim())
      .where((token) => token.isNotEmpty)
      .toList();

  if (tokens.isEmpty) {
    return '';
  }
  if (tokens.length == 1) {
    return _compactMetricWord(tokens.first);
  }

  return tokens.map(_compactMetricWord).join(' ');
}

String _compactMetricWord(String raw) {
  final upper = raw.toUpperCase();
  if (upper.length <= 5 || RegExp(r'\d').hasMatch(upper)) {
    return upper;
  }
  return upper.substring(0, 4);
}

List<String> _scoreSummaries(BrewDetail detail) {
  final scores = <String>[];
  if (detail.acidity != null) {
    scores.add('ACID ${detail.acidity!.toStringAsFixed(1)}');
  }
  if (detail.sweetness != null) {
    scores.add('SWEET ${detail.sweetness!.toStringAsFixed(1)}');
  }
  if (detail.bitterness != null) {
    scores.add('BITTER ${detail.bitterness!.toStringAsFixed(1)}');
  }
  if (detail.body != null) {
    scores.add('BODY ${detail.body!.toStringAsFixed(1)}');
  }
  return scores;
}

List<String> _flavorTags(BuildContext context, BrewDetail detail) {
  final raw = detail.flavorNotes?.trim();
  if (raw == null || raw.isEmpty) {
    return const [];
  }

  return raw
      .split(RegExp(r'[,;/·]'))
      .map((value) => value.trim())
      .where((value) => value.isNotEmpty)
      .map((value) => _displayFlavorTag(context, value))
      .toList();
}

String _displayFlavorTag(BuildContext context, String value) {
  final localized = flavorNoteLabel(value, context.l10n);
  if (localized != value) {
    return localized;
  }
  if (!RegExp(r'[A-Za-z]').hasMatch(value)) {
    return value;
  }
  return _capitalizeWords(value);
}

bool _hasQuickRating(BrewDetail detail) {
  return detail.quickScore != null ||
      (detail.emoji != null && detail.emoji!.trim().isNotEmpty);
}

String _quickBadge(BrewDetail detail) {
  final score = detail.quickScore;
  final emoji = _clean(detail.emoji);
  if (score == null && emoji == null) {
    return '★ --';
  }
  if (score == null) {
    return emoji!;
  }
  return '★ ${score.toStringAsFixed(1)}';
}

String? _formatGrind(BrewDetail detail, {required AppLocalizations l10n}) {
  switch (detail.grindMode) {
    case GrindMode.equipment:
      final equipment = _shortEquipment(detail.equipmentName);
      final click = detail.grindClickValue;
      if (equipment == null && click == null) {
        return null;
      }
      if (click == null) {
        return equipment;
      }
      final rounded = click % 1 == 0
          ? click.toStringAsFixed(0)
          : click.toStringAsFixed(1);
      if (equipment == null) {
        return '$rounded Clicks';
      }
      return '$equipment #$rounded';
    case GrindMode.simple:
      final label = _clean(detail.grindSimpleLabel);
      if (label == null) {
        return null;
      }
      return localizeGrindSimpleLabel(l10n, label);
    case GrindMode.pro:
      return detail.grindMicrons == null ? null : '${detail.grindMicrons} μm';
  }
}

String? _shortEquipment(String? raw) {
  final cleaned = _clean(raw);
  if (cleaned == null) {
    return null;
  }

  final pieces = cleaned.split(RegExp(r'\s+'));
  for (final piece in pieces.reversed) {
    if (RegExp(r'[A-Za-z]+\d+').hasMatch(piece)) {
      return piece.toUpperCase();
    }
  }
  return pieces.length == 1 ? cleaned : pieces.last;
}

String _formatWeight(double value, {int? decimals}) {
  final resolvedDecimals = decimals ?? (value % 1 == 0 ? 0 : 1);
  return '${value.toStringAsFixed(resolvedDecimals)}g';
}

String? _formatTemperature(double? value) {
  if (value == null) {
    return null;
  }
  final text = value % 1 == 0
      ? value.toStringAsFixed(0)
      : value.toStringAsFixed(1);
  return '$text°C';
}

String? _formatDuration(int seconds) {
  if (seconds <= 0) {
    return null;
  }
  final minutes = seconds ~/ 60;
  final remaining = seconds % 60;
  return '${minutes.toString().padLeft(2, '0')}:${remaining.toString().padLeft(2, '0')}';
}

String _formatPosterDate(DateTime date, {required String localeName}) {
  return DateFormat.yMMMd(localeName).format(date);
}

String? _clean(String? value) {
  final trimmed = value?.trim();
  if (trimmed == null || trimmed.isEmpty) {
    return null;
  }
  return trimmed;
}

String _capitalizeWords(String value) {
  return value
      .split(RegExp(r'\s+'))
      .where((token) => token.isNotEmpty)
      .map((token) {
        final lower = token.toLowerCase();
        return '${lower[0].toUpperCase()}${lower.substring(1)}';
      })
      .join(' ');
}

TextStyle _bodoni(
  double size,
  FontWeight weight,
  Color color, {
  double? height,
  double? letterSpacing,
}) {
  return GoogleFonts.bodoniModa(
    fontSize: size,
    fontWeight: weight,
    color: color,
    height: height,
    letterSpacing: letterSpacing,
  );
}

TextStyle _inter(
  double size,
  FontWeight weight,
  Color color, {
  double? height,
  double? letterSpacing,
}) {
  return GoogleFonts.inter(
    fontSize: size,
    fontWeight: weight,
    color: color,
    height: height,
    letterSpacing: letterSpacing,
  );
}

TextStyle _outfit(
  double size,
  FontWeight weight,
  Color color, {
  double? height,
  double? letterSpacing,
}) {
  return GoogleFonts.outfit(
    fontSize: size,
    fontWeight: weight,
    color: color,
    height: height,
    letterSpacing: letterSpacing,
  );
}
