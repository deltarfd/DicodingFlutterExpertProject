import 'package:dartz/dartz.dart';
import 'package:ditonton_core/core/errors/failure.dart';
import 'package:ditonton_core/core/utils/state_enum.dart';
import 'package:ditonton_tv/features/tv/domain/entities/tv.dart';
import 'package:ditonton_tv/features/tv/domain/repositories/tv_repository.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_popular_tv.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/get_top_rated_tv.dart';
import 'package:ditonton_tv/features/tv/presentation/providers/popular_tv_notifier.dart';
import 'package:ditonton_tv/features/tv/presentation/providers/top_rated_tv_notifier.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeRepo implements TvRepository {
  List<Tv> data = const [];
  Failure? failure;
  @override
  Future<Either<Failure, List<Tv>>> getPopularTv() async =>
      failure != null ? Left(failure!) : Right(data);
  @override
  Future<Either<Failure, List<Tv>>> getTopRatedTv() async =>
      failure != null ? Left(failure!) : Right(data);
  @override
  noSuchMethod(Invocation i) => super.noSuchMethod(i);
}

void main() {
  final tTvList = [
    const Tv(
      id: 1,
      name: 'N',
      overview: 'O',
      posterPath: '/p',
      voteAverage: 8.0,
    ),
  ];

  group('PopularTvNotifier', () {
    test(
      'should change state to loading then loaded when fetch is successful',
      () async {
        final repo = _FakeRepo()..data = tTvList;
        final notifier = PopularTvNotifier(GetPopularTv(repo));

        expect(notifier.state, RequestState.Empty);

        notifier.fetchPopularTv();
        expect(notifier.state, RequestState.Loading);

        await Future.delayed(Duration.zero);
        expect(notifier.state, RequestState.Loaded);
        expect(notifier.tvs, tTvList);
      },
    );

    test('should return error when fetch fails', () async {
      final repo = _FakeRepo()..failure = const ServerFailure('Error');
      final notifier = PopularTvNotifier(GetPopularTv(repo));

      await notifier.fetchPopularTv();
      expect(notifier.state, RequestState.Error);
      expect(notifier.message, 'Error');
    });
  });

  group('TopRatedTvNotifier', () {
    test(
      'should change state to loading then loaded when fetch is successful',
      () async {
        final repo = _FakeRepo()..data = tTvList;
        final notifier = TopRatedTvNotifier(getTopRatedTv: GetTopRatedTv(repo));

        expect(notifier.state, RequestState.Empty);

        notifier.fetchTopRatedTv();
        expect(notifier.state, RequestState.Loading);

        await Future.delayed(Duration.zero);
        expect(notifier.state, RequestState.Loaded);
        expect(notifier.tvs, tTvList);
      },
    );

    test('should return error when fetch fails', () async {
      final repo = _FakeRepo()..failure = const ServerFailure('Error');
      final notifier = TopRatedTvNotifier(getTopRatedTv: GetTopRatedTv(repo));

      await notifier.fetchTopRatedTv();
      expect(notifier.state, RequestState.Error);
      expect(notifier.message, 'Error');
    });
  });
}
