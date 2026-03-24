import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/router/app_route_paths.dart';
import '../../../../l10n/l10n.dart';
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
  Widget build(BuildContext context) {
    final state = ref.watch(historyControllerProvider);
    final l10n = context.l10n;

    ref.listen<HistoryState>(historyControllerProvider, (_, next) {
      final message = next.errorMessage;
      if (message == null || message.isEmpty) return;
      final localized = _localizeErrorMessage(message, l10n: l10n);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localized), backgroundColor: AppColors.error),
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
                  l10n.historyTitle,
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
              child: BrewStatsHeader(stats: state.stats),
            ),
            const SizedBox(height: AppSpacing.xs),
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
            const SizedBox(height: AppSpacing.xs),
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
                        l10n.historyEmptyFiltered,
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
                        onTap: () async {
                          if (widget.onOpenDetail != null) {
                            widget.onOpenDetail!(summary.id);
                            return;
                          }
                          await context.push(
                            AppRoutePaths.historyDetail(summary.id),
                          );
                          if (!mounted) {
                            return;
                          }
                          await ref
                              .read(historyControllerProvider.notifier)
                              .load();
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

String _localizeErrorMessage(
  String message, {
  required dynamic l10n,
}) {
  final normalized = message.toLowerCase();
  if (normalized.startsWith('failed to load history')) {
    return l10n.historyErrorLoad as String;
  }
  if (normalized.startsWith('failed to filter history')) {
    return l10n.historyErrorFilter as String;
  }
  if (normalized.startsWith('failed to reset history filter')) {
    return l10n.historyErrorReset as String;
  }
  return message;
}
