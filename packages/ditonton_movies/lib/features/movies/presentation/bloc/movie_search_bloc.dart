import 'package:bloc/bloc.dart';
import 'package:ditonton_movies/features/movies/domain/entities/movie.dart';
import 'package:ditonton_movies/features/movies/domain/usecases/search_movies.dart';
import 'package:equatable/equatable.dart';

part 'movie_search_event.dart';
part 'movie_search_state.dart';

class MovieSearchBloc extends Bloc<MovieSearchEvent, MovieSearchState> {
  final SearchMovies searchMovies;
  MovieSearchBloc({required this.searchMovies}) : super(MovieSearchInitial()) {
    on<SubmitMovieQuery>((event, emit) async {
      emit(MovieSearchLoading());
      final result = await searchMovies.execute(event.query);
      result.fold(
        (failure) => emit(MovieSearchError(failure.message)),
        (data) => emit(MovieSearchLoaded(data)),
      );
    });
    on<ClearMovieQuery>((event, emit) => emit(MovieSearchInitial()));
  }
}
