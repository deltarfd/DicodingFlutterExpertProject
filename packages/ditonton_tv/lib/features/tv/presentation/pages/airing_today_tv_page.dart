import 'package:ditonton_core/core/core.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/airing_today_tv_bloc.dart';
import 'package:ditonton_tv/features/tv/presentation/widgets/tv_card_list.dart';
// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AiringTodayTvPage extends StatefulWidget {
  // ignore: constant_identifier_names
  static const ROUTE_NAME = '/airing-today-tv';

  const AiringTodayTvPage({super.key});

  @override
  State<AiringTodayTvPage> createState() => _AiringTodayTvPageState();
}

class _AiringTodayTvPageState extends State<AiringTodayTvPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<AiringTodayTvBloc>().add(FetchAiringTodayTv()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Airing Today TV Series')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<AiringTodayTvBloc, AiringTodayTvState>(
          builder: (context, state) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: state is AiringTodayTvLoading
                  ? ListView.builder(
                      itemCount: 8,
                      itemBuilder: (_, __) => const TvListTileSkeleton(),
                    )
                  : state is AiringTodayTvLoaded
                      ? ListView.builder(
                          itemBuilder: (context, index) {
                            final tv = state.tvs[index];
                            return TvCardList(tv);
                          },
                          itemCount: state.tvs.length,
                        )
                      : state is AiringTodayTvError
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
