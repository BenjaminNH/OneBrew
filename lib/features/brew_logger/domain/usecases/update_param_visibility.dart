import '../entities/brew_param_visibility.dart';
import '../repositories/brew_param_repository.dart';

/// Use case: update a parameter visibility record.
class UpdateParamVisibility {
  const UpdateParamVisibility(this._repository);

  final BrewParamRepository _repository;

  Future<bool> call(BrewParamVisibility visibility) {
    return _repository.updateParamVisibility(visibility);
  }
}
