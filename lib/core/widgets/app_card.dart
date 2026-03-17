import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_durations.dart';
import '../constants/app_spacing.dart';

/// OneBrew Neumorphism Card
/// A unified card component implementing the "embossed" soft-UI shadow effect.
/// The card lifts above the cream-white background via dual BoxShadow.
/// Pressing the card transitions to a "debossed" / press-in state.
///
/// Usage:
/// ```dart
/// AppCard(
///   onTap: () {},
///   child: Text('content'),
/// )
/// ```
class AppCard extends StatefulWidget {
  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.borderRadius,
    this.backgroundColor,
    this.shadows,
    this.pressedShadows,
    this.enablePressEffect = true,
    this.pressOverlayColor,
    this.width,
    this.height,
    this.margin,
  });

  /// Card content
  final Widget child;

  /// Optional tap callback — enables press animation when provided
  final VoidCallback? onTap;

  /// Override internal padding (default: [AppSpacing.cardPadding])
  final EdgeInsetsGeometry? padding;

  /// Override corner radius (default: [AppSpacing.radiusMd])
  final double? borderRadius;

  /// Override background color (default: [AppColors.surface])
  final Color? backgroundColor;

  /// Override elevated shadow list (default: [AppColors.elevatedShadow])
  final List<BoxShadow>? shadows;

  /// Override pressed shadow list (default: [AppColors.pressedShadow])
  final List<BoxShadow>? pressedShadows;

  /// Whether to show the press-in effect on tap (default: true)
  final bool enablePressEffect;

  /// Optional overlay tint while pressed.
  ///
  /// Defaults to [AppColors.primaryOverlay] in light theme and
  /// [AppColors.secondaryOverlay] in dark theme.
  final Color? pressOverlayColor;

  /// Optional explicit width
  final double? width;

  /// Optional explicit height
  final double? height;

  /// Optional outer margin
  final EdgeInsetsGeometry? margin;

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppDurations.tapFeedback,
      reverseDuration: AppDurations.tapFeedback,
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.97,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) {
    if (!widget.enablePressEffect || widget.onTap == null) return;
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _onTapUp(TapUpDetails _) {
    _release();
  }

  void _onTapCancel() {
    _release();
  }

  void _release() {
    if (!mounted) return;
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.backgroundColor ?? AppColors.surface;
    final radius = widget.borderRadius ?? AppSpacing.radiusMd;
    final currentShadows = _isPressed
        ? (widget.pressedShadows ?? AppColors.pressedShadow)
        : (widget.shadows ?? AppColors.elevatedShadow);
    final overlayColor =
        widget.pressOverlayColor ??
        (Theme.of(context).brightness == Brightness.dark
            ? AppColors.secondaryOverlay
            : AppColors.primaryOverlay);

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child: AnimatedContainer(
          duration: AppDurations.tapFeedback,
          width: widget.width,
          height: widget.height,
          margin: widget.margin,
          padding:
              widget.padding ?? const EdgeInsets.all(AppSpacing.cardPadding),
          foregroundDecoration:
              _isPressed && widget.enablePressEffect && widget.onTap != null
              ? BoxDecoration(
                  color: overlayColor,
                  borderRadius: BorderRadius.circular(radius),
                )
              : null,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(radius),
            boxShadow: currentShadows,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

/// A simpler flat variant of [AppCard] without shadows — used inside
/// already-shadowed containers to avoid double-depth visual noise.
class AppCardFlat extends StatelessWidget {
  const AppCardFlat({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.backgroundColor,
    this.border,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final Color? backgroundColor;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surface,
        borderRadius: BorderRadius.circular(
          borderRadius ?? AppSpacing.radiusMd,
        ),
        border: border,
      ),
      child: child,
    );
  }
}

/// An inset / debossed container — visually "pressed into" the background.
/// Used for input fields and display areas (e.g., the timer dial track).
class AppInsetContainer extends StatelessWidget {
  const AppInsetContainer({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.backgroundColor,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.background,
        borderRadius: BorderRadius.circular(
          borderRadius ?? AppSpacing.radiusSm,
        ),
        boxShadow: AppColors.debossedShadow,
      ),
      child: child,
    );
  }
}
