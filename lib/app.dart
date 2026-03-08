import 'package:flutter/material.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/dark_theme.dart';

/// Root app widget configured with GoRouter.
class OneCoffeeApp extends StatelessWidget {
  const OneCoffeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'OneCoffee',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: DarkTheme.dark,
      themeMode: ThemeMode.light,
      routerConfig: appRouter,
    );
  }
}
