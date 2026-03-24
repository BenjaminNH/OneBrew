import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:one_brew/core/localization/app_locale.dart';
import 'package:one_brew/features/brew_logger/presentation/widgets/add_custom_param_sheet.dart';
import 'package:one_brew/l10n/app_localizations.dart';

void main() {
  testWidgets('validates number range and returns draft on submit', (
    WidgetTester tester,
  ) async {
    AddCustomParamDraft? submitted;

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        supportedLocales: AppLocaleOption.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Scaffold(
          body: Builder(
            builder: (context) => Center(
              child: ElevatedButton(
                onPressed: () async {
                  submitted = await showAddCustomParamSheet(context);
                },
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('add-param-min-field')), findsOneWidget);
    expect(find.byKey(const Key('add-param-max-field')), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('add-param-name-field')),
      'Pulse',
    );
    await tester.enterText(find.byKey(const Key('add-param-min-field')), '6');
    await tester.enterText(find.byKey(const Key('add-param-max-field')), '4');
    await tester.tap(find.text('Add Parameter'));
    await tester.pumpAndSettle();

    expect(find.text('Max must be greater than min.'), findsOneWidget);
    expect(submitted, isNull);

    await tester.enterText(find.byKey(const Key('add-param-max-field')), '12');
    await tester.enterText(
      find.byKey(const Key('add-param-step-field')),
      '0.5',
    );
    await tester.enterText(
      find.byKey(const Key('add-param-default-field')),
      '7',
    );
    await tester.tap(find.text('Add Parameter'));
    await tester.pumpAndSettle();

    expect(submitted, isNotNull);
    expect(submitted!.name, 'Pulse');
    expect(submitted!.numberMin, 6);
    expect(submitted!.numberMax, 12);
    expect(submitted!.numberStep, 0.5);
    expect(submitted!.numberDefault, 7);
  });
}
