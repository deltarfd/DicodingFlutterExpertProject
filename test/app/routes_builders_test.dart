import 'package:ditonton/app/routes.dart';
import 'package:ditonton_movies/features/movies/presentation/pages/movie_detail_page.dart';
import 'package:ditonton_tv/features/tv/presentation/pages/tv_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('MovieDetailPage route builder executes with argument', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) {
          final route = AppRoutes.onGenerateRoute(
            const RouteSettings(name: MovieDetailPage.ROUTE_NAME, arguments: 7),
          ) as MaterialPageRoute<dynamic>;
          final widget = route.builder(context);
          expect(widget, isA<MovieDetailPage>());
          return const SizedBox.shrink();
        },
      ),
    ));
  });

  testWidgets('TvDetailPage route builder executes with argument', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) {
          final route = AppRoutes.onGenerateRoute(
            const RouteSettings(name: TvDetailPage.ROUTE_NAME, arguments: 99),
          ) as MaterialPageRoute<dynamic>;
          final widget = route.builder(context);
          expect(widget, isA<TvDetailPage>());
          return const SizedBox.shrink();
        },
      ),
    ));
  });
}