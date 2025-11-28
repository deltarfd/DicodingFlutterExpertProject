part of 'movie_search_bloc.dart';

abstract class MovieSearchEvent extends Equatable {
  const MovieSearchEvent();
  @override
  List<Object?> get props => [];
}

class SubmitMovieQuery extends MovieSearchEvent {
  final String query;
  const SubmitMovieQuery(this.query);
  @override
  List<Object?> get props => [query];
}

class ClearMovieQuery extends MovieSearchEvent {
  const ClearMovieQuery();
}
