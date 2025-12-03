import 'dart:async';

import 'package:ditonton_core/core/core.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/tv_search_bloc.dart';
import 'package:ditonton_tv/features/tv/presentation/cubit/search_recent_cubit.dart';
import 'package:ditonton_tv/features/tv/presentation/cubit/search_recent_state.dart';
import 'package:ditonton_tv/features/tv/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TvSearchPage extends StatefulWidget {
  // ignore: constant_identifier_names
  static const ROUTE_NAME = '/search-tv';

  const TvSearchPage({super.key});

  @override
  State<TvSearchPage> createState() => _TvSearchPageState();
}

class _TvSearchPageState extends State<TvSearchPage> {
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
    final bloc = context.read<TvSearchBloc>();
    final wait = bloc.stream.firstWhere((s) => s is! TvSearchLoading);
    bloc.add(SubmitTvQuery(q));
    await wait;
  }

  void _onChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(_delay, () {
      final q = _controller.text.trim();
      if (q.length >= 2) {
        _lastQuery = q;
        context.read<TvSearchRecentCubit>().addRecent(q);
        context.read<TvSearchBloc>().add(SubmitTvQuery(q));
      } else {
        context.read<TvSearchBloc>().add(const ClearTvQuery());
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
      appBar: AppBar(title: const Text('Search TV Series')),
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
                      context.read<TvSearchRecentCubit>().addRecent(q);
                      context.read<TvSearchBloc>().add(SubmitTvQuery(q));
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Search title',
                    prefixIcon: const Icon(Icons.search),
                    border: const OutlineInputBorder(),
                    suffixIcon: value.text.isNotEmpty
                        ? IconButton(
                            tooltip: 'Clear',
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              _debounce?.cancel();
                              _controller.clear();
                              _lastQuery = null;
                              context
                                  .read<TvSearchBloc>()
                                  .add(const ClearTvQuery());
                            },
                          )
                        : null,
                  ),
                  textInputAction: TextInputAction.search,
                );
              },
            ),
            const SizedBox(height: 16),
            BlocBuilder<TvSearchRecentCubit, TvSearchRecentState>(
              builder: (context, state) {
                if (state is TvSearchRecentLoaded &&
                    state.searches.isNotEmpty) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Recent'),
                          TextButton.icon(
                            onPressed: () => context
                                .read<TvSearchRecentCubit>()
                                .clearRecent(),
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
                                        .read<TvSearchBloc>()
                                        .add(SubmitTvQuery(q));
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
            BlocBuilder<TvSearchBloc, TvSearchState>(
              builder: (context, state) {
                return Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: () {
                      if (state is TvSearchLoading) {
                        return ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: 8,
                          itemBuilder: (_, __) => const TvListTileSkeleton(),
                        );
                      } else if (state is TvSearchLoaded) {
                        if (state.tvs.isEmpty) {
                          return const Center(child: Text('No results found'));
                        }
                        return RefreshIndicator(
                          onRefresh: _refresh,
                          child: ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemBuilder: (context, index) =>
                                TvCardList(state.tvs[index]),
                            itemCount: state.tvs.length,
                          ),
                        );
                      } else if (state is TvSearchError) {
                        return Center(child: Text(state.message));
                      } else {
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
