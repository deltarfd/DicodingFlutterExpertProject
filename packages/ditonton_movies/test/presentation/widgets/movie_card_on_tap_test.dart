import 'package:ditonton_movies/features/movies/domain/entities/movie.dart';
import 'package:ditonton_movies/features/movies/presentation/pages/movie_detail_page.dart';
import 'package:ditonton_movies/features/movies/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  testWidgets('taping a movie item should go to MovieDetailPage',
      (WidgetTester tester) async {
    int? navigatedId;

    await tester.pumpWidget(MaterialApp(
      onGenerateRoute: (settings) {
        if (settings.name == MovieDetailPage.routeName) {
          navigatedId = settings.arguments as int;
          return MaterialPageRoute(builder: (_) => Container());
        }
        return MaterialPageRoute(builder: (_) => MovieCard(testMovie));
      },
      home: Scaffold(body: MovieCard(testMovie)),
    ));

    final findCard = find.byType(MovieCard);
    expect(findCard, findsOneWidget);

    await tester.tap(findCard);
    await tester.pump();

    expect(navigatedId, testMovie.id);
  });
}
