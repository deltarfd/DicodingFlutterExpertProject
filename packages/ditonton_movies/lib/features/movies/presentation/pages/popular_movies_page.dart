import 'package:ditonton_core/core/core.dart';
import 'package:ditonton_movies/features/movies/presentation/providers/popular_movies_notifier.dart';
import 'package:ditonton_movies/features/movies/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ignore_for_file: use_build_context_synchronously

class PopularMoviesPage extends StatefulWidget {
  // ignore: constant_identifier_names
  static const ROUTE_NAME = '/popular-movie';

  const PopularMoviesPage({super.key});

  @override
  State<PopularMoviesPage> createState() => _PopularMoviesPageState();
}

class _PopularMoviesPageState extends State<PopularMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<PopularMoviesNotifier>(context, listen: false)
            .fetchPopularMovies());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<PopularMoviesNotifier>(
          builder: (context, data, child) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: data.state == RequestState.Loading
                  ? ListView.builder(
                      itemCount: 8,
                      itemBuilder: (_, __) => const MovieListTileSkeleton(),
                    )
                  : data.state == RequestState.Loaded
                      ? ListView.builder(
                          itemBuilder: (context, index) {
                            final movie = data.movies[index];
                            return MovieCard(movie);
                          },
                          itemCount: data.movies.length,
                        )
                      : Center(
                          key: const Key('error_message'),
                          child: Text(data.message),
                        ),
            );
          },
        ),
      ),
    );
  }
}
