import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:one_brew/core/database/drift_database.dart';
import 'package:one_brew/core/localization/app_locale.dart';
import 'package:one_brew/shared/providers/database_providers.dart';

final appLocaleControllerProvider = Provider<AppLocaleController>((ref) {
  final database = ref.watch(databaseProvider);
  return AppLocaleController(database);
});

final localeOverrideCodeProvider = StreamProvider<String?>((ref) {
  final database = ref.watch(databaseProvider);
  return database.watchLocaleOverrideCode();
});

final appLocaleOptionProvider = Provider<AppLocaleOption>((ref) {
  final code = ref.watch(localeOverrideCodeProvider).asData?.value;
  return AppLocaleOption.fromStorageCode(code);
});

final appLocaleProvider = Provider<Locale?>((ref) {
  return ref.watch(appLocaleOptionProvider).locale;
});

class AppLocaleController {
  const AppLocaleController(this._database);

  final OneBrewDatabase _database;

  Future<void> setLocaleOption(AppLocaleOption option) {
    return _database.setLocaleOverrideCode(option.storageCode);
  }
}
