import 'package:mockito/annotations.dart';
import 'package:one_brew/features/brew_logger/domain/repositories/brew_repository.dart';
import 'package:one_brew/features/history/domain/repositories/history_repository.dart';
import 'package:one_brew/features/inventory/domain/repositories/inventory_repository.dart';
import 'package:one_brew/features/rating/domain/repositories/rating_repository.dart';

// Generated mocks — run `dart run build_runner build` to regenerate.
// ignore: unused_import
import 'mock_repositories.mocks.dart';

/// Mockito annotations for all Repository interfaces used in Domain tests.
///
/// After modifying any repository interface, run:
/// ```bash
/// dart run build_runner build --delete-conflicting-outputs
/// ```
/// to regenerate `mock_repositories.mocks.dart`.
@GenerateMocks([
  BrewRepository,
  InventoryRepository,
  RatingRepository,
  HistoryRepository,
])
void main() {}
