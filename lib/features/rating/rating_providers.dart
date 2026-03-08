import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/datasources/rating_local_datasource.dart';
import 'data/repositories/rating_repository_impl.dart';
import 'domain/repositories/rating_repository.dart';

/// Composition-root provider for selecting [RatingRepository] implementation.
final ratingRepositoryProvider = Provider<RatingRepository>((ref) {
  return RatingRepositoryImpl(ref.watch(ratingLocalDatasourceProvider));
});
