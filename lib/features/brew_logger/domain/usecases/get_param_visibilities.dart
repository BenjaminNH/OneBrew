import '../entities/brew_method.dart';
import '../entities/brew_param_visibility.dart';
import '../repositories/brew_param_repository.dart';

/// Use case: read parameter visibility list for a brew method.
class GetParamVisibilities {
  const GetParamVisibilities(this._repository);

  final BrewParamRepository _repository;

  Future<List<BrewParamVisibility>> call(BrewMethod method) {
    return _repository.getParamVisibilities(method);
  }
}
