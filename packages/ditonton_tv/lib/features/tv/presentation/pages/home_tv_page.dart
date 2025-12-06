import 'package:ditonton_core/core/core.dart';
import 'package:ditonton_tv/features/tv/domain/entities/tv.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/airing_today_tv_bloc.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/on_the_air_tv_bloc.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/popular_tv_bloc.dart';
import 'package:ditonton_tv/features/tv/presentation/bloc/top_rated_tv_bloc.dart';
import 'package:ditonton_tv/features/tv/presentation/pages/airing_today_tv_page.dart';
import 'package:ditonton_tv/features/tv/presentation/pages/popular_tv_page.dart';
import 'package:ditonton_tv/features/tv/presentation/pages/top_rated_tv_page.dart';
import 'package:ditonton_tv/features/tv/presentation/pages/tv_detail_page.dart';
import 'package:ditonton_tv/features/tv/presentation/pages/tv_search_page.dart';
import 'package:ditonton_tv/features/tv/presentation/pages/watchlist_tv_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore_for_file: use_build_context_synchronously

class HomeTvPage extends StatefulWidget {
  static const routeName = '/home-tv';
  const HomeTvPage({super.key});

  @override
  State<HomeTvPage> createState() => _HomeTvPageState();
}

class _HomeTvPageState extends State<HomeTvPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<OnTheAirTvBloc>().add(FetchOnTheAirTv());
      context.read<AiringTodayTvBloc>().add(FetchAiringTodayTv());
      context.read<PopularTvBloc>().add(FetchPopularTv());
      context.read<TopRatedTvBloc>().add(FetchTopRatedTv());
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('TV Series'),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, WatchlistTvPage.routeName),
            icon: const Icon(Icons.bookmark),
            tooltip: 'Watchlist',
          ),
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, TvSearchPage.routeName),
            icon: const Icon(Icons.search),
            tooltip: 'Search',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('On The Air', style: heading6),
              BlocBuilder<OnTheAirTvBloc, OnTheAirTvState>(
                builder: (context, state) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: state is OnTheAirTvLoading
                        ? const HorizontalPosterSkeletonList(itemCount: 8)
                        : state is OnTheAirTvLoaded
                            ? _TvHList(state.tvs)
                            : state is OnTheAirTvError
                                ? Text(state.message)
                                : const SizedBox(),
                  );
                },
              ),
              _buildSubHeading(
                title: 'Airing Today',
                onTap: () =>
                    Navigator.pushNamed(context, AiringTodayTvPage.routeName),
              ),
              BlocBuilder<AiringTodayTvBloc, AiringTodayTvState>(
                builder: (context, state) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: state is AiringTodayTvLoading
                        ? const HorizontalPosterSkeletonList(itemCount: 8)
                        : state is AiringTodayTvLoaded
                            ? _TvHList(state.tvs)
                            : state is AiringTodayTvError
                                ? Text(state.message)
                                : const SizedBox(),
                  );
                },
              ),
              _buildSubHeading(
                title: 'Popular',
                onTap: () =>
                    Navigator.pushNamed(context, PopularTvPage.routeName),
              ),
              BlocBuilder<PopularTvBloc, PopularTvState>(
                builder: (context, state) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: state is PopularTvLoading
                        ? const HorizontalPosterSkeletonList(itemCount: 8)
                        : state is PopularTvLoaded
                            ? _TvHList(state.tvs)
                            : state is PopularTvError
                                ? Text(state.message)
                                : const SizedBox(),
                  );
                },
              ),
              _buildSubHeading(
                title: 'Top Rated',
                onTap: () =>
                    Navigator.pushNamed(context, TopRatedTvPage.routeName),
              ),
              BlocBuilder<TopRatedTvBloc, TopRatedTvState>(
                builder: (context, state) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: state is TopRatedTvLoading
                        ? const HorizontalPosterSkeletonList(itemCount: 8)
                        : state is TopRatedTvLoaded
                            ? _TvHList(state.tvs)
                            : state is TopRatedTvError
                                ? Text(state.message)
                                : const SizedBox(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: heading6),
        InkWell(
          onTap: onTap,
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
                children: [Text('See More'), Icon(Icons.arrow_forward_ios)]),
          ),
        ),
      ],
    );
  }
}

class _TvHList extends StatelessWidget {
  final List<Tv> tvs;
  const _TvHList(this.tvs);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tvs.length,
        itemBuilder: (context, index) {
          final tv = tvs[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () => Navigator.pushNamed(
                context,
                TvDetailPage.routeName,
                arguments: tv.id,
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: CachedImage(
                  imageUrl: '$BASE_IMAGE_URL${tv.posterPath}',
                  width: 120,
                  height: 180,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
