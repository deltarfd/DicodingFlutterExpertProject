import 'package:ditonton_core/core/core.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/on_the_air_tv_bloc.dart';
import 'package:ditonton_tv/features/tv/presentation/widgets/tv_card_list.dart';
// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnTheAirTvPage extends StatefulWidget {
  // ignore: constant_identifier_names
  static const routeName = '/on-the-air-tv';

  const OnTheAirTvPage({super.key});

  @override
  State<OnTheAirTvPage> createState() => _OnTheAirTvPageState();
}

class _OnTheAirTvPageState extends State<OnTheAirTvPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<OnTheAirTvBloc>().add(FetchOnTheAirTv()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('On The Air TV Series')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<OnTheAirTvBloc, OnTheAirTvState>(
          builder: (context, state) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: state is OnTheAirTvLoading
                  ? ListView.builder(
                      itemCount: 8,
                      itemBuilder: (_, __) => const TvListTileSkeleton(),
                    )
                  : state is OnTheAirTvLoaded
                      ? ListView.builder(
                          itemBuilder: (context, index) {
                            final tv = state.tvs[index];
                            return TvCardList(tv);
                          },
                          itemCount: state.tvs.length,
                        )
                      : state is OnTheAirTvError
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
