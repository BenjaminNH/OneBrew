import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/drift_database.dart';

/// Provides the singleton [OneCoffeeDatabase] instance to the Riverpod tree.
///
/// This provider is placed in [shared/providers] because the database is a
/// cross-feature resource consumed by all feature-level data sources.
///
/// Usage:
/// ```dart
/// final db = ref.watch(databaseProvider);
/// ```
///
/// In tests, override this provider with an in-memory database:
/// ```dart
/// final container = ProviderContainer(
///   overrides: [
///     databaseProvider.overrideWithValue(
///       OneCoffeeDatabase.forTesting(NativeDatabase.memory()),
///     ),
///   ],
/// );
/// ```
///
/// Ref: docs/01_Architecture.md § 4.1 — driftDatabaseProvider
final databaseProvider = Provider<OneCoffeeDatabase>((ref) {
  final db = OneCoffeeDatabase();
  // Ensure the database connection is closed when the provider is disposed.
  ref.onDispose(db.close);
  return db;
});
