import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/datasources/brew_local_datasource.dart';
import 'data/repositories/brew_repository_impl.dart';
import 'domain/repositories/brew_repository.dart';

/// Composition-root provider for selecting [BrewRepository] implementation.
final brewRepositoryProvider = Provider<BrewRepository>((ref) {
  return BrewRepositoryImpl(ref.watch(brewLocalDatasourceProvider));
});
