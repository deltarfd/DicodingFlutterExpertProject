import 'package:dartz/dartz.dart';
import 'package:ditonton_core/core/errors/failure.dart';
import 'package:ditonton_tv/features/tv/domain/entities/tv.dart';
import 'package:ditonton_tv/features/tv/domain/repositories/tv_repository.dart';
import 'package:ditonton_tv/features/tv/domain/usecases/search_tv.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeRepo implements TvRepository {
  List<Tv> result = const [];
  @override
  Future<Either<Failure, List<Tv>>> searchTv(String query) async =>
      Right(result);
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test('should return searched tv shows from repository', () async {
    final repo = _FakeRepo()
      ..result = const [
        Tv(
            id: 1,
            name: 'Test',
            overview: 'Overview',
            posterPath: '/x',
            voteAverage: 8.0)
      ];
    final usecase = SearchTv(repo);

    final result = await usecase.execute('test');

    expect(result, Right(repo.result));
  });
}
