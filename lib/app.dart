import 'package:flutter/material.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/dark_theme.dart';

/// Root app widget configured with GoRouter.
class OneBrewApp extends StatelessWidget {
  const OneBrewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'OneBrew',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: DarkTheme.dark,
      themeMode: ThemeMode.light,
      routerConfig: appRouter,
    );
  }
}
