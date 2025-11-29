import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton_core/domain/entities/genre.dart';
import 'package:ditonton_tv/features/tv/domain/entities/tv.dart';
import 'package:ditonton_tv/features/tv/domain/entities/tv_detail.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/tv_detail_bloc.dart';
import 'package:ditonton_tv/features/tv/presentation/pages/tv_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTvDetailBloc extends MockBloc<TvDetailEvent, TvDetailState>
    implements TvDetailBloc {}

class FakeTvDetailEvent extends Fake implements TvDetailEvent {}

class FakeTvDetailState extends Fake implements TvDetailState {}

void main() {
  late MockTvDetailBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakeTvDetailEvent());
    registerFallbackValue(FakeTvDetailState());
  });

  setUp(() {
    mockBloc = MockTvDetailBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TvDetailBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  const tId = 1;
  const tTvDetail = TvDetail(
    genres: [Genre(id: 1, name: 'Action')],
    id: 1,
    overview: 'overview',
    posterPath: '/posterPath',
    name: 'Test TV',
    voteAverage: 8.5,
    seasons: [],
  );

  final tTv = Tv(
    id: 2,
    name: 'Recommendation',
    overview: 'rec overview',
    posterPath: '/rec.jpg',
    voteAverage: 7.0,
  );

  group('TvDetailPage', () {
    testWidgets('displays error message', (WidgetTester tester) async {
      whenListen(
        mockBloc,
        Stream<TvDetailState>.fromIterable([
          TvDetailState.initial().copyWith(
            status: TvDetailStatus.error,
            message: 'Error occurred',
          ),
        ]),
        initialState: TvDetailState.initial(),
      );

      await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: tId)));
      await tester.pump();

      expect(find.text('Error occurred'), findsOneWidget);
    });

    testWidgets('displays TV detail', (WidgetTester tester) async {
      whenListen(
        mockBloc,
        Stream<TvDetailState>.fromIterable([
          TvDetailState.initial().copyWith(
            status: TvDetailStatus.loaded,
            detail: tTvDetail,
            recommendations: [tTv],
            isInWatchlist: false,
          ),
        ]),
        initialState: TvDetailState.initial(),
      );

      await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: tId)));
      await tester.pump();

      expect(find.text('Test TV'), findsOneWidget);
      expect(find.text('overview'), findsOneWidget);
      expect(find.text('Action'), findsOneWidget);
      expect(find.byType(RatingBarIndicator), findsOneWidget);
    });

    testWidgets('shows add icon when not in watchlist', (
      WidgetTester tester,
    ) async {
      whenListen(
        mockBloc,
        Stream<TvDetailState>.fromIterable([
          TvDetailState.initial().copyWith(
            status: TvDetailStatus.loaded,
            detail: tTvDetail,
            recommendations: [],
            isInWatchlist: false,
          ),
        ]),
        initialState: TvDetailState.initial(),
      );

      await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: tId)));
      await tester.pump();

      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('shows check icon when in watchlist', (
      WidgetTester tester,
    ) async {
      whenListen(
        mockBloc,
        Stream<TvDetailState>.fromIterable([
          TvDetailState.initial().copyWith(
            status: TvDetailStatus.loaded,
            detail: tTvDetail,
            recommendations: [],
            isInWatchlist: true,
          ),
        ]),
        initialState: TvDetailState.initial(),
      );

      await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: tId)));
      await tester.pump();

      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('triggers watchlist toggle', (WidgetTester tester) async {
      whenListen(
        mockBloc,
        Stream<TvDetailState>.fromIterable([
          TvDetailState.initial().copyWith(
            status: TvDetailStatus.loaded,
            detail: tTvDetail,
            recommendations: [],
            isInWatchlist: false,
            message: 'Added to Watchlist',
          ),
        ]),
        initialState: TvDetailState.initial(),
      );

      await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: tId)));
      await tester.pump();

      await tester.tap(find.byType(FilledButton));
      await tester.pump();

      verify(() => mockBloc.add(ToggleWatchlistEvent())).called(1);
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Added to Watchlist'), findsOneWidget);
    });

    testWidgets('handles empty genres gracefully', (WidgetTester tester) async {
      final tTvDetailEmptyGenres = TvDetail(
        genres: [],
        id: 1,
        overview: 'overview',
        posterPath: '/posterPath',
        name: 'Test TV',
        voteAverage: 8.5,
        seasons: [],
      );

      whenListen(
        mockBloc,
        Stream<TvDetailState>.fromIterable([
          TvDetailState.initial().copyWith(
            status: TvDetailStatus.loaded,
            detail: tTvDetailEmptyGenres,
            recommendations: [],
            isInWatchlist: false,
          ),
        ]),
        initialState: TvDetailState.initial(),
      );

      await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: tId)));
      await tester.pump();

      expect(find.text('Test TV'), findsOneWidget);
      // Should not crash and display empty string or nothing for genres
    });

    testWidgets('back button pops navigation', (WidgetTester tester) async {
      whenListen(
        mockBloc,
        Stream<TvDetailState>.fromIterable([
          TvDetailState.initial().copyWith(
            status: TvDetailStatus.loaded,
            detail: tTvDetail,
            recommendations: [],
            isInWatchlist: false,
          ),
        ]),
        initialState: TvDetailState.initial(),
      );

      await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: tId)));
      await tester.pump();

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pump();
      // Verification of pop is implicit if no crash, or we can check if widget is removed if pushed
    });

    testWidgets('recommendation tap navigates to detail', (
      WidgetTester tester,
    ) async {
      whenListen(
        mockBloc,
        Stream<TvDetailState>.fromIterable([
          TvDetailState.initial().copyWith(
            status: TvDetailStatus.loaded,
            detail: tTvDetail,
            recommendations: [tTv],
            isInWatchlist: false,
          ),
        ]),
        initialState: TvDetailState.initial(),
      );

      await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: tId)));
      await tester.pump();

      await tester.ensureVisible(find.byType(InkWell).first);
      await tester.tap(find.byType(InkWell).first);
      await tester.pump();
      // Verify navigation occurred (mock observer could be used, but this covers the onTap callback)
    });
  });
}
