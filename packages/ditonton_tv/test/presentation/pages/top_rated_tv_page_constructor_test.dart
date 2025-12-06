import 'package:ditonton_tv/features/tv/presentation/pages/top_rated_tv_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('TopRatedTvPage has correct route name', () {
    expect(TopRatedTvPage.routeName, '/top-rated-tv');
  });

  test('TopRatedTvPage can be instantiated', () {
    const page = TopRatedTvPage();
    expect(page, isA<StatefulWidget>());
  });

  test('TopRatedTvPage can be instantiated with key', () {
    const key = Key('test_key');
    const page = TopRatedTvPage(key: key);
    expect(page.key, key);
  });

  test('TopRatedTvPage createState returns correct state', () {
    const page = TopRatedTvPage();
    final state = page.createState();
    expect(state, isNotNull);
  });
}
