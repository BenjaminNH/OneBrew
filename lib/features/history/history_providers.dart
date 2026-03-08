import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/datasources/history_local_datasource.dart';
import 'data/repositories/history_repository_impl.dart';
import 'domain/repositories/history_repository.dart';

/// Composition-root provider for selecting [HistoryRepository] implementation.
final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  return HistoryRepositoryImpl(ref.watch(historyLocalDatasourceProvider));
});
