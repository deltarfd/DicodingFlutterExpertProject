import 'package:ditonton_movies/features/movies/domain/entities/movie.dart';
import 'package:equatable/equatable.dart';

abstract class WatchlistMovieState extends Equatable {
  const WatchlistMovieState();

  @override
  List<Object> get props => [];
}

class WatchlistMovieEmpty extends WatchlistMovieState {}

class WatchlistMovieLoading extends WatchlistMovieState {}

class WatchlistMovieLoaded extends WatchlistMovieState {
  final List<Movie> movies;

  const WatchlistMovieLoaded(this.movies);

  @override
  List<Object> get props => [movies];
}

class WatchlistMovieError extends WatchlistMovieState {
  final String message;

  const WatchlistMovieError(this.message);

  @override
  List<Object> get props => [message];
}
