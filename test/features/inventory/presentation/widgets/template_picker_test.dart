import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:one_coffee/features/inventory/presentation/widgets/template_picker.dart';

void main() {
  group('TemplatePicker', () {
    Widget wrapWithMaterial(Widget child) {
      return MaterialApp(home: Scaffold(body: child));
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
  });
}

void _noopTemplateSelected(BrewTemplateOption _) {}
