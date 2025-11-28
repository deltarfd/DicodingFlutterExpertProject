import 'package:dartz/dartz.dart';
import 'package:ditonton_core/core/errors/failure.dart';
import 'package:ditonton_core/core/utils/state_enum.dart';
import 'package:ditonton_tv/features/tv/domain/entities/tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/search_tv.dart';
import 'package:ditonton_tv/features/tv/presentation/providers/tv_search_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_search_notifier_test.mocks.dart';

@GenerateMocks([SearchTv])
void main() {
  late TvSearchNotifier notifier;
  late MockSearchTv mockSearchTv;

  setUp(() {
    mockSearchTv = MockSearchTv();
    notifier = TvSearchNotifier(searchTv: mockSearchTv);
  });

  const tQuery = 'naruto';
  final tTvList = [
    const Tv(
      id: 1,
      name: 'Naruto',
      overview: 'Overview',
      posterPath: '/path.jpg',
      voteAverage: 8.0,
    ),
  ];

  test('initial state should be empty', () {
    expect(notifier.state, RequestState.Empty);
    expect(notifier.searchResult, []);
    expect(notifier.message, '');
  });

  test('should change state to loading when fetching search result', () async {
    // arrange
    when(mockSearchTv.execute(tQuery)).thenAnswer((_) async => Right(tTvList));

    // act
    notifier.fetchTvSearch(tQuery);

    // assert
    expect(notifier.state, RequestState.Loading);
  });

  test(
    'should change search result when data is gotten successfully',
    () async {
      // arrange
      when(
        mockSearchTv.execute(tQuery),
      ).thenAnswer((_) async => Right(tTvList));

      // act
      await notifier.fetchTvSearch(tQuery);

      // assert
      expect(notifier.state, RequestState.Loaded);
      expect(notifier.searchResult, tTvList);
    },
  );

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(
      mockSearchTv.execute(tQuery),
    ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));

    // act
    await notifier.fetchTvSearch(tQuery);

    // assert
    expect(notifier.state, RequestState.Error);
    expect(notifier.message, 'Server Failure');
  });
}
