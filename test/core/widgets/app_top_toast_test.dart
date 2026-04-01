import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:one_brew/core/widgets/app_top_toast.dart';

void main() {
  tearDown(() {
    AppTopToast.dismiss();
    AppBottomActionPrompt.dismiss();
  });

  testWidgets('top toast auto-dismisses after duration', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return Center(
                child: ElevatedButton(
                  key: const Key('show-toast-button'),
                  onPressed: () {
                    AppTopToast.showSuccess(
                      context,
                      'Saved',
                      duration: const Duration(seconds: 4),
                    );
                  },
                  child: const Text('Show'),
                ),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('show-toast-button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('app-top-toast')), findsOneWidget);
    expect(find.byKey(const Key('app-top-toast-icon')), findsOneWidget);
    expect(find.text('Saved'), findsOneWidget);

    await tester.pump(const Duration(seconds: 4));
    expect(find.byKey(const Key('app-top-toast')), findsNothing);
  });

  testWidgets(
    'top toast dismisses on outside pointer and does not block underlying tap',
    (tester) async {
      var underlayTapCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return Stack(
                  children: [
                    Center(
                      child: GestureDetector(
                        key: const Key('underlay-hit-target'),
                        onTap: () => underlayTapCount += 1,
                        child: const SizedBox(
                          width: 200,
                          height: 80,
                          child: Center(child: Text('Underlay target')),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: ElevatedButton(
                          key: const Key('show-toast-button'),
                          onPressed: () {
                            AppTopToast.showInfo(
                              context,
                              'Tap outside to dismiss',
                              duration: const Duration(seconds: 6),
                            );
                          },
                          child: const Text('Show'),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('show-toast-button')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('app-top-toast')), findsOneWidget);

      await tester.tap(find.byKey(const Key('underlay-hit-target')));
      await tester.pump();

      expect(underlayTapCount, 1);
      expect(find.byKey(const Key('app-top-toast')), findsNothing);
    },
  );

  testWidgets('bottom action prompt remains clickable', (tester) async {
    var actionTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return Center(
                child: ElevatedButton(
                  key: const Key('show-toast-button'),
                  onPressed: () {
                    AppBottomActionPrompt.show(
                      context,
                      message: 'Saved',
                      duration: const Duration(seconds: 6),
                      action: AppBottomActionPromptAction(
                        label: 'Undo',
                        onPressed: () => actionTapped = true,
                      ),
                    );
                  },
                  child: const Text('Show'),
                ),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('show-toast-button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('app-bottom-action-prompt')), findsOneWidget);
    expect(find.text('Undo'), findsOneWidget);

    await tester.tap(find.text('Undo'));
    await tester.pump();

    expect(actionTapped, isTrue);
    expect(find.byKey(const Key('app-bottom-action-prompt')), findsNothing);
  });

  testWidgets(
    'bottom action prompt dismisses on outside pointer and does not block underlying tap',
    (tester) async {
      var underlayTapCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return Stack(
                  children: [
                    Center(
                      child: GestureDetector(
                        key: const Key('underlay-hit-target'),
                        onTap: () => underlayTapCount += 1,
                        child: const SizedBox(
                          width: 200,
                          height: 80,
                          child: Center(child: Text('Underlay target')),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: ElevatedButton(
                          key: const Key('show-toast-button'),
                          onPressed: () {
                            AppBottomActionPrompt.show(
                              context,
                              message: 'Saved',
                              duration: const Duration(seconds: 6),
                              action: const AppBottomActionPromptAction(
                                label: 'Undo',
                                onPressed: _noop,
                              ),
                            );
                          },
                          child: const Text('Show'),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('show-toast-button')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('app-bottom-action-prompt')), findsOneWidget);

      await tester.tap(find.byKey(const Key('underlay-hit-target')));
      await tester.pump();

      expect(underlayTapCount, 1);
      expect(find.byKey(const Key('app-bottom-action-prompt')), findsNothing);
    },
  );
}

void _noop() {}
