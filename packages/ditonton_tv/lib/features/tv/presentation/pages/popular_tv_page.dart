import 'package:ditonton_core/core/core.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/popular_tv_bloc.dart';
import 'package:ditonton_tv/features/tv/presentation/widgets/tv_card_list.dart';
// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularTvPage extends StatefulWidget {
  // ignore: constant_identifier_names
  static const routeName = '/popular-tv';

  const PopularTvPage({super.key});

  @override
  State<PopularTvPage> createState() => _PopularTvPageState();
}

class _PopularTvPageState extends State<PopularTvPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<PopularTvBloc>().add(FetchPopularTv()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Popular TV Series')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PopularTvBloc, PopularTvState>(
          builder: (context, state) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: state is PopularTvLoading
                  ? ListView.builder(
                      itemCount: 8,
                      itemBuilder: (_, __) => const TvListTileSkeleton(),
                    )
                  : state is PopularTvLoaded
                      ? ListView.builder(
                          itemBuilder: (context, index) {
                            final tv = state.tvs[index];
                            return TvCardList(tv);
                          },
                          itemCount: state.tvs.length,
                        )
                      : state is PopularTvError
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
