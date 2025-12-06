import 'package:ditonton_tv/features/tv/presentation/pages/popular_tv_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('PopularTvPage has correct route name', () {
    expect(PopularTvPage.routeName, '/popular-tv');
  });

  test('PopularTvPage can be instantiated', () {
    const page = PopularTvPage();
    expect(page, isA<StatefulWidget>());
  });

  test('PopularTvPage can be instantiated with key', () {
    const key = Key('test_key');
    const page = PopularTvPage(key: key);
    expect(page.key, key);
  });
}
