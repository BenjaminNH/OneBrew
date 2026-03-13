import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:one_brew/app.dart';
import 'package:one_brew/features/brew_logger/brew_logger_providers.dart';
import 'package:one_brew/features/brew_logger/presentation/controllers/brew_timer_controller.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('timer catches up after app resume from background', (
    WidgetTester tester,
  ) async {
    final container = ProviderContainer(
      overrides: [brewParamBootstrapProvider.overrideWith((_) async => false)],
    );
    addTearDown(container.dispose);

    var fakeNow = DateTime(2026, 1, 1, 9, 0, 0);
    BrewTimerController.now = () => fakeNow;
    addTearDown(() => BrewTimerController.now = DateTime.now);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const OneBrewApp(),
      ),
    );
    await tester.pumpAndSettle();

    final timerController = container.read(
      brewTimerControllerProvider.notifier,
    );
    timerController.start();

    fakeNow = fakeNow.add(const Duration(seconds: 45));
    timerController.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();

    final timerState = container.read(brewTimerControllerProvider);
    expect(timerState.elapsedSeconds, 45);
    expect(timerState.isRunning, true);
  });
}
