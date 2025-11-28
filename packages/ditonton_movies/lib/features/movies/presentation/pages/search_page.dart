import 'dart:async';

import 'package:ditonton_core/core/core.dart';
import 'package:ditonton_movies/features/movies/presentation/bloc/movie_search_bloc.dart';
import 'package:ditonton_movies/features/movies/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final List<String> _recent = [];
  String? _lastQuery;

  Future<void> _loadRecent() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('recent_searches_movies') ?? [];
    setState(() => _recent
      ..clear()
      ..addAll(list));
  }

  Future<void> _saveRecent() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('recent_searches_movies', _recent);
  }

  Future<void> _clearRecent() async {
    setState(_recent.clear);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('recent_searches_movies');
  }

  void _addRecent(String q) {
    setState(() {
      _recent.removeWhere((e) => e.toLowerCase() == q.toLowerCase());
      _recent.insert(0, q);
      if (_recent.length > 8) _recent.removeLast();
    });
    _saveRecent();
  }

  @override
  void initState() {
    super.initState();
    _loadRecent();
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
        _addRecent(q);
        context.read<MovieSearchBloc>().add(SubmitMovieQuery(q));
      } else {
        context.read<MovieSearchBloc>().add(const ClearMovieQuery());
      }
      setState(() {});
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
            TextField(
              controller: _controller,
              onChanged: _onChanged,
              onSubmitted: (query) {
                final q = query.trim();
                if (q.isNotEmpty) {
                  _lastQuery = q;
                  _addRecent(q);
                  context.read<MovieSearchBloc>().add(SubmitMovieQuery(q));
                }
              },
              decoration: InputDecoration(
                hintText: 'Search title',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _controller.text.isNotEmpty
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
                          setState(() {});
                        },
                      )
                    : null,
              ),
              textInputAction: TextInputAction.search,
            ),
            const SizedBox(height: 16),
            if (_recent.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Recent'),
                  TextButton.icon(
                    onPressed: _clearRecent,
                    icon: const Icon(Icons.clear_all),
                    label: const Text('Clear'),
                  ),
                ],
              ),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: _recent
                    .map((q) => ActionChip(
                          label: Text(q),
                          onPressed: () {
                            _controller.text = q;
                            _controller.selection = TextSelection.fromPosition(
                                TextPosition(offset: q.length));
                            _lastQuery = q;
                            context
                                .read<MovieSearchBloc>()
                                .add(SubmitMovieQuery(q));
                            setState(() {});
                          },
                        ))
                    .toList(),
              ),
              const SizedBox(height: 12),
            ],
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
