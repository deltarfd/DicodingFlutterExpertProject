import 'package:bloc/bloc.dart';
import 'package:ditonton_movies/features/movies/domain/usecases/get_movie_detail.dart';
import 'package:ditonton_movies/features/movies/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton_movies/features/movies/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton_movies/features/movies/domain/usecases/remove_watchlist.dart';
import 'package:ditonton_movies/features/movies/domain/usecases/save_watchlist.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/movie_detail_event.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;
  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  MovieDetailBloc({
    required this.getMovieDetail,
    required this.getMovieRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(MovieDetailState.initial()) {
    on<FetchMovieDetail>((event, emit) async {
      emit(state.copyWith(movieDetailStatus: MovieDetailStatus.loading));
      final detailResult = await getMovieDetail.execute(event.id);
      final recommendationResult =
          await getMovieRecommendations.execute(event.id);

      detailResult.fold(
        (failure) {
          emit(state.copyWith(
            movieDetailStatus: MovieDetailStatus.error,
            message: failure.message,
          ));
        },
        (movie) {
          emit(state.copyWith(
            movieDetail: movie,
            movieDetailStatus: MovieDetailStatus.loaded,
            message: '',
          ));
          recommendationResult.fold(
            (failure) {
              emit(state.copyWith(
                message: failure.message,
              ));
            },
            (movies) {
              emit(state.copyWith(
                movieRecommendations: movies,
                message: '',
              ));
            },
          );
        },
      );
    });

    on<AddWatchlist>((event, emit) async {
      final result = await saveWatchlist.execute(event.movie);

      result.fold(
        (failure) {
          emit(state.copyWith(watchlistMessage: failure.message));
        },
        (successMessage) {
          emit(state.copyWith(watchlistMessage: successMessage));
        },
      );

      add(LoadWatchlistStatus(event.movie.id));
    });

    on<RemoveFromWatchlist>((event, emit) async {
      final result = await removeWatchlist.execute(event.movie);

      result.fold(
        (failure) {
          emit(state.copyWith(watchlistMessage: failure.message));
        },
        (successMessage) {
          emit(state.copyWith(watchlistMessage: successMessage));
        },
      );

      add(LoadWatchlistStatus(event.movie.id));
    });

    on<LoadWatchlistStatus>((event, emit) async {
      final result = await getWatchListStatus.execute(event.id);
      emit(state.copyWith(isAddedToWatchlist: result));
    });
  }
}
