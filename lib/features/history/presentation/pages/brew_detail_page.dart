import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../brew_logger/domain/entities/brew_record.dart';
import '../../domain/entities/brew_detail.dart';
import '../controllers/brew_detail_controller.dart';

class BrewDetailPage extends ConsumerWidget {
  const BrewDetailPage({super.key, required this.brewId, this.onBrewAgain});

  final int brewId;
  final VoidCallback? onBrewAgain;

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
                context.go('/brew?templateRecordId=${detail.id}');
              },
            );
          },
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    required this.detail,
    required this.paramEntries,
    required this.onBrewAgain,
  });

  final BrewDetail detail;
  final List<BrewParamEntry> paramEntries;
  final VoidCallback onBrewAgain;

  @override
  Widget build(BuildContext context) {
    final hasParamEntries = paramEntries.isNotEmpty;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pageHorizontal,
        AppSpacing.pageTop,
        AppSpacing.pageHorizontal,
        AppSpacing.pageBottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back_rounded),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text('Brew Detail', style: AppTextStyles.displayMedium),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          _SectionCard(
            title: 'Basic',
            children: [
              _DataRow(
                label: 'Brew Time',
                value: AppDateUtils.formatDateTimeFull(detail.brewDate),
              ),
              _DataRow(label: 'Bean', value: _text(detail.beanName)),
              _DataRow(label: 'Roaster', value: _text(detail.roaster)),
              _DataRow(label: 'Origin', value: _text(detail.origin)),
              _DataRow(label: 'Roast Level', value: _text(detail.roastLevel)),
              _DataRow(label: 'Duration', value: '${detail.brewDurationS}s'),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (hasParamEntries) ...[
            _SectionCard(
              title: 'Recorded Params',
              children: paramEntries
                  .map((entry) => _DataRow(label: entry.name, value: entry.value))
                  .toList(),
            ),
            if (detail.waterType != null || detail.roomTempC != null) ...[
              const SizedBox(height: AppSpacing.md),
              _SectionCard(
                title: 'Environment',
                children: [
                  _DataRow(label: 'Water Type', value: _text(detail.waterType)),
                  _DataRow(
                    label: 'Room Temp',
                    value: _double(detail.roomTempC, suffix: '°C'),
                  ),
                ],
              ),
            ],
          ] else ...[
            _SectionCard(
              title: 'Brew Params',
              children: [
                _DataRow(
                  label: 'Coffee',
                  value: '${detail.coffeeWeightG.toStringAsFixed(1)}g',
                ),
                _DataRow(
                  label: 'Water',
                  value: '${detail.waterWeightG.toStringAsFixed(0)}g',
                ),
                _DataRow(
                  label: 'Ratio',
                  value: _ratio(detail.coffeeWeightG, detail.waterWeightG),
                ),
                _DataRow(
                  label: 'Water Temp',
                  value: _double(detail.waterTempC, suffix: '°C'),
                ),
                _DataRow(
                  label: 'Bloom Time',
                  value: _int(detail.bloomTimeS, suffix: 's'),
                ),
                _DataRow(label: 'Pour Method', value: _text(detail.pourMethod)),
                _DataRow(label: 'Water Type', value: _text(detail.waterType)),
                _DataRow(
                  label: 'Room Temp',
                  value: _double(detail.roomTempC, suffix: '°C'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            _SectionCard(
              title: 'Grind',
              children: [
                _DataRow(label: 'Mode', value: _grindMode(detail.grindMode)),
                _DataRow(label: 'Value', value: _grindValue(detail)),
              ],
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          _SectionCard(
            title: 'Rating',
            children: [
              _DataRow(
                label: 'Quick',
                value: _quickRating(detail.quickScore, detail.emoji),
              ),
              _DataRow(label: 'Acidity', value: _double(detail.acidity)),
              _DataRow(label: 'Sweetness', value: _double(detail.sweetness)),
              _DataRow(label: 'Bitterness', value: _double(detail.bitterness)),
              _DataRow(label: 'Body', value: _double(detail.body)),
              _DataRow(label: 'Flavor Notes', value: _text(detail.flavorNotes)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _SectionCard(
            title: 'Meta',
            children: [
              _DataRow(label: 'Notes', value: _text(detail.notes)),
              _DataRow(
                label: 'Created At',
                value: AppDateUtils.formatDateTimeFull(detail.createdAt),
              ),
              _DataRow(
                label: 'Updated At',
                value: AppDateUtils.formatDateTimeFull(detail.updatedAt),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              key: const Key('brew-detail-brew-again'),
              onPressed: onBrewAgain,
              icon: const Icon(Icons.replay_rounded),
              label: const Text('Brew Again'),
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
                color: value == '--'
                    ? AppColors.textSecondary
                    : AppColors.textPrimary,
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

String _grindValue(BrewDetail detail) {
  switch (detail.grindMode) {
    case GrindMode.equipment:
      final equipment = _text(detail.equipmentName);
      final click = _double(detail.grindClickValue);
      final unit = _text(detail.grindClickUnit ?? 'clicks');
      if (click == '--') {
        return '$equipment · --';
      }
      return '$equipment · $click $unit';
    case GrindMode.simple:
      return _text(detail.grindSimpleLabel);
    case GrindMode.pro:
      return _int(detail.grindMicrons, suffix: ' μm');
  }
}
