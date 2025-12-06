import 'package:ditonton_tv/features/tv/presentation/pages/watchlist_tv_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('WatchlistTvPage has correct route name', (tester) async {
    expect(WatchlistTvPage.routeName, '/watchlist-tv');
  });

  testWidgets('WatchlistTvPage can be instantiated with key', (tester) async {
    const key = Key('test_key');
    const page = WatchlistTvPage(key: key);
    expect(page.key, key);
  });

  testWidgets('WatchlistTvPage createState returns correct state', (
    tester,
  ) async {
    const page = WatchlistTvPage();
    final state = page.createState();
    expect(state, isA<State<WatchlistTvPage>>());
  });
}
