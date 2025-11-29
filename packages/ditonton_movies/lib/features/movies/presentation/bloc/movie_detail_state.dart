import 'package:ditonton_movies/features/movies/domain/entities/movie.dart';
import 'package:ditonton_movies/features/movies/domain/entities/movie_detail.dart';
import 'package:equatable/equatable.dart';

enum MovieDetailStatus { initial, loading, loaded, error }

class MovieDetailState extends Equatable {
  final MovieDetailStatus movieDetailStatus;
  final MovieDetail? movieDetail;
  final List<Movie> movieRecommendations;
  final bool isAddedToWatchlist;
  final String message;
  final String watchlistMessage;

  const MovieDetailState({
    required this.movieDetailStatus,
    required this.movieDetail,
    required this.movieRecommendations,
    required this.isAddedToWatchlist,
    required this.message,
    required this.watchlistMessage,
  });

  factory MovieDetailState.initial() {
    return const MovieDetailState(
      movieDetailStatus: MovieDetailStatus.initial,
      movieDetail: null,
      movieRecommendations: [],
      isAddedToWatchlist: false,
      message: '',
      watchlistMessage: '',
    );
  }

  MovieDetailState copyWith({
    MovieDetailStatus? movieDetailStatus,
    MovieDetail? movieDetail,
    List<Movie>? movieRecommendations,
    bool? isAddedToWatchlist,
    String? message,
    String? watchlistMessage,
  }) {
    return MovieDetailState(
      movieDetailStatus: movieDetailStatus ?? this.movieDetailStatus,
      movieDetail: movieDetail ?? this.movieDetail,
      movieRecommendations: movieRecommendations ?? this.movieRecommendations,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      message: message ?? this.message,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
    );
  }

  @override
  List<Object?> get props => [
        movieDetailStatus,
        movieDetail,
        movieRecommendations,
        isAddedToWatchlist,
        message,
        watchlistMessage,
      ];
}
