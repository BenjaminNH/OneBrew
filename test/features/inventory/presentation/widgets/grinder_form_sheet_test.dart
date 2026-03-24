import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:one_brew/features/inventory/presentation/widgets/grinder_form_sheet.dart';
import 'package:one_brew/l10n/app_localizations.dart';

class _GrinderSheetHarness extends StatefulWidget {
  const _GrinderSheetHarness();

  @override
  State<_GrinderSheetHarness> createState() => _GrinderSheetHarnessState();
}

class _GrinderSheetHarnessState extends State<_GrinderSheetHarness> {
  GrinderFormResult? _result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(_result?.name ?? 'none'),
          TextButton(
            onPressed: () async {
              final result = await showModalBottomSheet<GrinderFormResult>(
                context: context,
                isScrollControlled: true,
                builder: (_) => const GrinderFormSheet(),
              );
              if (result == null) return;
              setState(() => _result = result);
            },
            child: const Text('open'),
          ),
        ],
      ),
    );
  }
}

void main() {
  testWidgets('GrinderFormSheet validates invalid range', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('en'),
        home: _GrinderSheetHarness(),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('grinder-form-name')), 'Bad');
    await tester.enterText(find.byKey(const Key('grinder-form-min')), '10');
    await tester.enterText(find.byKey(const Key('grinder-form-max')), '9');
    await tester.enterText(find.byKey(const Key('grinder-form-step')), '1');
    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();

    expect(find.text('Must be > min'), findsOneWidget);
    expect(find.text('none'), findsOneWidget);
  });

  testWidgets('GrinderFormSheet returns result when form is valid', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('en'),
        home: _GrinderSheetHarness(),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('grinder-form-name')),
      'Comandante C40',
    );
    await tester.enterText(find.byKey(const Key('grinder-form-min')), '0');
    await tester.enterText(find.byKey(const Key('grinder-form-max')), '40');
    await tester.enterText(find.byKey(const Key('grinder-form-step')), '1');
    await tester.enterText(
      find.byKey(const Key('grinder-form-unit')),
      'clicks',
    );
    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();

    expect(find.text('Comandante C40'), findsOneWidget);
  });
}
