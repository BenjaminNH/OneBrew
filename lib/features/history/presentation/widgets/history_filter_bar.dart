import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_single_select_field.dart';
import '../../../../l10n/l10n.dart';
import '../../../inventory/presentation/controllers/inventory_controller.dart';
import '../../domain/repositories/history_repository.dart';

const _filterControlHeight = 44.0;
const _filterControlRadius = AppSpacing.radiusSm;

class HistoryFilterBar extends ConsumerStatefulWidget {
  const HistoryFilterBar({
    super.key,
    required this.filter,
    required this.onFilterChanged,
    required this.onClear,
  });

  final BrewFilter filter;
  final ValueChanged<BrewFilter> onFilterChanged;
  final VoidCallback onClear;

  @override
  ConsumerState<HistoryFilterBar> createState() => _HistoryFilterBarState();
}

class _HistoryFilterBarState extends ConsumerState<HistoryFilterBar> {
  List<String> _beanSuggestions = [];
  List<String> _beanTags = [];
  String _beanQuery = '';
  int? _minScore;
  DateTime? _from;
  DateTime? _to;

  @override
  void initState() {
    super.initState();
    final initialBean = widget.filter.beanName?.trim() ?? '';
    _beanQuery = initialBean;
    _beanTags = initialBean.isEmpty ? const [] : [initialBean];
    _minScore = widget.filter.minScore;
    _from = widget.filter.from;
    _to = widget.filter.to;
    _loadBeanSuggestions();
  }

  @override
  void didUpdateWidget(covariant HistoryFilterBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.filter != oldWidget.filter) {
      final nextBean = widget.filter.beanName?.trim() ?? '';
      _beanQuery = nextBean;
      _beanTags = nextBean.isEmpty ? const [] : [nextBean];
      _minScore = widget.filter.minScore;
      _from = widget.filter.from;
      _to = widget.filter.to;
    }
  }

  Future<void> _loadBeanSuggestions() async {
    final suggestions = await ref
        .read(inventoryControllerProvider.notifier)
        .getBeanSuggestions('');
    if (!mounted) return;
    setState(() {
      _beanSuggestions = suggestions.map((bean) => bean.name).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final localeName = Localizations.localeOf(context).toString();
    final hasActiveFilter =
        _beanQuery.trim().isNotEmpty ||
        _minScore != null ||
        _from != null ||
        _to != null;
    final surfaceDecoration = _controlDecoration();

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: AppSingleSelectField(
              key: const Key('history-filter-bean-input'),
              value: _beanTags.isEmpty ? null : _beanTags.first,
              suggestions: _beanSuggestions,
              hintText: l10n.historyFilterBeanHint,
              addActionLabel: l10n.historyFilterBeanAddAction,
              dialogTitle: l10n.historyFilterBeanDialogTitle,
              dialogHintText: l10n.historyFilterBeanDialogHint,
              dialogConfirmLabel: l10n.historyFilterBeanDialogConfirm,
              showInlineClearButton: false,
              minFieldHeight: _filterControlHeight,
              fieldPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              backgroundColor: AppColors.background,
              border: surfaceDecoration.border,
              boxShadow: surfaceDecoration.boxShadow,
              onChanged: (value) {
                setState(() {
                  _beanTags = value == null ? const [] : [value];
                  _beanQuery = value?.trim() ?? '';
                });
                _applyFilter();
              },
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          SizedBox(
            width: 92,
            child: DecoratedBox(
              decoration: surfaceDecoration,
              child: SizedBox(
                height: _filterControlHeight,
                child: DropdownButton<int?>(
                  key: const Key('history-filter-score-dropdown'),
                  value: _minScore,
                  isExpanded: true,
                  underline: const SizedBox.shrink(),
                  borderRadius: BorderRadius.circular(_filterControlRadius),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  icon: const Icon(Icons.expand_more_rounded),
                  selectedItemBuilder: (context) {
                    final labels = <String>[
                      l10n.historyFilterScoreAll,
                      '≥3',
                      '≥4',
                      '5',
                    ];
                    return labels
                        .map(
                          (label) => Align(
                            alignment: Alignment.centerLeft,
                            child: Text(label, style: AppTextStyles.bodyMedium),
                          ),
                        )
                        .toList(growable: false);
                  },
                  hint: Text(
                    l10n.historyFilterScoreHint,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  items: [
                    DropdownMenuItem<int?>(
                      value: null,
                      child: Text(l10n.historyFilterScoreAll),
                    ),
                    const DropdownMenuItem<int?>(value: 3, child: Text('≥3')),
                    const DropdownMenuItem<int?>(value: 4, child: Text('≥4')),
                    const DropdownMenuItem<int?>(value: 5, child: Text('5')),
                  ],
                  onChanged: (value) {
                    setState(() => _minScore = value);
                    _applyFilter();
                  },
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          _CompactActionButton(
            key: const Key('history-filter-date-button'),
            tooltip: _dateRangeLabel(l10n: l10n, localeName: localeName),
            icon: Icons.date_range_rounded,
            isActive: _from != null || _to != null,
            onPressed: _pickDateRange,
          ),
          if (hasActiveFilter) ...[
            const SizedBox(width: AppSpacing.xs),
            _CompactActionButton(
              key: const Key('history-filter-clear'),
              tooltip: l10n.historyFilterClearTooltip,
              icon: Icons.refresh_rounded,
              onPressed: _clear,
            ),
          ],
        ],
      ),
    );
  }

  String _dateRangeLabel({
    required dynamic l10n,
    required String localeName,
  }) {
    if (_from == null || _to == null) {
      return l10n.historyFilterAnyDate as String;
    }
    return '${AppDateUtils.formatDateShort(_from!, localeName: localeName)} - ${AppDateUtils.formatDateShort(_to!, localeName: localeName)}';
  }

  Future<void> _pickDateRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 1),
      initialDateRange: (_from != null && _to != null)
          ? DateTimeRange(start: _from!, end: _to!)
          : null,
    );
    if (picked == null) return;
    setState(() {
      _from = picked.start;
      _to = DateTime(
        picked.end.year,
        picked.end.month,
        picked.end.day,
        23,
        59,
        59,
      );
    });
    _applyFilter();
  }

  void _applyFilter() {
    final beanName = _beanQuery.trim().isNotEmpty
        ? _beanQuery.trim()
        : (_beanTags.isEmpty ? '' : _beanTags.first.trim());
    final minScore = _minScore;
    final maxScore = (minScore == 5) ? 5 : null;
    final from = _from;
    final to = _to;

    widget.onFilterChanged(
      BrewFilter(
        beanName: beanName.isEmpty ? null : beanName,
        minScore: minScore,
        maxScore: maxScore,
        from: from,
        to: to,
      ),
    );
  }

  void _clear() {
    setState(() {
      _beanTags = [];
      _beanQuery = '';
      _minScore = null;
      _from = null;
      _to = null;
    });
    widget.onClear();
  }
}

class _CompactActionButton extends StatelessWidget {
  const _CompactActionButton({
    super.key,
    required this.tooltip,
    required this.icon,
    required this.onPressed,
    this.isActive = false,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final foreground = isActive ? Colors.white : AppColors.textPrimary;
    final decoration = BoxDecoration(
      color: isActive ? AppColors.primary : AppColors.background,
      borderRadius: BorderRadius.circular(_filterControlRadius),
      boxShadow: isActive
          ? [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.18),
                offset: const Offset(0, 2),
                blurRadius: 6,
              ),
            ]
          : AppColors.debossedShadow,
    );

    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(_filterControlRadius),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(_filterControlRadius),
          child: SizedBox(
            width: _filterControlHeight,
            height: _filterControlHeight,
            child: DecoratedBox(
              decoration: decoration,
              child: Icon(icon, size: AppSpacing.iconAction, color: foreground),
            ),
          ),
        ),
      ),
    );
  }
}

BoxDecoration _controlDecoration() {
  return BoxDecoration(
    color: AppColors.background,
    borderRadius: BorderRadius.circular(_filterControlRadius),
    boxShadow: AppColors.debossedShadow,
  );
}
