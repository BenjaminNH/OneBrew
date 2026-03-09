import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:one_coffee/features/brew_logger/presentation/pages/brew_logger_page.dart';
import 'package:one_coffee/features/history/presentation/pages/brew_detail_page.dart';
import 'package:one_coffee/features/history/presentation/pages/history_page.dart';
import 'package:one_coffee/features/inventory/presentation/pages/inventory_manage_page.dart';

/// Canonical route paths used by the app shell.
abstract final class AppRoutePaths {
  static const brew = '/brew';
  static const manage = '/manage';
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
          final target = switch (index) {
            0 => AppRoutePaths.brew,
            1 => AppRoutePaths.manage,
            _ => AppRoutePaths.history,
          };
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
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2),
            label: 'Manage',
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
    if (currentLocation.startsWith(AppRoutePaths.manage)) {
      return 1;
    }
    if (currentLocation.startsWith(AppRoutePaths.history)) {
      return 2;
    }
    return 0;
  }
}

class _RouteErrorPage extends StatelessWidget {
  const _RouteErrorPage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(message, textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }
}
