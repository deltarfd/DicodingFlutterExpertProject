import 'package:ditonton_core/core/core.dart';
import 'package:ditonton_movies/features/movies/presentation/providers/watchlist_movie_notifier.dart';
import 'package:ditonton_movies/features/movies/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ignore_for_file: use_build_context_synchronously

class WatchlistMoviesPage extends StatefulWidget {
  // ignore: constant_identifier_names
  static const ROUTE_NAME = '/watchlist-movie';

  const WatchlistMoviesPage({super.key});

  @override
  State<WatchlistMoviesPage> createState() => _WatchlistMoviesPageState();
}

class _WatchlistMoviesPageState extends State<WatchlistMoviesPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<WatchlistMovieNotifier>(context, listen: false)
            .fetchWatchlistMovies());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    Provider.of<WatchlistMovieNotifier>(context, listen: false)
        .fetchWatchlistMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watchlist'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<WatchlistMovieNotifier>(
          builder: (context, data, child) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: data.watchlistState == RequestState.Loading
                  ? ListView.builder(
                      itemCount: 8,
                      itemBuilder: (_, __) => const MovieListTileSkeleton(),
                    )
                  : data.watchlistState == RequestState.Loaded
                      ? ListView.builder(
                          itemBuilder: (context, index) {
                            final movie = data.watchlistMovies[index];
                            return MovieCard(movie);
                          },
                          itemCount: data.watchlistMovies.length,
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

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
