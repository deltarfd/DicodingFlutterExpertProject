import 'package:bloc/bloc.dart';
import 'package:ditonton_movies/features/movies/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/top_rated_movies_event.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/top_rated_movies_state.dart';

class TopRatedMoviesBloc
    extends Bloc<TopRatedMoviesEvent, TopRatedMoviesState> {
  final GetTopRatedMovies getTopRatedMovies;

  TopRatedMoviesBloc(this.getTopRatedMovies) : super(TopRatedMoviesEmpty()) {
    on<FetchTopRatedMovies>((event, emit) async {
      emit(TopRatedMoviesLoading());
      final result = await getTopRatedMovies.execute();

      result.fold(
        (failure) {
          emit(TopRatedMoviesError(failure.message));
        },
        (data) {
          emit(TopRatedMoviesLoaded(data));
        },
      );
    });
  }
}
