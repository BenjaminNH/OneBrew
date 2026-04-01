import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'brew_detail_controller.dart';
import 'history_controller.dart';

/// Centralizes history/detail refresh rules after brew-related mutations.
class BrewViewRefresher {
  const BrewViewRefresher(this._ref);

  final Ref _ref;

  void refreshHistory() {
    _ref.invalidate(historyControllerProvider);
  }

  void refreshHistoryAndDetails() {
    refreshHistory();
    refreshDetails();
  }

  void refreshDetails() {
    _ref.invalidate(brewDetailControllerProvider);
  }
}

final brewViewRefresherProvider = Provider<BrewViewRefresher>((ref) {
  return BrewViewRefresher(ref);
});
