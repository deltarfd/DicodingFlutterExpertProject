import 'package:ditonton_core/domain/entities/genre.dart';
import 'package:equatable/equatable.dart';

class TvDetail extends Equatable {
  final int id;
  final String name;
  final String overview;
  final String? posterPath;
  final double voteAverage;
  final List<Genre> genres;
  final List<Season> seasons;

  const TvDetail({
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.voteAverage,
    required this.genres,
    required this.seasons,
  });

  @override
  List<Object?> get props =>
      [id, name, overview, posterPath, voteAverage, genres, seasons];
}

class Season extends Equatable {
  final int id;
  final int seasonNumber;
  final String name;
  final String? posterPath;
  final int episodeCount;

  const Season({
    required this.id,
    required this.seasonNumber,
    required this.name,
    required this.posterPath,
    required this.episodeCount,
  });

  @override
  List<Object?> get props => [id, seasonNumber, name, posterPath, episodeCount];
}
