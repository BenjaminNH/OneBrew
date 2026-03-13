import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:one_brew/features/rating/presentation/widgets/quick_rating_bar.dart';

void main() {
  group('QuickRatingBar', () {
    testWidgets('renders score area and mood area', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuickRatingBar(
              score: 3,
              emoji: '🙂',
              onScoreChanged: (_) {},
              onEmojiChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Quick Rating'), findsOneWidget);
      expect(find.text('Mood'), findsOneWidget);
      expect(find.byType(Slider), findsOneWidget);
      expect(find.byKey(const Key('quick-rating-star-1')), findsOneWidget);
      expect(find.byKey(const Key('quick-rating-star-5')), findsOneWidget);
    });

    testWidgets('supports slider and star tap interactions', (tester) async {
      int selectedScore = 3;
      String selectedEmoji = '🙂';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return QuickRatingBar(
                  score: selectedScore,
                  emoji: selectedEmoji,
                  onScoreChanged: (value) => setState(() {
                    selectedScore = value;
                  }),
                  onEmojiChanged: (value) => setState(() {
                    selectedEmoji = value;
                  }),
                );
              },
            ),
          ),
        ),
      );

      await tester.drag(find.byType(Slider), const Offset(300, 0));
      await tester.pumpAndSettle();
      expect(selectedScore, inInclusiveRange(4, 5));

      await tester.tap(find.byKey(const Key('quick-rating-star-2')));
      await tester.pumpAndSettle();
      expect(selectedScore, 2);
    });

    testWidgets('supports emoji selection', (tester) async {
      int selectedScore = 4;
      String selectedEmoji = '😐';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return QuickRatingBar(
                  score: selectedScore,
                  emoji: selectedEmoji,
                  onScoreChanged: (value) => setState(() {
                    selectedScore = value;
                  }),
                  onEmojiChanged: (value) => setState(() {
                    selectedEmoji = value;
                  }),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('quick-rating-emoji-😍')));
      await tester.pumpAndSettle();

      expect(selectedEmoji, '😍');
    });
  });
}
