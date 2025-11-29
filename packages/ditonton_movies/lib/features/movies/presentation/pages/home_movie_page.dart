import 'package:ditonton_core/core/core.dart';
import 'package:ditonton_movies/features/movies/domain/entities/movie.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/now_playing_movies_bloc.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/now_playing_movies_event.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/now_playing_movies_state.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/popular_movies_bloc.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/popular_movies_event.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/popular_movies_state.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/top_rated_movies_bloc.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/top_rated_movies_event.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/top_rated_movies_state.dart';
import 'package:ditonton_movies/features/movies/presentation/pages/movie_detail_page.dart';
import 'package:ditonton_movies/features/movies/presentation/pages/popular_movies_page.dart';
import 'package:ditonton_movies/features/movies/presentation/pages/search_page.dart';
import 'package:ditonton_movies/features/movies/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton_movies/features/movies/presentation/pages/watchlist_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore_for_file: use_build_context_synchronously

class HomeMoviePage extends StatefulWidget {
  const HomeMoviePage({super.key});
  // ignore: constant_identifier_names
  static const ROUTE_NAME = '/home-movie';
  @override
  State<HomeMoviePage> createState() => _HomeMoviePageState();
}

class _HomeMoviePageState extends State<HomeMoviePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<NowPlayingMoviesBloc>().add(FetchNowPlayingMovies());
      context.read<PopularMoviesBloc>().add(FetchPopularMovies());
      context.read<TopRatedMoviesBloc>().add(FetchTopRatedMovies());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies'),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, WatchlistMoviesPage.ROUTE_NAME),
            icon: const Icon(Icons.bookmark),
            tooltip: 'Watchlist',
          ),
          IconButton(
            tooltip: 'Search',
            onPressed: () =>
                Navigator.pushNamed(context, SearchPage.ROUTE_NAME),
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Now Playing', style: kHeading6),
              BlocBuilder<NowPlayingMoviesBloc, NowPlayingMoviesState>(
                  builder: (context, state) {
                final state = context.watch<NowPlayingMoviesBloc>().state;
                if (state is NowPlayingMoviesLoading) {
                  return const HorizontalPosterSkeletonList(itemCount: 8);
                } else if (state is NowPlayingMoviesLoaded) {
                  return _MovieList(state.movies);
                } else {
                  return const Text('Failed');
                }
              }),
              _buildSubHeading(
                title: 'Popular',
                onTap: () =>
                    Navigator.pushNamed(context, PopularMoviesPage.ROUTE_NAME),
              ),
              BlocBuilder<PopularMoviesBloc, PopularMoviesState>(
                  builder: (context, state) {
                final state = context.watch<PopularMoviesBloc>().state;
                if (state is PopularMoviesLoading) {
                  return const HorizontalPosterSkeletonList(itemCount: 8);
                } else if (state is PopularMoviesLoaded) {
                  return _MovieList(state.movies);
                } else {
                  return const Text('Failed');
                }
              }),
              _buildSubHeading(
                title: 'Top Rated',
                onTap: () =>
                    Navigator.pushNamed(context, TopRatedMoviesPage.ROUTE_NAME),
              ),
              BlocBuilder<TopRatedMoviesBloc, TopRatedMoviesState>(
                  builder: (context, state) {
                final state = context.watch<TopRatedMoviesBloc>().state;
                if (state is TopRatedMoviesLoading) {
                  return const HorizontalPosterSkeletonList(itemCount: 8);
                } else if (state is TopRatedMoviesLoaded) {
                  return _MovieList(state.movies);
                } else {
                  return const Text('Failed');
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: kHeading6),
        InkWell(
          onTap: onTap,
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
                children: [Text('See More'), Icon(Icons.arrow_forward_ios)]),
          ),
        ),
      ],
    );
  }
}

class _MovieList extends StatelessWidget {
  final List<Movie> movies;
  const _MovieList(this.movies);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  MovieDetailPage.ROUTE_NAME,
                  arguments: movie.id,
                );
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: CachedImage(
                  imageUrl: '$BASE_IMAGE_URL${movie.posterPath}',
                  width: 120,
                  height: 180,
                ),
              ),
            ),
          );
        },
        itemCount: movies.length,
      ),
    );
  }
}
