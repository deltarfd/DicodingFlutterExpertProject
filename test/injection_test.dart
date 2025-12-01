import 'package:ditonton/injection.dart' as di;
import 'package:ditonton/app/theme_mode_cubit.dart';
import 'package:ditonton_core/core/network/ssl_pinning_client.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/now_playing_movies_bloc.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/movie_detail_bloc.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/tv_detail_bloc.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/on_the_air_tv_bloc.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/airing_today_tv_bloc.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/popular_tv_bloc.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/top_rated_tv_bloc.dart';
import 'package:ditonton_movies/features/movies/domain/repositories/movie_repository.dart';
import 'package:ditonton_tv/features/tv/domain/repositories/tv_repository.dart';
import 'package:ditonton_movies/features/movies/data/datasources/movie_remote_data_source.dart';
import 'package:ditonton_movies/features/movies/data/datasources/movie_local_data_source.dart';
import 'package:ditonton_tv/features/tv/data/datasources/tv_remote_data_source.dart';
import 'package:ditonton_tv/features/tv/data/datasources/tv_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('init() registers all dependencies', () async {
    // Setup
    await di.locator.reset();
    SharedPreferences.setMockInitialValues({});

    // Execute
    di.init();

    // Verify registrations
    expect(di.locator.isRegistered<ThemeModeCubit>(), isTrue);
    expect(di.locator.isRegistered<http.Client>(), isTrue);

    // Verify factories
    expect(di.locator<NowPlayingMoviesBloc>(), isA<NowPlayingMoviesBloc>());

    // Verify SslPinningClient
    final client = di.locator<http.Client>();
    expect(client, isA<SslPinningClient>());
  });

  test('MovieDetailBloc registration with all dependencies', () async {
    // Setup
    await di.locator.reset();
    SharedPreferences.setMockInitialValues({});
    di.init();

    // Create MovieDetailBloc to trigger multiline constructor (lines 62-66)
    final bloc = di.locator<MovieDetailBloc>();
    expect(bloc, isA<MovieDetailBloc>());
    await bloc.close();
  });

  test('TvDetailBloc registration with all dependencies', () async {
    // Setup
    await di.locator.reset();
    SharedPreferences.setMockInitialValues({});
    di.init();

    // Create TvDetailBloc to trigger multiline constructor (lines 76-80)
    final bloc = di.locator<TvDetailBloc>();
    expect(bloc, isA<TvDetailBloc>());
    await bloc.close();
  });

  test('OnTheAirTvBloc registration', () async {
    // Setup
    await di.locator.reset();
    SharedPreferences.setMockInitialValues({});
    di.init();

    // Create OnTheAirTvBloc
    final bloc = di.locator<OnTheAirTvBloc>();
    expect(bloc, isA<OnTheAirTvBloc>());
    await bloc.close();
  });

  test('TV BLoCs registration', () async {
    // Setup
    await di.locator.reset();
    SharedPreferences.setMockInitialValues({});
    di.init();

    // Test AiringTodayTvBloc
    final airingTodayBloc = di.locator<AiringTodayTvBloc>();
    expect(airingTodayBloc, isA<AiringTodayTvBloc>());
    await airingTodayBloc.close();

    // Test PopularTvBloc
    final popularBloc = di.locator<PopularTvBloc>();
    expect(popularBloc, isA<PopularTvBloc>());
    await popularBloc.close();

    // Test TopRatedTvBloc
    final topRatedBloc = di.locator<TopRatedTvBloc>();
    expect(topRatedBloc, isA<TopRatedTvBloc>());
    await topRatedBloc.close();
  });

  test('Repository registrations', () async {
    // Setup
    await di.locator.reset();
    SharedPreferences.setMockInitialValues({});
    di.init();

    // Verify MovieRepository (lines 118-120)
    expect(di.locator.isRegistered<MovieRepository>(), isTrue);
    final movieRepo = di.locator<MovieRepository>();
    expect(movieRepo, isNotNull);

    // Verify TvRepository
    expect(di.locator.isRegistered<TvRepository>(), isTrue);
    final tvRepo = di.locator<TvRepository>();
    expect(tvRepo, isNotNull);
  });

  test('Data source registrations', () async {
    // Setup
    await di.locator.reset();
    SharedPreferences.setMockInitialValues({});
    di.init();

    // Verify MovieRemoteDataSource
    expect(di.locator.isRegistered<MovieRemoteDataSource>(), isTrue);

    // Verify MovieLocalDataSource
    expect(di.locator.isRegistered<MovieLocalDataSource>(), isTrue);

    // Verify TvRemoteDataSource (line 130)
    expect(di.locator.isRegistered<TvRemoteDataSource>(), isTrue);

    // Verify TvLocalDataSource (line 132)
    expect(di.locator.isRegistered<TvLocalDataSource>(), isTrue);
  });
}
