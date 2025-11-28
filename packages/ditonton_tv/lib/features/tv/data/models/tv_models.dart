import 'package:ditonton_tv/features/tv/data/models/genre_model.dart';
import 'package:ditonton_tv/features/tv/domain/entities/episode.dart';
import 'package:ditonton_tv/features/tv/domain/entities/season_detail.dart';
import 'package:ditonton_tv/features/tv/domain/entities/tv.dart';
import 'package:ditonton_tv/features/tv/domain/entities/tv_detail.dart';
import 'package:equatable/equatable.dart';

class TvModel extends Equatable {
  final int id;
  final String name;
  final String overview;
  final String? posterPath;
  final double voteAverage;

  const TvModel({
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.voteAverage,
  });

  factory TvModel.fromJson(Map<String, dynamic> json) => TvModel(
        id: json['id'],
        name: json['name'] ?? json['original_name'] ?? '',
        overview: json['overview'] ?? '',
        posterPath: json['poster_path'],
        voteAverage: (json['vote_average'] ?? 0).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'overview': overview,
        'poster_path': posterPath,
        'vote_average': voteAverage,
      };

  Tv toEntity() => Tv(
        id: id,
        name: name,
        overview: overview,
        posterPath: posterPath,
        voteAverage: voteAverage,
      );

  @override
  List<Object?> get props => [id, name, overview, posterPath, voteAverage];
}

class TvDetailResponse extends Equatable {
  final int id;
  final String name;
  final String overview;
  final String? posterPath;
  final double voteAverage;
  final List<GenreModel> genres;
  final List<SeasonModel> seasons;

  const TvDetailResponse({
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.voteAverage,
    required this.genres,
    required this.seasons,
  });

  factory TvDetailResponse.fromJson(Map<String, dynamic> json) =>
      TvDetailResponse(
        id: json['id'],
        name: json['name'] ?? json['original_name'] ?? '',
        overview: json['overview'] ?? '',
        posterPath: json['poster_path'],
        voteAverage: (json['vote_average'] ?? 0).toDouble(),
        genres: (json['genres'] as List<dynamic>? ?? [])
            .map((e) => GenreModel.fromJson(e))
            .toList(),
        seasons: (json['seasons'] as List<dynamic>? ?? [])
            .map((e) => SeasonModel.fromJson(e))
            .toList(),
      );

  TvDetail toEntity() => TvDetail(
        id: id,
        name: name,
        overview: overview,
        posterPath: posterPath,
        voteAverage: voteAverage,
        genres: genres.map((e) => e.toEntity()).toList(),
        seasons: seasons.map((e) => e.toEntity()).toList(),
      );

  @override
  List<Object?> get props =>
      [id, name, overview, posterPath, voteAverage, genres, seasons];
}

class SeasonModel extends Equatable {
  final int id;
  final int seasonNumber;
  final String name;
  final String? posterPath;
  final int episodeCount;

  const SeasonModel({
    required this.id,
    required this.seasonNumber,
    required this.name,
    required this.posterPath,
    required this.episodeCount,
  });

  factory SeasonModel.fromJson(Map<String, dynamic> json) => SeasonModel(
        id: json['id'],
        seasonNumber: json['season_number'] ?? 0,
        name: json['name'] ?? '',
        posterPath: json['poster_path'],
        episodeCount: json['episode_count'] ?? 0,
      );

  Season toEntity() => Season(
        id: id,
        seasonNumber: seasonNumber,
        name: name,
        posterPath: posterPath,
        episodeCount: episodeCount,
      );

  @override
  List<Object?> get props => [id, seasonNumber, name, posterPath, episodeCount];
}

class TvResponse extends Equatable {
  final List<TvModel> tvList;

  const TvResponse({required this.tvList});

  factory TvResponse.fromJson(Map<String, dynamic> json) => TvResponse(
        tvList: (json['results'] as List<dynamic>)
            .map((e) => TvModel.fromJson(e))
            .toList(),
      );

  @override
  List<Object?> get props => [tvList];
}

class EpisodeModel extends Equatable {
  final int id;
  final String name;
  final int episodeNumber;
  final String overview;
  final String? stillPath;

  const EpisodeModel({
    required this.id,
    required this.name,
    required this.episodeNumber,
    required this.overview,
    required this.stillPath,
  });

  factory EpisodeModel.fromJson(Map<String, dynamic> json) => EpisodeModel(
        id: json['id'],
        name: json['name'] ?? '',
        episodeNumber: json['episode_number'] ?? 0,
        overview: json['overview'] ?? '',
        stillPath: json['still_path'],
      );

  Episode toEntity() => Episode(
        id: id,
        name: name,
        episodeNumber: episodeNumber,
        overview: overview,
        stillPath: stillPath,
      );

  @override
  List<Object?> get props => [id, name, episodeNumber, overview, stillPath];
}

class SeasonDetailResponse extends Equatable {
  final int id;
  final int seasonNumber;
  final List<EpisodeModel> episodes;

  const SeasonDetailResponse({
    required this.id,
    required this.seasonNumber,
    required this.episodes,
  });

  factory SeasonDetailResponse.fromJson(Map<String, dynamic> json) =>
      SeasonDetailResponse(
        id: json['id'],
        seasonNumber: json['season_number'] ?? 0,
        episodes: (json['episodes'] as List<dynamic>? ?? [])
            .map((e) => EpisodeModel.fromJson(e))
            .toList(),
      );

  SeasonDetail toEntity() => SeasonDetail(
        id: id,
        seasonNumber: seasonNumber,
        episodes: episodes.map((e) => e.toEntity()).toList(),
      );

  @override
  List<Object?> get props => [id, seasonNumber, episodes];
}
