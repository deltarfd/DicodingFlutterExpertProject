import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton_core/core/errors/failure.dart';
import 'package:ditonton_tv/features/tv/domain/entities/tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_watchlist_tv.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/watchlist_tv_bloc.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/watchlist_tv_event.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/watchlist_tv_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'watchlist_tv_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistTv])
void main() {
  late WatchlistTvBloc bloc;
  late MockGetWatchlistTv mockGetWatchlistTv;

  setUp(() {
    mockGetWatchlistTv = MockGetWatchlistTv();
    bloc = WatchlistTvBloc(mockGetWatchlistTv);
  });

  test('initial state should be empty', () {
    expect(bloc.state, WatchlistTvEmpty());
  });

  final tTv = Tv(
    backdropPath: 'backdropPath',
    genreIds: const [1, 2, 3],
    id: 1,
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    firstAirDate: 'firstAirDate',
    name: 'name',
    voteAverage: 1,
    voteCount: 1,
  );
  final tTvList = <Tv>[tTv];

  blocTest<WatchlistTvBloc, WatchlistTvState>(
    'Should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(
        mockGetWatchlistTv.execute(),
      ).thenAnswer((_) async => Right(tTvList));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistTv()),
    expect: () => [WatchlistTvLoading(), WatchlistTvLoaded(tTvList)],
    verify: (bloc) {
      verify(mockGetWatchlistTv.execute());
    },
  );

  blocTest<WatchlistTvBloc, WatchlistTvState>(
    'Should emit [Loading, Error] when get data is unsuccessful',
    build: () {
      when(
        mockGetWatchlistTv.execute(),
      ).thenAnswer((_) async => const Left(DatabaseFailure("Can't get data")));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistTv()),
    expect: () => [
      WatchlistTvLoading(),
      const WatchlistTvError("Can't get data"),
    ],
    verify: (bloc) {
      verify(mockGetWatchlistTv.execute());
    },
  );
}
