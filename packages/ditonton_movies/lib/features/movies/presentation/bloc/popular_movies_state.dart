import 'package:ditonton_movies/features/movies/domain/entities/movie.dart';
import 'package:equatable/equatable.dart';

abstract class PopularMoviesState extends Equatable {
  const PopularMoviesState();

  @override
  List<Object> get props => [];
}

class PopularMoviesEmpty extends PopularMoviesState {}

class PopularMoviesLoading extends PopularMoviesState {}

class PopularMoviesLoaded extends PopularMoviesState {
  final List<Movie> movies;

  const PopularMoviesLoaded(this.movies);

  @override
  List<Object> get props => [movies];
}

class PopularMoviesError extends PopularMoviesState {
  final String message;

  const PopularMoviesError(this.message);

  @override
  List<Object> get props => [message];
}
