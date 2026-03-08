import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:one_coffee/features/brew_logger/presentation/pages/brew_logger_page.dart';
import 'package:one_coffee/features/history/presentation/pages/history_page.dart';

/// Canonical route paths used by the app shell.
abstract final class AppRoutePaths {
  static const brew = '/brew';
  static const history = '/history';
}

/// Global app router used by [MaterialApp.router].
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutePaths.brew,
  routes: [
    ShellRoute(
      builder: (context, state, child) =>
          AppShell(location: state.uri.path, child: child),
      routes: [
        GoRoute(
          path: AppRoutePaths.brew,
          builder: (_, _) => const BrewLoggerPage(),
        ),
        GoRoute(
          path: AppRoutePaths.history,
          builder: (_, _) => const HistoryPage(),
        ),
      ],
    ),
  ],
);

/// Bottom-navigation shell wrapping feature pages.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.location, required this.child});

  final String location;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _locationToIndex(location);

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        key: const Key('app-shell-navigation-bar'),
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          final target = index == 0
              ? AppRoutePaths.brew
              : AppRoutePaths.history;
          if (location != target) {
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
        ],
      ),
    );
  }

  int _locationToIndex(String currentLocation) {
    if (currentLocation.startsWith(AppRoutePaths.history)) {
      return 1;
    }
    return 0;
  }
}
