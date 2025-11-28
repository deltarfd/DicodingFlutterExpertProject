import 'package:ditonton_tv/features/tv/presentation/pages/watchlist_tv_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('WatchlistTvPage has correct route name', () {
    expect(WatchlistTvPage.ROUTE_NAME, '/watchlist-tv');
  });

  test('WatchlistTvPage can be instantiated', () {
    const page = WatchlistTvPage();
    expect(page, isA<WatchlistTvPage>());
  });

  test('WatchlistTvPage can be instantiated with key', () {
    const key = Key('test_key');
    const page = WatchlistTvPage(key: key);
    expect(page.key, key);
  });

  test('WatchlistTvPage createState returns correct state', () {
    const page = WatchlistTvPage();
    final state = page.createState();
    expect(state, isNotNull);
  });
}
