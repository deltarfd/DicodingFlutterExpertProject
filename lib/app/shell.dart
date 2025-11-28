import 'package:ditonton/app/theme_mode_notifier.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton_movies/features/movies/presentation/pages/home_movie_page.dart';
import 'package:ditonton_tv/features/tv/presentation/pages/home_tv_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  final _pages = const [
    HomeMoviePage(),
    HomeTvPage(),
    AboutPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      floatingActionButton: FloatingActionButton.small(
        tooltip: 'Toggle light/dark',
        onPressed: () => context.read<ThemeModeNotifier>().toggle(),
        child: const Icon(Icons.brightness_6),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
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
        onDestinationSelected: (i) => setState(() => _index = i),
      ),
    );
  }
}
