import 'package:ditonton_tv/features/tv/presentation/pages/popular_tv_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('PopularTvPage has correct route name', (tester) async {
    expect(PopularTvPage.ROUTE_NAME, '/popular-tv');
  });

  testWidgets('PopularTvPage can be instantiated', (tester) async {
    const page = PopularTvPage();
    expect(page, isA<StatefulWidget>());
    expect(page.key, isNull);
  });
}
