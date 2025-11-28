import 'package:dartz/dartz.dart';
import 'package:ditonton_core/core/errors/failure.dart';
import 'package:ditonton_core/core/utils/state_enum.dart';
import 'package:ditonton_tv/features/tv/domain/entities/tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_airing_today_tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_on_the_air_tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_popular_tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_top_rated_tv.dart';
import 'package:ditonton_tv/features/tv/presentation/providers/tv_list_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_list_notifier_comprehensive_test.mocks.dart';

@GenerateMocks([GetAiringTodayTv, GetPopularTv, GetTopRatedTv, GetOnTheAirTv])
void main() {
  late TvListNotifier provider;
  late MockGetAiringTodayTv mockGetAiringTodayTv;
  late MockGetPopularTv mockGetPopularTv;
  late MockGetTopRatedTv mockGetTopRatedTv;
  late MockGetOnTheAirTv mockGetOnTheAirTv;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetAiringTodayTv = MockGetAiringTodayTv();
    mockGetPopularTv = MockGetPopularTv();
    mockGetTopRatedTv = MockGetTopRatedTv();
    mockGetOnTheAirTv = MockGetOnTheAirTv();
    provider =
        TvListNotifier(
          getAiringTodayTv: mockGetAiringTodayTv,
          getPopularTv: mockGetPopularTv,
          getTopRatedTv: mockGetTopRatedTv,
          getOnTheAirTv: mockGetOnTheAirTv,
        )..addListener(() {
          listenerCallCount += 1;
        });
  });

  const tTv = Tv(
    id: 1,
    name: 'Name',
    overview: 'Overview',
    posterPath: '/path.jpg',
    voteAverage: 1.0,
  );

  final tTvList = <Tv>[tTv];

  group('airing today tv', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(
        mockGetAiringTodayTv.execute(),
      ).thenAnswer((_) async => Right(tTvList));
      // act
      provider.fetchAiringTodayTv();
      // assert
      expect(provider.airingTodayState, RequestState.Loading);
    });

    test('should change tv data when data is gotten successfully', () async {
      // arrange
      when(
        mockGetAiringTodayTv.execute(),
      ).thenAnswer((_) async => Right(tTvList));
      // act
      await provider.fetchAiringTodayTv();
      // assert
      expect(provider.airingTodayState, RequestState.Loaded);
      expect(provider.airingToday, tTvList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(
        mockGetAiringTodayTv.execute(),
      ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchAiringTodayTv();
      // assert
      expect(provider.airingTodayState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('popular tv', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockGetPopularTv.execute()).thenAnswer((_) async => Right(tTvList));
      // act
      provider.fetchPopularTv();
      // assert
      expect(provider.popularState, RequestState.Loading);
    });

    test('should change tv data when data is gotten successfully', () async {
      // arrange
      when(mockGetPopularTv.execute()).thenAnswer((_) async => Right(tTvList));
      // act
      await provider.fetchPopularTv();
      // assert
      expect(provider.popularState, RequestState.Loaded);
      expect(provider.popular, tTvList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(
        mockGetPopularTv.execute(),
      ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchPopularTv();
      // assert
      expect(provider.popularState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('top rated tv', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockGetTopRatedTv.execute()).thenAnswer((_) async => Right(tTvList));
      // act
      provider.fetchTopRatedTv();
      // assert
      expect(provider.topRatedState, RequestState.Loading);
    });

    test('should change tv data when data is gotten successfully', () async {
      // arrange
      when(mockGetTopRatedTv.execute()).thenAnswer((_) async => Right(tTvList));
      // act
      await provider.fetchTopRatedTv();
      // assert
      expect(provider.topRatedState, RequestState.Loaded);
      expect(provider.topRated, tTvList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(
        mockGetTopRatedTv.execute(),
      ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchTopRatedTv();
      // assert
      expect(provider.topRatedState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('on the air tv', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockGetOnTheAirTv.execute()).thenAnswer((_) async => Right(tTvList));
      // act
      provider.fetchOnTheAirTv();
      // assert
      expect(provider.onTheAirState, RequestState.Loading);
    });

    test('should change tv data when data is gotten successfully', () async {
      // arrange
      when(mockGetOnTheAirTv.execute()).thenAnswer((_) async => Right(tTvList));
      // act
      await provider.fetchOnTheAirTv();
      // assert
      expect(provider.onTheAirState, RequestState.Loaded);
      expect(provider.onTheAir, tTvList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(
        mockGetOnTheAirTv.execute(),
      ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchOnTheAirTv();
      // assert
      expect(provider.onTheAirState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
