import 'package:flutter/material.dart';

enum AppLocaleOption {
  systemDefault(storageCode: null, locale: null),
  english(storageCode: 'en', locale: Locale('en')),
  simplifiedChinese(
    storageCode: 'zh-Hans',
    locale: Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
  );

  const AppLocaleOption({required this.storageCode, required this.locale});

  final String? storageCode;
  final Locale? locale;

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
  ];

  static AppLocaleOption fromStorageCode(String? code) {
    for (final option in values) {
      if (option.storageCode == code) return option;
    }
    return systemDefault;
  }

  static Locale resolveSystemLocale(Locale? locale) {
    if (locale == null) {
      return supportedLocales.first;
    }
    if (locale.languageCode == 'zh') {
      return supportedLocales[1];
    }
    for (final supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return supportedLocale;
      }
    }
    return supportedLocales.first;
  }
}
