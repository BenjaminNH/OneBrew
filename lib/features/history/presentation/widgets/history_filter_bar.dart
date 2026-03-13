import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_chip_input.dart';
import '../../../inventory/presentation/controllers/inventory_controller.dart';
import '../../domain/repositories/history_repository.dart';

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
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: AppChipInput(
                  key: const Key('history-filter-bean-input'),
                  tags: _beanTags,
                  suggestions: _beanSuggestions,
                  singleSelection: true,
                  hintText: 'Bean name',
                  onTagsChanged: (tags) {
                    setState(() {
                      _beanTags = tags;
                      _beanQuery = tags.isEmpty ? '' : tags.first;
                    });
                  },
                  onInputChanged: (value) {
                    _beanQuery = value;
                  },
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
