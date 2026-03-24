import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:one_brew/features/inventory/presentation/widgets/template_picker.dart';
import 'package:one_brew/l10n/app_localizations.dart';

void main() {
  group('TemplatePicker', () {
    Widget wrapWithMaterial(Widget child) {
      return MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: Scaffold(body: child),
      );
    }

    testWidgets('shows empty-state hint when no templates', (tester) async {
      await tester.pumpWidget(
        wrapWithMaterial(
          const TemplatePicker(
            templates: [],
            onTemplateSelected: _noopTemplateSelected,
          ),
        ),
      );

      expect(find.text('Brew Again (Templates)'), findsOneWidget);
      expect(
        find.text('Save one brew first, then reuse it here in one tap.'),
        findsOneWidget,
      );
    });

    testWidgets('renders provided templates and reports selection', (
      tester,
    ) async {
      BrewTemplateOption? selected;
      const templates = [
        BrewTemplateOption(
          brewRecordId: 1,
          title: 'Morning V60',
          subtitle: '15.0g -> 240g | 3:00',
        ),
        BrewTemplateOption(
          brewRecordId: 2,
          title: 'Iced Aeropress',
          subtitle: '18.0g -> 200g | 2:10',
        ),
      ];

      await tester.pumpWidget(
        wrapWithMaterial(
          TemplatePicker(
            templates: templates,
            onTemplateSelected: (value) => selected = value,
          ),
        ),
      );

      expect(find.text('Morning V60'), findsOneWidget);
      expect(find.text('Iced Aeropress'), findsOneWidget);

      await tester.tap(find.text('Iced Aeropress'));
      await tester.pumpAndSettle();

      expect(selected?.brewRecordId, equals(2));
      expect(selected?.title, equals('Iced Aeropress'));
    });

    testWidgets('limits templates to latest three in one horizontal row', (
      tester,
    ) async {
      const templates = [
        BrewTemplateOption(
          brewRecordId: 1,
          title: 'Template 1',
          subtitle: '15.0g -> 240g | 3:00',
        ),
        BrewTemplateOption(
          brewRecordId: 2,
          title: 'Template 2',
          subtitle: '16.0g -> 250g | 3:10',
        ),
        BrewTemplateOption(
          brewRecordId: 3,
          title: 'Template 3',
          subtitle: '17.0g -> 260g | 3:20',
        ),
        BrewTemplateOption(
          brewRecordId: 4,
          title: 'Template 4',
          subtitle: '18.0g -> 270g | 3:30',
        ),
      ];

      await tester.pumpWidget(
        wrapWithMaterial(
          const TemplatePicker(
            templates: templates,
            onTemplateSelected: _noopTemplateSelected,
          ),
        ),
      );

      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(Wrap), findsNothing);
      expect(find.text('Template 1'), findsOneWidget);
      expect(find.text('Template 2'), findsOneWidget);
      expect(find.text('Template 3'), findsOneWidget);
      expect(find.text('Template 4'), findsNothing);
      expect(
        find.text('Showing latest 3 brews only. Tap a chip to reuse.'),
        findsOneWidget,
      );
    });
  });
}

void _noopTemplateSelected(BrewTemplateOption _) {}
