import 'package:ditonton_movies/features/movies/presentation/pages/top_rated_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('TopRatedMoviesPage has correct route name', (tester) async {
    expect(TopRatedMoviesPage.routeName, '/top-rated-movie');
  });

  testWidgets('TopRatedMoviesPage can be instantiated', (tester) async {
    const page = TopRatedMoviesPage();
    expect(page, isA<StatefulWidget>());
  });
}
