import 'package:dartz/dartz.dart';
import 'package:ditonton_core/core/errors/failure.dart';
import 'package:ditonton_tv/features/tv/domain/entities/tv.dart';
import 'package:ditonton_tv/features/tv/domain/repositories/tv_repository.dart';

class SearchTv {
  final TvRepository repository;
  SearchTv(this.repository);
  Future<Either<Failure, List<Tv>>> execute(String query) =>
      repository.searchTv(query);
}
