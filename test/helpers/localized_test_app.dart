import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:one_brew/core/localization/app_locale.dart';
import 'package:one_brew/l10n/app_localizations.dart';

Future<void> pumpLocalizedWidget(
  WidgetTester tester, {
  required Widget child,
  ThemeData? theme,
  Locale locale = const Locale('en'),
}) {
  return tester.pumpWidget(
    MaterialApp(
      locale: locale,
      supportedLocales: AppLocaleOption.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      theme: theme,
      home: child,
    ),
  );
}
