import 'package:dartz/dartz.dart';
import 'package:ditonton_core/core/errors/failure.dart';
import 'package:ditonton_tv/features/tv/domain/entities/tv_detail.dart';
import 'package:ditonton_tv/features/tv/domain/repositories/tv_repository.dart';

class RemoveWatchlistTv {
  final TvRepository repository;
  RemoveWatchlistTv(this.repository);
  Future<Either<Failure, String>> execute(TvDetail tv) =>
      repository.removeWatchlist(tv);
}
