import 'package:dartz/dartz.dart';
import 'package:ditonton_core/core/errors/failure.dart';
import 'package:ditonton_tv/features/tv/domain/entities/tv_detail.dart';
import 'package:ditonton_tv/features/tv/domain/repositories/tv_repository.dart';

class SaveWatchlistTv {
  final TvRepository repository;
  SaveWatchlistTv(this.repository);
  Future<Either<Failure, String>> execute(TvDetail tv) =>
      repository.saveWatchlist(tv);
}
