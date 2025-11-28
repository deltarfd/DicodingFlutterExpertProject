import 'package:ditonton_core/core/core.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/top_rated_tv_bloc.dart';
import 'package:ditonton_tv/features/tv/presentation/widgets/tv_card_list.dart';
// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopRatedTvPage extends StatefulWidget {
  // ignore: constant_identifier_names
  static const ROUTE_NAME = '/top-rated-tv';

  const TopRatedTvPage({super.key});

  @override
  State<TopRatedTvPage> createState() => _TopRatedTvPageState();
}

class _TopRatedTvPageState extends State<TopRatedTvPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<TopRatedTvBloc>().add(FetchTopRatedTv()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Top Rated TV Series')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TopRatedTvBloc, TopRatedTvState>(
          builder: (context, state) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: state is TopRatedTvLoading
                  ? ListView.builder(
                      itemCount: 8,
                      itemBuilder: (_, __) => const TvListTileSkeleton(),
                    )
                  : state is TopRatedTvLoaded
                      ? ListView.builder(
                          itemBuilder: (context, index) {
                            final tv = state.tvs[index];
                            return TvCardList(tv);
                          },
                          itemCount: state.tvs.length,
                        )
                      : state is TopRatedTvError
                          ? Center(
                              key: const Key('error_message'),
                              child: Text(state.message))
                          : const SizedBox(),
            );
          },
        ),
      ),
    );
  }
}
