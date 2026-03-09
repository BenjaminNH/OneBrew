import '../entities/brew_detail.dart';
import '../repositories/history_repository.dart';

/// Use case for retrieving the full detail of a single brew by id.
class GetBrewDetail {
  const GetBrewDetail(this._repository);

  final HistoryRepository _repository;

  Future<BrewDetail?> call(int brewId) => _repository.getBrewDetailById(brewId);
}
