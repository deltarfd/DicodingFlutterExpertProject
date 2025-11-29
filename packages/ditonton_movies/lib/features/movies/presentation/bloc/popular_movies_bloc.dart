import 'package:bloc/bloc.dart';
import 'package:ditonton_movies/features/movies/domain/usecases/get_popular_movies.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/popular_movies_event.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/popular_movies_state.dart';

class PopularMoviesBloc extends Bloc<PopularMoviesEvent, PopularMoviesState> {
  final GetPopularMovies getPopularMovies;

  PopularMoviesBloc(this.getPopularMovies) : super(PopularMoviesEmpty()) {
    on<FetchPopularMovies>((event, emit) async {
      emit(PopularMoviesLoading());
      final result = await getPopularMovies.execute();

      result.fold(
        (failure) {
          emit(PopularMoviesError(failure.message));
        },
        (data) {
          emit(PopularMoviesLoaded(data));
        },
      );
    });
  }
}
