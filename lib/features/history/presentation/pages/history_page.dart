import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/router/app_route_paths.dart';
import '../controllers/history_controller.dart';
import '../widgets/brew_record_card.dart';
import '../widgets/brew_stats_header.dart';
import '../widgets/history_filter_bar.dart';

class HistoryPage extends ConsumerStatefulWidget {
  const HistoryPage({super.key, this.onOpenDetail});

  final ValueChanged<int>? onOpenDetail;

  @override
  ConsumerState<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends ConsumerState<HistoryPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(historyControllerProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(historyControllerProvider);

    ref.listen<HistoryState>(historyControllerProvider, (_, next) {
      final message = next.errorMessage;
      if (message == null || message.isEmpty) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: AppColors.error),
      );
      ref.read(historyControllerProvider.notifier).clearError();
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.pageHorizontal,
                AppSpacing.pageTop,
                AppSpacing.pageHorizontal,
                AppSpacing.sm,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Brew History',
                  style: AppTextStyles.displayMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.pageHorizontal,
              ),
              child: BrewStatsHeader(
                stats: state.stats,
                topBrews: state.topBrews,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.pageHorizontal,
              ),
              child: HistoryFilterBar(
                filter: state.filter,
                onFilterChanged: (filter) async {
                  await ref
                      .read(historyControllerProvider.notifier)
                      .applyFilter(filter);
                },
                onClear: () async {
                  await ref
                      .read(historyControllerProvider.notifier)
                      .clearFilter();
                },
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Expanded(
              child: Builder(
                builder: (context) {
                  if (state.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  }
                  if (state.visibleBrews.isEmpty) {
                    return Center(
                      child: Text(
                        'No brew records match the current filter.',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  return ListView.separated(
                    key: const Key('history-brew-list'),
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.pageHorizontal,
                      0,
                      AppSpacing.pageHorizontal,
                      AppSpacing.pageBottom,
                    ),
                    itemCount: state.visibleBrews.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpacing.cardGap),
                    itemBuilder: (context, index) {
                      final summary = state.visibleBrews[index];
                      return BrewRecordCard(
                        summary: summary,
                        onTap: () {
                          if (widget.onOpenDetail != null) {
                            widget.onOpenDetail!(summary.id);
                            return;
                          }
                          context.push(AppRoutePaths.historyDetail(summary.id));
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
