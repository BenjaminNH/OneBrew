import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:one_brew/core/constants/app_colors.dart';
import 'package:one_brew/features/brew_logger/brew_logger_providers.dart';
import 'package:one_brew/features/brew_logger/presentation/pages/brew_logger_page.dart';
import 'package:one_brew/features/brew_logger/presentation/pages/brew_param_preferences_page.dart';
import 'package:one_brew/features/brew_logger/presentation/pages/onboarding_page.dart';
import 'package:one_brew/features/history/presentation/pages/brew_detail_page.dart';
import 'package:one_brew/features/history/presentation/pages/history_page.dart';
import 'package:one_brew/features/inventory/presentation/pages/inventory_manage_page.dart';
import 'app_route_paths.dart';

export 'app_route_paths.dart';

/// Global app router used by [MaterialApp.router].
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutePaths.launch,
  routes: [
    GoRoute(
      path: AppRoutePaths.launch,
      builder: (_, _) => const _LaunchGatePage(),
    ),
    GoRoute(
      path: AppRoutePaths.onboarding,
      builder: (_, _) => const BrewOnboardingPage(),
    ),
    ShellRoute(
      builder: (context, state, child) =>
          AppShell(location: state.uri.path, child: child),
      routes: [
        GoRoute(
          path: AppRoutePaths.brew,
          builder: (_, state) {
            final templateRecordId = int.tryParse(
              state.uri.queryParameters['templateRecordId'] ?? '',
            );
            return BrewLoggerPage(templateRecordId: templateRecordId);
          },
        ),
        GoRoute(
          path: AppRoutePaths.manage,
          builder: (_, _) => const InventoryManagePage(),
          routes: [
            GoRoute(
              path: 'preferences',
              builder: (_, _) => const BrewParamPreferencesPage(),
            ),
          ],
        ),
        GoRoute(
          path: AppRoutePaths.history,
          builder: (_, _) => const HistoryPage(),
          routes: [
            GoRoute(
              path: ':id',
              builder: (_, state) {
                final id = int.tryParse(state.pathParameters['id'] ?? '');
                if (id == null) {
                  return const _RouteErrorPage(
                    message: 'Invalid history detail id.',
                    fallbackPath: AppRoutePaths.history,
                  );
                }
                return BrewDetailPage(brewId: id);
              },
            ),
          ],
        ),
      ],
    ),
  ],
);

class _LaunchGatePage extends ConsumerWidget {
  const _LaunchGatePage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bootstrapAsync = ref.watch(brewParamBootstrapProvider);
    bootstrapAsync.whenData((shouldShowOnboarding) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        context.go(
          shouldShowOnboarding ? AppRoutePaths.onboarding : AppRoutePaths.brew,
        );
      });
    });

    return const Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      ),
    );
  }
}

/// Bottom-navigation shell wrapping feature pages.
class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.location, required this.child});

  final String location;
  final Widget child;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  static const double _systemGestureReservedEdge = 24;
  static const double _navSwipeTriggerDistance = 36;
  static const double _navSwipeTriggerVelocity = 450;

  double _navBarDragDistance = 0;
  bool _isNavBarSwipeActive = false;

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _locationToIndex(widget.location);

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onHorizontalDragStart: (details) {
          final navWidth =
              context.size?.width ?? MediaQuery.sizeOf(context).width;
          final startX = details.localPosition.dx;
          _isNavBarSwipeActive =
              startX > _systemGestureReservedEdge &&
              startX < (navWidth - _systemGestureReservedEdge);
          _navBarDragDistance = 0;
        },
        onHorizontalDragUpdate: (details) {
          if (!_isNavBarSwipeActive) {
            return;
          }
          _navBarDragDistance += details.primaryDelta ?? 0;
        },
        onHorizontalDragEnd: (details) {
          if (!_isNavBarSwipeActive) {
            _navBarDragDistance = 0;
            return;
          }

          final velocity = details.primaryVelocity ?? 0;
          final shouldGoNext =
              _navBarDragDistance <= -_navSwipeTriggerDistance ||
              velocity <= -_navSwipeTriggerVelocity;
          final shouldGoPrevious =
              _navBarDragDistance >= _navSwipeTriggerDistance ||
              velocity >= _navSwipeTriggerVelocity;

          _isNavBarSwipeActive = false;
          _navBarDragDistance = 0;

          if (shouldGoNext) {
            _goToIndex(selectedIndex + 1);
            return;
          }
          if (shouldGoPrevious) {
            _goToIndex(selectedIndex - 1);
          }
        },
        child: NavigationBar(
          key: const Key('app-shell-navigation-bar'),
          selectedIndex: selectedIndex,
          onDestinationSelected: (index) {
            final target = switch (index) {
              0 => AppRoutePaths.brew,
              1 => AppRoutePaths.history,
              _ => AppRoutePaths.manage,
            };
            if (widget.location != target) {
              context.go(target);
            }
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.coffee_outlined),
              selectedIcon: Icon(Icons.coffee),
              label: 'Brew',
            ),
            NavigationDestination(
              icon: Icon(Icons.history_outlined),
              selectedIcon: Icon(Icons.history),
              label: 'History',
            ),
            NavigationDestination(
              icon: Icon(Icons.inventory_2_outlined),
              selectedIcon: Icon(Icons.inventory_2),
              label: 'Manage',
            ),
          ],
        ),
      ),
    );
  }

  void _goToIndex(int index) {
    if (index < 0 || index > 2) {
      return;
    }
    final target = switch (index) {
      0 => AppRoutePaths.brew,
      1 => AppRoutePaths.history,
      _ => AppRoutePaths.manage,
    };
    if (widget.location != target) {
      context.go(target);
    }
  }

  int _locationToIndex(String currentLocation) {
    if (currentLocation.startsWith(AppRoutePaths.history)) {
      return 1;
    }
    if (currentLocation.startsWith(AppRoutePaths.manage)) {
      return 2;
    }
    return 0;
  }
}

class _RouteErrorPage extends StatelessWidget {
  const _RouteErrorPage({required this.message, required this.fallbackPath});

  final String message;
  final String fallbackPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(message, textAlign: TextAlign.center),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => context.go(fallbackPath),
                  icon: const Icon(Icons.arrow_back_rounded),
                  label: const Text('Go Back'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
