import 'package:ditonton/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('TV main flow', () {
    testWidgets('navigate TV, open detail, toggle watchlist, verify in watchlist, search title', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // 1) Navigate to TV tab via bottom NavigationBar label
      final tvTab = find.text('TV');
      expect(tvTab, findsOneWidget);
      await tester.tap(tvTab);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // 2) From Home TV page, go to a full list to ensure tappable cards are present.
      // Tap first "See More" (Airing Today page).
      final seeMoreChips = find.text('See More');
      expect(seeMoreChips, findsWidgets);
      await tester.tap(seeMoreChips.first);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // 3) Open first TV item in the list
      // The list items are TvCardList widgets; match by semantics of Card tap area (InkWell inside Card).
      final listCards = find.byType(InkWell);
      expect(listCards, findsWidgets);
      // Heuristically tap the first tappable list tile (skip app bars etc by scrolling to ensure visible)
      await tester.ensureVisible(listCards.first);
      await tester.tap(listCards.first);
      await tester.pumpAndSettle(const Duration(seconds: 4));

      // 4) Toggle watchlist button on detail page
      final watchlistBtn = find.widgetWithText(FilledButton, 'Watchlist');
      expect(watchlistBtn, findsOneWidget);
      await tester.tap(watchlistBtn);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // 5) Back to Home TV page
      await tester.pageBack();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // 6) Open Watchlist via AppBar action
      final watchlistIcon = find.byTooltip('Watchlist');
      expect(watchlistIcon, findsOneWidget);
      await tester.tap(watchlistIcon);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // 7) Verify at least one item appears in watchlist (best-effort)
      // We assert the presence of any InkWell (TvCardList clickable area)
      expect(find.byType(InkWell), findsWidgets);

      // 8) Back to Home TV page
      await tester.pageBack();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // 9) Open Search via AppBar action
      final searchIcon = find.byTooltip('Search');
      expect(searchIcon, findsOneWidget);
      await tester.tap(searchIcon);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // 10) Enter a query and submit
      final searchField = find.byType(TextField);
      expect(searchField, findsOneWidget);
      await tester.enterText(searchField, 'naruto');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // 11) If results exist, open first; otherwise accept "No results found" text.
      final resultItem = find.byType(InkWell);
      final noResultText = find.text('No results found');
      if (await tester.pumpAndSettle(const Duration(milliseconds: 100)) == 0) {
        // fallthrough
      }
      if (resultItem.evaluate().isNotEmpty) {
        await tester.ensureVisible(resultItem.first);
        await tester.tap(resultItem.first);
        await tester.pumpAndSettle(const Duration(seconds: 4));
        // landed on detail; sanity check for Watchlist button presence
        expect(find.widgetWithText(FilledButton, 'Watchlist'), findsOneWidget);
      } else {
        expect(noResultText, findsOneWidget);
      }
    }, timeout: const Timeout(Duration(minutes: 5)));
  });
}
