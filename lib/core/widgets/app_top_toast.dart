import 'dart:async';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_text_styles.dart';

enum AppTopToastKind { success, info }

class AppBottomActionPromptAction {
  const AppBottomActionPromptAction({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;
}

/// Lightweight non-blocking top toast for pure success/info feedback.
///
/// It renders in the root overlay, auto-dismisses after [duration], and
/// dismisses on next pointer interaction outside the toast body.
class AppTopToast {
  AppTopToast._();

  static final _AppTopToastManager _manager = _AppTopToastManager();

  static void showSuccess(
    BuildContext context,
    String message, {
    Duration? duration,
  }) {
    AppBottomActionPrompt.dismiss();
    _manager.show(
      context,
      message: message,
      kind: AppTopToastKind.success,
      duration: duration,
    );
  }

  static void showInfo(
    BuildContext context,
    String message, {
    Duration? duration,
  }) {
    AppBottomActionPrompt.dismiss();
    _manager.show(
      context,
      message: message,
      kind: AppTopToastKind.info,
      duration: duration,
    );
  }

  static void dismiss() => _manager.dismiss();
}

/// Bottom floating prompt for feedback that includes a follow-up action.
class AppBottomActionPrompt {
  AppBottomActionPrompt._();

  static final _AppBottomActionPromptManager _manager =
      _AppBottomActionPromptManager();

  static void show(
    BuildContext context, {
    required String message,
    required AppBottomActionPromptAction action,
    Duration? duration,
    double bottomOffset = 0,
  }) {
    AppTopToast.dismiss();
    _manager.show(
      context,
      message: message,
      action: action,
      duration: duration,
      bottomOffset: bottomOffset,
    );
  }

  static void dismiss() => _manager.dismiss();
}

class _AppTopToastManager {
  OverlayEntry? _entry;
  Timer? _timer;
  PointerRoute? _pointerRoute;
  GlobalKey? _toastKey;

  void show(
    BuildContext context, {
    required String message,
    required AppTopToastKind kind,
    Duration? duration,
  }) {
    dismiss();

    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) {
      return;
    }

    final toastKey = GlobalKey();
    _toastKey = toastKey;
    _entry = OverlayEntry(
      builder: (overlayContext) {
        final topInset = MediaQuery.paddingOf(overlayContext).top;
        final accentColor = switch (kind) {
          AppTopToastKind.success => AppColors.success,
          AppTopToastKind.info => AppColors.info,
        };
        final icon = switch (kind) {
          AppTopToastKind.success => Icons.check_circle_rounded,
          AppTopToastKind.info => Icons.info_rounded,
        };

        return Positioned(
          top: topInset + AppSpacing.md,
          left: AppSpacing.pageHorizontal,
          right: AppSpacing.pageHorizontal,
          child: Center(
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOutCubic,
              tween: Tween<double>(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                 return FractionalTranslation(
                   translation: Offset(0, (1 - value) * -0.5),
                   child: Opacity(
                     opacity: value,
                     child: child,
                   ),
                 );
              },
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: IgnorePointer(
                  ignoring: false,
                  child: Material(
                    type: MaterialType.transparency,
                    child: Container(
                      key: const Key('app-top-toast'),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.textPrimary.withValues(alpha: 0.06),
                            offset: const Offset(0, 4),
                            blurRadius: 16,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 16.0, sigmaY: 16.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.surface.withValues(alpha: 0.85),
                              borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.8),
                                width: 1.0,
                              ),
                            ),
                  child: Padding(
                    key: toastKey,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.md,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          key: const Key('app-top-toast-icon'),
                          padding: const EdgeInsets.all(AppSpacing.xs),
                          decoration: BoxDecoration(
                            color: accentColor.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            icon,
                            color: accentColor,
                            size: AppSpacing.iconAction,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Flexible(
                          child: Text(
                            message,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                           ),
                         ),
                       ],
                     ),
                   ),
                 ),
               ),
             ),
           ),
         ),
       ),
     ),
    ),
  ),
);
      },
    );
    overlay.insert(_entry!);

    _pointerRoute = (PointerEvent event) {
      if (event is! PointerDownEvent) {
        return;
      }
      if (_isPointerInsideToast(event.position)) {
        return;
      }
      dismiss();
    };
    GestureBinding.instance.pointerRouter.addGlobalRoute(_pointerRoute!);

    _timer = Timer(duration ?? const Duration(seconds: 2), dismiss);
  }

  bool _isPointerInsideToast(Offset globalPosition) {
    final key = _toastKey;
    if (key == null) {
      return false;
    }
    final context = key.currentContext;
    if (context == null) {
      return false;
    }
    final renderObject = context.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.attached) {
      return false;
    }
    final origin = renderObject.localToGlobal(Offset.zero);
    return (origin & renderObject.size).contains(globalPosition);
  }

  void dismiss() {
    _timer?.cancel();
    _timer = null;

    final pointerRoute = _pointerRoute;
    if (pointerRoute != null) {
      GestureBinding.instance.pointerRouter.removeGlobalRoute(pointerRoute);
    }
    _pointerRoute = null;
    _toastKey = null;

    _entry?.remove();
    _entry = null;
  }
}

class _AppBottomActionPromptManager {
  OverlayEntry? _entry;
  Timer? _timer;
  PointerRoute? _pointerRoute;
  GlobalKey? _promptKey;

  void show(
    BuildContext context, {
    required String message,
    required AppBottomActionPromptAction action,
    Duration? duration,
    required double bottomOffset,
  }) {
    dismiss();

    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) {
      return;
    }

    final promptKey = GlobalKey();
    _promptKey = promptKey;
    _entry = OverlayEntry(
      builder: (overlayContext) {
        final safeBottom = MediaQuery.paddingOf(overlayContext).bottom;
        final verticalOffset = safeBottom + AppSpacing.pageBottom + AppSpacing.md + bottomOffset;
        return Positioned(
          left: AppSpacing.pageHorizontal,
          right: AppSpacing.pageHorizontal,
          bottom: verticalOffset,
          child: Center(
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOutCubic,
              tween: Tween<double>(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                 return FractionalTranslation(
                   translation: Offset(0, (1 - value) * 0.5),
                   child: Opacity(
                     opacity: value,
                     child: child,
                   ),
                 );
              },
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 380),
                child: IgnorePointer(
                  ignoring: false,
                  child: Material(
                    type: MaterialType.transparency,
                    child: Container(
                      key: const Key('app-bottom-action-prompt'),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.textPrimary.withValues(alpha: 0.06),
                            offset: const Offset(0, -4),
                            blurRadius: 16,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 16.0, sigmaY: 16.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.surface.withValues(alpha: 0.85),
                              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.8),
                                width: 1.0,
                              ),
                            ),
                            child: Padding(
                      key: promptKey,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.md,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(AppSpacing.sm),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.coffee_rounded,
                                  color: AppColors.primary,
                                  size: AppSpacing.iconAction,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 2.0),
                                      child: Text(
                                        message,
                                        style: AppTextStyles.bodyMedium.copyWith(
                                          color: AppColors.textPrimary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: AppSpacing.xs),
                              IconButton(
                                onPressed: dismiss,
                                icon: const Icon(Icons.close_rounded),
                                color: AppColors.textSecondary,
                                splashRadius: 20,
                                iconSize: 18,
                                constraints: const BoxConstraints.tightFor(
                                  width: 32,
                                  height: 32,
                                ),
                                padding: EdgeInsets.zero,
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Row(
                            children: [
                              Expanded(
                                child: FilledButton(
                                  onPressed: () {
                                    dismiss();
                                    action.onPressed();
                                  },
                                  style: FilledButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    minimumSize: const Size(0, AppSpacing.buttonSmallHeight),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                                    ),
                                  ),
                                  child: Text(
                                    action.label,
                                    style: AppTextStyles.buttonSecondary.copyWith(
                                      color: Colors.white,
                                    ),
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
              ),
            ),
          ),
        ),
      ),
    ),
  ),
);
      },
    );
    overlay.insert(_entry!);

    _pointerRoute = (PointerEvent event) {
      if (event is! PointerDownEvent) {
        return;
      }
      if (_isPointerInsidePrompt(event.position)) {
        return;
      }
      dismiss();
    };
    GestureBinding.instance.pointerRouter.addGlobalRoute(_pointerRoute!);

    _timer = Timer(duration ?? const Duration(seconds: 4), dismiss);
  }

  bool _isPointerInsidePrompt(Offset globalPosition) {
    final key = _promptKey;
    if (key == null) {
      return false;
    }
    final context = key.currentContext;
    if (context == null) {
      return false;
    }
    final renderObject = context.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.attached) {
      return false;
    }
    final origin = renderObject.localToGlobal(Offset.zero);
    return (origin & renderObject.size).contains(globalPosition);
  }

  void dismiss() {
    _timer?.cancel();
    _timer = null;

    final pointerRoute = _pointerRoute;
    if (pointerRoute != null) {
      GestureBinding.instance.pointerRouter.removeGlobalRoute(pointerRoute);
    }
    _pointerRoute = null;
    _promptKey = null;

    _entry?.remove();
    _entry = null;
  }
}
