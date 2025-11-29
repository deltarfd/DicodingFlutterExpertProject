import 'package:ditonton_movies/features/movies/domain/entities/movie.dart';
import 'package:equatable/equatable.dart';

abstract class TopRatedMoviesState extends Equatable {
  const TopRatedMoviesState();

  @override
  List<Object> get props => [];
}

class TopRatedMoviesEmpty extends TopRatedMoviesState {}

class TopRatedMoviesLoading extends TopRatedMoviesState {}

class TopRatedMoviesLoaded extends TopRatedMoviesState {
  final List<Movie> movies;

  const TopRatedMoviesLoaded(this.movies);

  @override
  List<Object> get props => [movies];
}

class TopRatedMoviesError extends TopRatedMoviesState {
  final String message;

  const TopRatedMoviesError(this.message);

  @override
  List<Object> get props => [message];
}
