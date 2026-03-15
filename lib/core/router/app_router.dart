import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
  initialLocation: AppRoutePaths.brew,
  routes: [
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

/// Bottom-navigation shell wrapping feature pages.
class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.location, required this.child});

  final String location;
  final Widget child;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  static const double _edgeSwipeWidth = 24;
  static const double _edgeSwipeTriggerDistance = 56;
  static const double _edgeSwipeTriggerVelocity = 700;

  double _leftEdgeDragDistance = 0;
  double _rightEdgeDragDistance = 0;

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _locationToIndex(widget.location);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: widget.child),
          // Keep gestures constrained to edge strips to avoid conflicts with
          // in-page horizontal interactions.
          if (selectedIndex > 0)
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: _edgeSwipeWidth,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onHorizontalDragStart: (_) => _leftEdgeDragDistance = 0,
                onHorizontalDragUpdate: (details) {
                  final delta = details.primaryDelta ?? 0;
                  if (delta > 0) {
                    _leftEdgeDragDistance += delta;
                  }
                },
                onHorizontalDragEnd: (details) {
                  final velocity = details.primaryVelocity ?? 0;
                  final shouldSwitch =
                      _leftEdgeDragDistance >= _edgeSwipeTriggerDistance ||
                      velocity >= _edgeSwipeTriggerVelocity;
                  _leftEdgeDragDistance = 0;
                  if (shouldSwitch) {
                    _goToIndex(selectedIndex - 1);
                  }
                },
              ),
            ),
          if (selectedIndex < 2)
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: _edgeSwipeWidth,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onHorizontalDragStart: (_) => _rightEdgeDragDistance = 0,
                onHorizontalDragUpdate: (details) {
                  final delta = details.primaryDelta ?? 0;
                  if (delta < 0) {
                    _rightEdgeDragDistance += -delta;
                  }
                },
                onHorizontalDragEnd: (details) {
                  final velocity = details.primaryVelocity ?? 0;
                  final shouldSwitch =
                      _rightEdgeDragDistance >= _edgeSwipeTriggerDistance ||
                      velocity <= -_edgeSwipeTriggerVelocity;
                  _rightEdgeDragDistance = 0;
                  if (shouldSwitch) {
                    _goToIndex(selectedIndex + 1);
                  }
                },
              ),
            ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
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
