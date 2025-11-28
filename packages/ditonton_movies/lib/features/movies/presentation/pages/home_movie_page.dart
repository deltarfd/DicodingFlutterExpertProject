import 'package:ditonton_core/core/core.dart';
import 'package:ditonton_movies/features/movies/domain/entities/movie.dart';
import 'package:ditonton_movies/features/movies/presentation/pages/movie_detail_page.dart';
import 'package:ditonton_movies/features/movies/presentation/pages/popular_movies_page.dart';
import 'package:ditonton_movies/features/movies/presentation/pages/search_page.dart';
import 'package:ditonton_movies/features/movies/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton_movies/features/movies/presentation/pages/watchlist_movies_page.dart';
import 'package:ditonton_movies/features/movies/presentation/providers/movie_list_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    Future.microtask(
        () => Provider.of<MovieListNotifier>(context, listen: false)
          ..fetchNowPlayingMovies()
          ..fetchPopularMovies()
          ..fetchTopRatedMovies());
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
              Consumer<MovieListNotifier>(builder: (context, data, child) {
                final state = data.nowPlayingState;
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: state == RequestState.Loading
                      ? const HorizontalPosterSkeletonList(itemCount: 8)
                      : state == RequestState.Loaded
                          ? _MovieList(data.nowPlayingMovies)
                          : const Text('Failed'),
                );
              }),
              _buildSubHeading(
                title: 'Popular',
                onTap: () =>
                    Navigator.pushNamed(context, PopularMoviesPage.ROUTE_NAME),
              ),
              Consumer<MovieListNotifier>(builder: (context, data, child) {
                final state = data.popularMoviesState;
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: state == RequestState.Loading
                      ? const HorizontalPosterSkeletonList(itemCount: 8)
                      : state == RequestState.Loaded
                          ? _MovieList(data.popularMovies)
                          : const Text('Failed'),
                );
              }),
              _buildSubHeading(
                title: 'Top Rated',
                onTap: () =>
                    Navigator.pushNamed(context, TopRatedMoviesPage.ROUTE_NAME),
              ),
              Consumer<MovieListNotifier>(builder: (context, data, child) {
                final state = data.topRatedMoviesState;
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: state == RequestState.Loading
                      ? const HorizontalPosterSkeletonList(itemCount: 8)
                      : state == RequestState.Loaded
                          ? _MovieList(data.topRatedMovies)
                          : const Text('Failed'),
                );
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
