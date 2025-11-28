import 'package:ditonton_tv/features/tv/presentation/pages/top_rated_tv_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('TopRatedTvPage has correct route name', (tester) async {
    expect(TopRatedTvPage.ROUTE_NAME, '/top-rated-tv');
  });

  testWidgets('TopRatedTvPage can be instantiated', (tester) async {
    const page = TopRatedTvPage();
    expect(page, isA<StatefulWidget>());
    expect(page.key, isNull);
  });
}
