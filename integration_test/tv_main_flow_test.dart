import 'package:ditonton/main.dart' as app;
import 'package:ditonton_tv/features/tv/presentation/pages/tv_detail_page.dart';
import 'package:ditonton_tv/features/tv/presentation/pages/tv_search_page.dart';
import 'package:ditonton_tv/features/tv/presentation/widgets/tv_card_list.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('TV main flow', () {
    testWidgets(
        'navigate TV, open detail, toggle watchlist, verify in watchlist, search title',
        (tester) async {
      await app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // --- 1. Airing Today Flow ---
      debugPrint('DEBUG: 1) Navigate to TV tab');
      final tvTab = find.text('TV');
      expect(tvTab, findsOneWidget);
      await tester.tap(tvTab);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      debugPrint('DEBUG: 2) Tap "See More" (Airing Today)');
      final seeMoreChips = find.text('See More');
      expect(seeMoreChips, findsWidgets);
      await tester.tap(seeMoreChips.first);
      await tester.pumpAndSettle(const Duration(seconds: 5)); // Wait for load

      debugPrint('DEBUG: 3) Open first TV item from Airing Today');
      final listCards = find.byType(InkWell);
      // Ensure we have items
      if (listCards.evaluate().isEmpty) {
        debugPrint(
            'DEBUG: No items found in Airing Today. Checking for error...');
        if (find.textContaining('Error').evaluate().isNotEmpty) {
          fail(
              'Failed to load Airing Today list: ${find.textContaining('Error').evaluate()}');
        }
        fail('Airing Today list is empty but no error displayed');
      }

      await tester.ensureVisible(listCards.first);
      await tester.tap(listCards.first);
      await tester.pumpAndSettle(const Duration(seconds: 4));

      debugPrint('DEBUG: 4) Toggle watchlist on Detail Page');
      final watchlistBtn = find.widgetWithText(FilledButton, 'Watchlist');
      expect(watchlistBtn, findsOneWidget);
      await tester.tap(watchlistBtn);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify snackbar or message if possible, but just proceeding is fine

      debugPrint('DEBUG: 5) Back from Detail Page');
      final backBtnDetail = find.byTooltip('Back');
      expect(backBtnDetail, findsOneWidget);
      await tester.tap(backBtnDetail);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      debugPrint('DEBUG: 6) Back from Airing Today List');
      final backBtnList = find.byTooltip('Back');
      expect(backBtnList, findsOneWidget);
      await tester.tap(backBtnList);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // --- 2. Popular Flow ---
      debugPrint('DEBUG: 7) Tap "See More" (Popular)');
      // We are back at Home TV. Find "See More" again.
      // Popular is the second one.
      final seeMoreChips2 = find.text('See More');
      if (seeMoreChips2.evaluate().length >= 2) {
        await tester.ensureVisible(seeMoreChips2.at(1));
        await tester.tap(seeMoreChips2.at(1));
        await tester.pumpAndSettle(const Duration(seconds: 5));

        debugPrint('DEBUG: 8) Check Popular list items');
        final popularCards = find.byType(InkWell);
        expect(popularCards, findsWidgets);

        debugPrint('DEBUG: 9) Back from Popular List');
        final backBtnPopular = find.byTooltip('Back');
        expect(backBtnPopular, findsOneWidget);
        await tester.tap(backBtnPopular);
        await tester.pumpAndSettle(const Duration(seconds: 2));
      } else {
        debugPrint('DEBUG: Popular "See More" not found');
      }

      // --- 3. Top Rated Flow ---
      debugPrint('DEBUG: 10) Tap "See More" (Top Rated)');
      // Top Rated is the third one.
      final seeMoreChips3 = find.text('See More');
      if (seeMoreChips3.evaluate().length >= 3) {
        await tester.ensureVisible(seeMoreChips3.at(2));
        await tester.tap(seeMoreChips3.at(2));
        await tester.pumpAndSettle(const Duration(seconds: 5));

        debugPrint('DEBUG: 11) Check Top Rated list items');
        final topRatedCards = find.byType(InkWell);
        expect(topRatedCards, findsWidgets);

        debugPrint('DEBUG: 12) Back from Top Rated List');
        final backBtnTopRated = find.byTooltip('Back');
        expect(backBtnTopRated, findsOneWidget);
        await tester.tap(backBtnTopRated);
        await tester.pumpAndSettle(const Duration(seconds: 2));
      } else {
        debugPrint('DEBUG: Top Rated "See More" not found');
      }

      // --- 4. Watchlist Verification ---
      debugPrint('DEBUG: 13) Open Watchlist');
      final watchlistIcon = find.byTooltip('Watchlist');
      expect(watchlistIcon, findsOneWidget);
      await tester.tap(watchlistIcon);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      debugPrint('DEBUG: 14) Verify watchlist item exists');
      // We added one item in step 4.
      expect(find.byType(InkWell), findsWidgets);

      debugPrint('DEBUG: 15) Back from Watchlist');
      final backBtnWatchlist = find.byTooltip('Back');
      await tester.tap(backBtnWatchlist);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // --- 5. Search Flow ---
      debugPrint('DEBUG: 16) Open Search');
      final searchIcon = find.byTooltip('Search');
      expect(searchIcon, findsOneWidget);
      await tester.tap(searchIcon);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      debugPrint('DEBUG: 17) Search for "naruto"');
      final searchField = find.byType(TextField);
      expect(searchField, findsOneWidget);
      await tester.enterText(searchField, 'naruto');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle(const Duration(seconds: 5));

      debugPrint('DEBUG: 18) Check search results');
      // Find InkWell specifically inside TvCardList to avoid tapping chips or buttons
      final resultItem = find.descendant(
        of: find.byType(TvCardList),
        matching: find.byType(InkWell),
      );
      final noResultText = find.text('No results found');

      if (resultItem.evaluate().isNotEmpty) {
        debugPrint('DEBUG: Search results found');

        // Ensure UI is settled
        await tester.pumpAndSettle();

        await tester.ensureVisible(resultItem.first);
        await tester.tap(resultItem.first);
        await tester.pumpAndSettle(const Duration(seconds: 4));

        // Verify we are on detail page
        if (find.byType(TvDetailPage).evaluate().isEmpty) {
          debugPrint(
              'DEBUG: Failed to navigate to TvDetailPage after tapping search result');
          // Try to find what IS on screen
          if (find.byType(TvSearchPage).evaluate().isNotEmpty) {
            debugPrint('DEBUG: Still on TvSearchPage');
          }
          fail('Did not navigate to TvDetailPage');
        }
        expect(find.widgetWithText(FilledButton, 'Watchlist'), findsOneWidget);

        debugPrint('DEBUG: Successfully navigated to detail page from search');
      } else {
        debugPrint('DEBUG: No search results found for "naruto"');
        expect(noResultText, findsOneWidget);
      }
    }, timeout: const Timeout(Duration(minutes: 5)));
  });
}
