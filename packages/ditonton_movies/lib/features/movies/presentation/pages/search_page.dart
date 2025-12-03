import 'dart:async';

import 'package:ditonton_core/core/core.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/movie_search_bloc.dart';
import 'package:ditonton_movies/features/movies/presentation/cubit/search_recent_cubit.dart';
import 'package:ditonton_movies/features/movies/presentation/cubit/search_recent_state.dart';
import 'package:ditonton_movies/features/movies/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatefulWidget {
  static const ROUTE_NAME = '/search';

  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _controller = TextEditingController();
  Timer? _debounce;
  static const _delay = Duration(milliseconds: 400);
  String? _lastQuery;

  @override
  void initState() {
    super.initState();
    // The cubit will auto-load recent searches on init
  }

  Future<void> _refresh() async {
    final q = _lastQuery;
    if (q == null || q.isEmpty) return;
    final bloc = context.read<MovieSearchBloc>();
    final wait = bloc.stream.firstWhere((s) => s is! MovieSearchLoading);
    bloc.add(SubmitMovieQuery(q));
    await wait;
  }

  void _onChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(_delay, () {
      final q = _controller.text.trim();
      if (q.length >= 2) {
        _lastQuery = q;
        context.read<SearchRecentCubit>().addRecent(q);
        context.read<MovieSearchBloc>().add(SubmitMovieQuery(q));
      } else {
        context.read<MovieSearchBloc>().add(const ClearMovieQuery());
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Movies')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: _controller,
              builder: (context, value, child) {
                return TextField(
                  controller: _controller,
                  onChanged: _onChanged,
                  onSubmitted: (query) {
                    final q = query.trim();
                    if (q.isNotEmpty) {
                      _lastQuery = q;
                      context.read<SearchRecentCubit>().addRecent(q);
                      context.read<MovieSearchBloc>().add(SubmitMovieQuery(q));
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Search title',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: value.text.isNotEmpty
                        ? IconButton(
                            tooltip: 'Clear',
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              _debounce?.cancel();
                              _controller.clear();
                              _lastQuery = null;
                              context
                                  .read<MovieSearchBloc>()
                                  .add(const ClearMovieQuery());
                            },
                          )
                        : null,
                  ),
                  textInputAction: TextInputAction.search,
                );
              },
            ),
            const SizedBox(height: 16),
            BlocBuilder<SearchRecentCubit, SearchRecentState>(
              builder: (context, state) {
                if (state is SearchRecentLoaded && state.searches.isNotEmpty) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Recent'),
                          TextButton.icon(
                            onPressed: () =>
                                context.read<SearchRecentCubit>().clearRecent(),
                            icon: const Icon(Icons.clear_all),
                            label: const Text('Clear'),
                          ),
                        ],
                      ),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: state.searches
                            .map((q) => ActionChip(
                                  label: Text(q),
                                  onPressed: () {
                                    _controller.text = q;
                                    _controller.selection =
                                        TextSelection.fromPosition(
                                            TextPosition(offset: q.length));
                                    _lastQuery = q;
                                    context
                                        .read<MovieSearchBloc>()
                                        .add(SubmitMovieQuery(q));
                                  },
                                ))
                            .toList(),
                      ),
                      const SizedBox(height: 12),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            Text('Search Result', style: kHeading6),
            BlocBuilder<MovieSearchBloc, MovieSearchState>(
              builder: (context, state) {
                return Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: () {
                      if (state is MovieSearchLoading) {
                        return ListView.builder(
                          itemCount: 8,
                          itemBuilder: (_, __) => const MovieListTileSkeleton(),
                        );
                      } else if (state is MovieSearchLoaded) {
                        if (state.movies.isEmpty) {
                          return const Center(child: Text('No results found'));
                        }
                        return RefreshIndicator(
                          onRefresh: _refresh,
                          child: ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemBuilder: (context, index) =>
                                MovieCard(state.movies[index]),
                            itemCount: state.movies.length,
                          ),
                        );
                      } else if (state is MovieSearchError) {
                        return Center(child: Text(state.message));
                      } else {
                        // Initial state hint
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.search, size: 48),
                                SizedBox(height: 12),
                                Text('Type at least 2 characters to search')
                              ],
                            ),
                          ),
                        );
                      }
                    }(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
