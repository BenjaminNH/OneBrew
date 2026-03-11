import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/datasources/brew_param_local_datasource.dart';
import 'data/datasources/brew_local_datasource.dart';
import 'data/repositories/brew_param_repository_impl.dart';
import 'data/repositories/brew_repository_impl.dart';
import 'domain/repositories/brew_param_repository.dart';
import 'domain/repositories/brew_repository.dart';

/// Composition-root provider for selecting [BrewRepository] implementation.
final brewRepositoryProvider = Provider<BrewRepository>((ref) {
  return BrewRepositoryImpl(ref.watch(brewLocalDatasourceProvider));
});

/// Composition-root provider for selecting [BrewParamRepository] implementation.
final brewParamRepositoryProvider = Provider<BrewParamRepository>((ref) {
  return BrewParamRepositoryImpl(ref.watch(brewParamLocalDatasourceProvider));
});
