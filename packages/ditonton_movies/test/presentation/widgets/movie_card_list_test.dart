import 'package:ditonton_movies/features/movies/domain/entities/movie.dart';
import 'package:ditonton_movies/features/movies/presentation/pages/movie_detail_page.dart';
import 'package:ditonton_movies/features/movies/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class TestNavigatorObserver extends NavigatorObserver {
  Route<dynamic>? lastPushed;
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    lastPushed = route;
    super.didPush(route, previousRoute);
  }
}

void main() {
  testWidgets('MovieCard taps navigate to detail with id', (tester) async {
    final observer = TestNavigatorObserver();
    const movie = Movie(
      adult: false,
      backdropPath: 'b',
      genreIds: [],
      id: 123,
      originalTitle: 'OT',
      overview: 'OV',
      popularity: 0.0,
      posterPath: '/p',
      releaseDate: '2020-01-01',
      title: 'Title',
      video: false,
      voteAverage: 0.0,
      voteCount: 0,
    );

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: MovieCard(movie),
      ),
      navigatorObservers: [observer],
      onGenerateRoute: (settings) {
        if (settings.name == MovieDetailPage.routeName) {
          return MaterialPageRoute(builder: (_) => Container());
        }
        return null;
      },
    ));

    await tester.tap(find.byType(MovieCard));
    await tester.pumpAndSettle();

    expect(observer.lastPushed, isNotNull);
  });

  testWidgets('MovieCard renders title', (tester) async {
    const movie =
        Movie.watchlist(id: 1, title: 'T', overview: 'O', posterPath: '/p');
    await tester
        .pumpWidget(const MaterialApp(home: Scaffold(body: MovieCard(movie))));
    expect(find.text('T'), findsOneWidget);
  });
}
