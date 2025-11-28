import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton_tv/features/tv/domain/entities/tv.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/popular_tv_bloc.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/top_rated_tv_bloc.dart';
import 'package:ditonton_tv/features/tv/presentation/pages/top_rated_tv_page.dart';
import 'package:ditonton_tv/features/tv/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockTopRatedTvBloc extends MockBloc<TopRatedTvEvent, TopRatedTvState>
    implements TopRatedTvBloc {}

class _FakeTopRatedTvEvent extends Fake implements TopRatedTvEvent {}

class _FakeTopRatedTvState extends Fake implements TopRatedTvState {}

void main() {
  late _MockTopRatedTvBloc mockBloc;

  setUp(() {
    mockBloc = _MockTopRatedTvBloc();
  });

  setUpAll(() {
    registerFallbackValue(_FakeTopRatedTvEvent());
    registerFallbackValue(_FakeTopRatedTvState());
  });

  testWidgets('TopRatedTvPage can be instantiated', (tester) async {
    const page = TopRatedTvPage();
    expect(page, isA<StatefulWidget>());
  });

  Widget _makeTestableWidget(Widget body) {
    return MaterialApp(
      home: BlocProvider<TopRatedTvBloc>.value(value: mockBloc, child: body),
    );
  }

  testWidgets('should show loading indicator when state is loading', (
    tester,
  ) async {
    whenListen(
      mockBloc,
      Stream<TopRatedTvState>.fromIterable([TopRatedTvLoading()]),
      initialState: TopRatedTvInitial(),
    );

    await tester.pumpWidget(_makeTestableWidget(const TopRatedTvPage()));
    await tester.pump();

    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('should show TV list when state is loaded', (tester) async {
    final tvList = [
      const Tv(
        id: 1,
        name: 'TV 1',
        overview: 'Overview 1',
        posterPath: '/path1.jpg',
        voteAverage: 9.0,
      ),
      const Tv(
        id: 2,
        name: 'TV 2',
        overview: 'Overview 2',
        posterPath: '/path2.jpg',
        voteAverage: 8.5,
      ),
    ];

    whenListen(
      mockBloc,
      Stream<TopRatedTvState>.fromIterable([TopRatedTvLoaded(tvList)]),
      initialState: TopRatedTvInitial(),
    );

    await tester.pumpWidget(_makeTestableWidget(const TopRatedTvPage()));
    await tester.pump();

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(TvCardList), findsNWidgets(2));
  });

  testWidgets('should show error message when state is error', (tester) async {
    const errorMessage = 'Failed to load top rated TV series';

    whenListen(
      mockBloc,
      Stream<TopRatedTvState>.fromIterable([
        const TopRatedTvError(errorMessage),
      ]),
      initialState: TopRatedTvInitial(),
    );

    await tester.pumpWidget(_makeTestableWidget(const TopRatedTvPage()));
    await tester.pump();

    expect(find.byKey(const Key('error_message')), findsOneWidget);
    expect(find.text(errorMessage), findsOneWidget);
  });

  testWidgets('should show AppBar with correct title', (tester) async {
    whenListen(
      mockBloc,
      Stream<TopRatedTvState>.fromIterable([]),
      initialState: TopRatedTvInitial(),
    );

    await tester.pumpWidget(_makeTestableWidget(const TopRatedTvPage()));

    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text('Top Rated TV Series'), findsOneWidget);
  });

  testWidgets('should dispatch FetchTopRatedTv event on init', (tester) async {
    whenListen(
      mockBloc,
      Stream<TopRatedTvState>.fromIterable([]),
      initialState: TopRatedTvInitial(),
    );

    await tester.pumpWidget(_makeTestableWidget(const TopRatedTvPage()));
    await tester.pump(Duration.zero);

    verify(() => mockBloc.add(FetchTopRatedTv())).called(1);
  });

  testWidgets('should show empty container for initial state', (tester) async {
    when(() => mockBloc.state).thenReturn(TopRatedTvInitial());
    whenListen(
      mockBloc,
      Stream<TopRatedTvState>.fromIterable([]),
      initialState: TopRatedTvInitial(),
    );

    await tester.pumpWidget(_makeTestableWidget(const TopRatedTvPage()));
    await tester.pump();

    expect(find.byType(SizedBox), findsWidgets);
  });
}
