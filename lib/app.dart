import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/localization/app_locale.dart';
import 'core/localization/app_locale_controller.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/dark_theme.dart';
import 'l10n/app_localizations.dart';
import 'l10n/l10n.dart';

/// Root app widget configured with GoRouter.
class OneBrewApp extends ConsumerWidget {
  const OneBrewApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(appLocaleProvider);
    return MaterialApp.router(
      onGenerateTitle: (context) => context.l10n.appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: DarkTheme.dark,
      themeMode: ThemeMode.light,
      locale: locale,
      supportedLocales: AppLocaleOption.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      localeResolutionCallback: (locale, _) {
        return AppLocaleOption.resolveSystemLocale(locale);
      },
      routerConfig: appRouter,
    );
  }
}
