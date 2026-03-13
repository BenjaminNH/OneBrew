import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/widgets/app_card.dart';
import '../../domain/repositories/history_repository.dart';

class HistoryFilterBar extends StatefulWidget {
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
  State<HistoryFilterBar> createState() => _HistoryFilterBarState();
}

class _HistoryFilterBarState extends State<HistoryFilterBar> {
  late final TextEditingController _beanController;
  int? _minScore;
  DateTime? _from;
  DateTime? _to;

  @override
  void initState() {
    super.initState();
    _beanController = TextEditingController(text: widget.filter.beanName ?? '');
    _minScore = widget.filter.minScore;
    _from = widget.filter.from;
    _to = widget.filter.to;
  }

  @override
  void didUpdateWidget(covariant HistoryFilterBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.filter != oldWidget.filter) {
      _beanController.text = widget.filter.beanName ?? '';
      _minScore = widget.filter.minScore;
      _from = widget.filter.from;
      _to = widget.filter.to;
    }
  }

  @override
  void dispose() {
    _beanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  key: const Key('history-filter-bean-input'),
                  controller: _beanController,
                  decoration: InputDecoration(
                    hintText: 'Bean name',
                    hintStyle: AppTextStyles.bodySmall,
                    prefixIcon: const Icon(Icons.coffee_outlined),
                    filled: true,
                    fillColor: AppColors.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.sm,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: DropdownButton<int?>(
                    key: const Key('history-filter-score-dropdown'),
                    value: _minScore,
                    isExpanded: true,
                    underline: const SizedBox.shrink(),
                    hint: Text('Min ★', style: AppTextStyles.bodySmall),
                    items: const [
                      DropdownMenuItem<int?>(value: null, child: Text('All')),
                      DropdownMenuItem<int?>(value: 3, child: Text('≥3')),
                      DropdownMenuItem<int?>(value: 4, child: Text('≥4')),
                      DropdownMenuItem<int?>(value: 5, child: Text('5 only')),
                    ],
                    onChanged: (value) => setState(() => _minScore = value),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  key: const Key('history-filter-date-button'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: BorderSide(
                      color: AppColors.shadowDark.withValues(alpha: 0.8),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                  ),
                  onPressed: _pickDateRange,
                  icon: const Icon(Icons.date_range_rounded),
                  label: Text(
                    _dateRangeLabel(),
                    style: AppTextStyles.labelLarge,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              IconButton.filled(
                key: const Key('history-filter-apply'),
                tooltip: 'Search history',
                onPressed: _applyFilter,
                icon: const Icon(Icons.search_rounded),
              ),
              const SizedBox(width: AppSpacing.xs),
              IconButton(
                key: const Key('history-filter-clear'),
                tooltip: 'Clear filters',
                onPressed: _clear,
                icon: const Icon(Icons.refresh_rounded),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _dateRangeLabel() {
    if (_from == null || _to == null) return 'Any date';
    return '${AppDateUtils.formatDateShort(_from!)} - ${AppDateUtils.formatDateShort(_to!)}';
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
  }

  void _applyFilter() {
    final beanName = _beanController.text.trim();
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
      _beanController.clear();
      _minScore = null;
      _from = null;
      _to = null;
    });
    widget.onClear();
  }
}
