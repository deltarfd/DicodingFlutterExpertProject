import 'package:ditonton_movies/features/movies/presentation/bloc/top_rated_movies_bloc.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/top_rated_movies_event.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/top_rated_movies_state.dart';
import 'package:ditonton_movies/features/movies/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore_for_file: use_build_context_synchronously

class TopRatedMoviesPage extends StatefulWidget {
  // ignore: constant_identifier_names
  static const ROUTE_NAME = '/top-rated-movie';

  const TopRatedMoviesPage({super.key});

  @override
  State<TopRatedMoviesPage> createState() => _TopRatedMoviesPageState();
}

class _TopRatedMoviesPageState extends State<TopRatedMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<TopRatedMoviesBloc>().add(FetchTopRatedMovies()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Rated Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TopRatedMoviesBloc, TopRatedMoviesState>(
          builder: (context, state) {
            if (state is TopRatedMoviesLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TopRatedMoviesLoaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = state.movies[index];
                  return MovieCard(movie);
                },
                itemCount: state.movies.length,
              );
            } else if (state is TopRatedMoviesError) {
              return Center(
                key: const Key('error_message'),
                child: Text(state.message),
              );
            } else {
              return const Center(
                child: Text('Failed'),
              );
            }
          },
        ),
      ),
    );
  }
}
