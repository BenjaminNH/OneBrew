import 'package:flutter/material.dart';
import 'package:one_brew/l10n/l10n.dart';

import '../constants/app_durations.dart';
import '../constants/app_spacing.dart';

/// OneBrew Progressive Expand Container
/// Implements "Default Minimalism" UX — shows a collapsed summary row
/// with a silky AnimatedCrossFade to reveal detailed content on expand.
///
/// Ref: docs/03_UI_Specification.md § 4.2 — Progressive Disclosure Inputs
///
/// Usage:
/// ```dart
/// ProgressiveExpand(
///   collapsedChild: Text('Essential parameters'),
///   expandedChild: AdvancedParamsPanel(),
///   expandLabel: 'Show more parameters',
///   collapseLabel: 'Show less',
/// )
/// ```
class ProgressiveExpand extends StatefulWidget {
  const ProgressiveExpand({
    super.key,
    required this.collapsedChild,
    required this.expandedChild,
    this.isExpanded = false,
    this.onExpandChanged,
    this.expandLabel,
    this.collapseLabel,
    this.expandIcon = Icons.keyboard_arrow_down_rounded,
    this.collapseIcon = Icons.keyboard_arrow_up_rounded,
    this.duration,
    this.showToggleButton = true,
    this.collapsedHeight,
    this.curve = Curves.easeInOutCubic,
  });

  /// Content shown when collapsed (always visible)
  final Widget collapsedChild;

  /// Additional content revealed when expanded
  final Widget expandedChild;

  /// Whether the panel is currently expanded (if controlling externally)
  final bool isExpanded;

  /// Called when expand state changes
  final ValueChanged<bool>? onExpandChanged;

  /// Label for the expand toggle button
  final String? expandLabel;

  /// Label for the collapse toggle button
  final String? collapseLabel;

  /// Icon shown in collapsed state
  final IconData expandIcon;

  /// Icon shown in expanded state
  final IconData collapseIcon;

  /// Override animation duration (default: [AppDurations.progressiveExpand])
  final Duration? duration;

  /// Whether to show the built-in expand/collapse toggle row
  final bool showToggleButton;

  /// Fixed height of collapsed section (null = wrap content)
  final double? collapsedHeight;

  /// Animation curve
  final Curve curve;

  @override
  State<ProgressiveExpand> createState() => _ProgressiveExpandState();
}

class _ProgressiveExpandState extends State<ProgressiveExpand>
    with SingleTickerProviderStateMixin {
  late bool _expanded;
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;
  late final Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _expanded = widget.isExpanded;
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration ?? AppDurations.progressiveExpand,
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );
    _rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 0.5,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));
    if (_expanded) _controller.value = 1.0;
  }

  @override
  void didUpdateWidget(ProgressiveExpand oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      _setExpanded(widget.isExpanded, notify: false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    _setExpanded(!_expanded);
  }

  void _setExpanded(bool value, {bool notify = true}) {
    setState(() => _expanded = value);
    if (value) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    if (notify) widget.onExpandChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Collapsed content (always visible) ───
        SizedBox(height: widget.collapsedHeight, child: widget.collapsedChild),

        // ── Animated expanded region ──────────────
        SizeTransition(
          sizeFactor: _expandAnimation,
          axisAlignment: -1.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: AppSpacing.sm),
              widget.expandedChild,
            ],
          ),
        ),

        // ── Toggle button ─────────────────────────
        if (widget.showToggleButton) ...[
          const SizedBox(height: AppSpacing.xs),
          _ExpandToggleButton(
            isExpanded: _expanded,
            expandLabel: widget.expandLabel,
            collapseLabel: widget.collapseLabel,
            expandIcon: widget.expandIcon,
            collapseIcon: widget.collapseIcon,
            rotateAnimation: _rotateAnimation,
            onTap: _toggle,
          ),
        ],
      ],
    );
  }
}

/// The expand/collapse toggle row used by [ProgressiveExpand].
class _ExpandToggleButton extends StatelessWidget {
  const _ExpandToggleButton({
    required this.isExpanded,
    required this.expandLabel,
    required this.collapseLabel,
    required this.expandIcon,
    required this.collapseIcon,
    required this.rotateAnimation,
    required this.onTap,
  });

  final bool isExpanded;
  final String? expandLabel;
  final String? collapseLabel;
  final IconData expandIcon;
  final IconData collapseIcon;
  final Animation<double> rotateAnimation;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: AppDurations.fast,
              child: Text(
                isExpanded
                    ? (collapseLabel ?? l10n.progressiveExpandShowLess)
                    : (expandLabel ?? l10n.progressiveExpandShowMore),
                key: ValueKey(isExpanded),
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.xxs),
            RotationTransition(
              turns: rotateAnimation,
              child: Icon(
                expandIcon,
                size: AppSpacing.iconSmall,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A simpler animated visibility container that just hides/shows
/// content without the toggle button.
class AnimatedVisibilityBox extends StatelessWidget {
  const AnimatedVisibilityBox({
    super.key,
    required this.visible,
    required this.child,
    this.duration,
    this.curve = Curves.easeInOutCubic,
  });

  final bool visible;
  final Widget child;
  final Duration? duration;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: duration ?? AppDurations.progressiveExpand,
      curve: curve,
      child: AnimatedOpacity(
        opacity: visible ? 1.0 : 0.0,
        duration: duration ?? AppDurations.progressiveExpand,
        curve: curve,
        child: visible ? child : const SizedBox.shrink(),
      ),
    );
  }
}
