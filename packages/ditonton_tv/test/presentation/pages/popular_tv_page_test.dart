import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton_tv/features/tv/domain/entities/tv.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/popular_tv_bloc.dart';
import 'package:ditonton_tv/features/tv/presentation/pages/popular_tv_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockPopularTvBloc extends MockBloc<PopularTvEvent, PopularTvState>
    implements PopularTvBloc {}

class _FakePopularTvEvent extends Fake implements PopularTvEvent {}

class _FakePopularTvState extends Fake implements PopularTvState {}

void main() {
  setUpAll(() {
    registerFallbackValue(_FakePopularTvEvent());
    registerFallbackValue(_FakePopularTvState());
  });

  testWidgets('shows progress when loading', (tester) async {
    final bloc = _MockPopularTvBloc();
    whenListen(
      bloc,
      Stream<PopularTvState>.fromIterable([PopularTvLoading()]),
      initialState: PopularTvInitial(),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<PopularTvBloc>.value(
          value: bloc,
          child: const PopularTvPage(),
        ),
      ),
    );

    // Need to let the BlocBuilder build with latest state
    await tester.pump();

    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('shows list when loaded', (tester) async {
    final bloc = _MockPopularTvBloc();
    final tvs = [
      const Tv(
        id: 1,
        name: 'A',
        overview: 'O',
        posterPath: '/p',
        voteAverage: 8.0,
      ),
      const Tv(
        id: 2,
        name: 'B',
        overview: 'O2',
        posterPath: '/p2',
        voteAverage: 7.0,
      ),
    ];

    whenListen(
      bloc,
      Stream<PopularTvState>.fromIterable([PopularTvLoaded(tvs)]),
      initialState: PopularTvInitial(),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<PopularTvBloc>.value(
          value: bloc,
          child: const PopularTvPage(),
        ),
      ),
    );

    await tester.pump();

    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('shows error message when error occurs', (tester) async {
    final bloc = _MockPopularTvBloc();
    const errorMessage = 'Failed to load popular TV series';

    whenListen(
      bloc,
      Stream<PopularTvState>.fromIterable([const PopularTvError(errorMessage)]),
      initialState: PopularTvInitial(),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<PopularTvBloc>.value(
          value: bloc,
          child: const PopularTvPage(),
        ),
      ),
    );

    await tester.pump();

    expect(find.byKey(const Key('error_message')), findsOneWidget);
    expect(find.text(errorMessage), findsOneWidget);
  });

  testWidgets('should show AppBar with correct title', (tester) async {
    final bloc = _MockPopularTvBloc();

    whenListen(
      bloc,
      Stream<PopularTvState>.fromIterable([]),
      initialState: PopularTvInitial(),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<PopularTvBloc>.value(
          value: bloc,
          child: const PopularTvPage(),
        ),
      ),
    );

    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text('Popular TV Series'), findsOneWidget);
  });

  testWidgets('should dispatch FetchPopularTv event on init', (tester) async {
    final bloc = _MockPopularTvBloc();

    whenListen(
      bloc,
      Stream<PopularTvState>.fromIterable([]),
      initialState: PopularTvInitial(),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<PopularTvBloc>.value(
          value: bloc,
          child: const PopularTvPage(),
        ),
      ),
    );

    await tester.pump(Duration.zero);

    verify(() => bloc.add(FetchPopularTv())).called(1);
  });

  testWidgets('should show empty container for initial state', (tester) async {
    final bloc = _MockPopularTvBloc();
    when(() => bloc.state).thenReturn(PopularTvInitial());
    whenListen(
      bloc,
      Stream<PopularTvState>.fromIterable([]),
      initialState: PopularTvInitial(),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<PopularTvBloc>.value(
          value: bloc,
          child: const PopularTvPage(),
        ),
      ),
    );

    await tester.pump();
    expect(find.byType(SizedBox), findsWidgets);
  });
}
