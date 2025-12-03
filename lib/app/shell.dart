import 'package:ditonton/app/shell_cubit.dart';
import 'package:ditonton/app/theme_mode_cubit.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton_movies/features/movies/presentation/pages/home_movie_page.dart';
import 'package:ditonton_tv/features/tv/presentation/pages/home_tv_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key});

  static const _pages = [
    HomeMoviePage(),
    HomeTvPage(),
    AboutPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShellCubit, int>(
      builder: (context, currentIndex) {
        return Scaffold(
          body: IndexedStack(
            index: currentIndex,
            children: _pages,
          ),
          floatingActionButton: FloatingActionButton.small(
            tooltip: 'Toggle light/dark',
            onPressed: () => context.read<ThemeModeCubit>().toggle(),
            child: const Icon(Icons.brightness_6),
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: currentIndex,
            destinations: const [
              NavigationDestination(
                  icon: Icon(Icons.movie_outlined),
                  selectedIcon: Icon(Icons.movie),
                  label: 'Movies'),
              NavigationDestination(
                  icon: Icon(Icons.tv_outlined),
                  selectedIcon: Icon(Icons.tv),
                  label: 'TV'),
              NavigationDestination(
                  icon: Icon(Icons.info_outline),
                  selectedIcon: Icon(Icons.info),
                  label: 'About'),
            ],
            onDestinationSelected: (index) =>
                context.read<ShellCubit>().setIndex(index),
          ),
        );
      },
    );
  }
}
