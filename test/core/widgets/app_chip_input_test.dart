import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:one_brew/core/widgets/app_chip_input.dart';

void main() {
  testWidgets('shows top-5 suggestions immediately when input gains focus', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              final tags = <String>[];
              return AppChipInput(
                tags: tags,
                onTagsChanged: (_) {},
                suggestions: const [
                  'Focus Bean 06',
                  'Focus Bean 05',
                  'Focus Bean 04',
                  'Focus Bean 03',
                  'Focus Bean 02',
                  'Focus Bean 01',
                ],
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();

    expect(find.text('Focus Bean 06'), findsOneWidget);
    expect(find.text('Focus Bean 05'), findsOneWidget);
    expect(find.text('Focus Bean 04'), findsOneWidget);
    expect(find.text('Focus Bean 03'), findsOneWidget);
    expect(find.text('Focus Bean 02'), findsOneWidget);
    expect(find.text('Focus Bean 01'), findsNothing);
  });

  testWidgets('input field stays responsive on narrow widths', (tester) async {
    tester.view.physicalSize = const Size(280, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final tags = <String>[];
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              return AppChipInput(
                tags: tags,
                onTagsChanged: (newTags) {
                  setState(() {
                    tags
                      ..clear()
                      ..addAll(newTags);
                  });
                },
                suggestions: const ['Gesha', 'Ethiopia'],
              );
            },
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    final textFieldSize = tester.getSize(find.byType(TextField));
    expect(textFieldSize.width, lessThanOrEqualTo(154));
    expect(
      textFieldSize.height,
      greaterThanOrEqualTo(kMinInteractiveDimension),
    );
  });

  testWidgets('chip and suggestion row meet touch target expectations', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              final tags = <String>['Gesha'];
              return AppChipInput(
                tags: tags,
                onTagsChanged: (_) {},
                suggestions: const ['Geisha', 'Yirgacheffe'],
              );
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final chipSize = tester.getSize(find.byType(Chip).first);
    expect(chipSize.height, greaterThanOrEqualTo(kMinInteractiveDimension));

    await tester.enterText(find.byType(TextField), 'Gei');
    await tester.pumpAndSettle();

    final suggestionRowFinder = find.ancestor(
      of: find.text('Geisha'),
      matching: find.byType(InkWell),
    );
    final suggestionRowSize = tester.getSize(suggestionRowFinder.first);
    expect(
      suggestionRowSize.height,
      greaterThanOrEqualTo(kMinInteractiveDimension),
    );
    expect(tester.takeException(), isNull);
  });
}
