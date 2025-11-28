import 'package:ditonton/app/providers.dart';
import 'package:ditonton/app/routes.dart';
import 'package:ditonton/app/shell.dart';
import 'package:ditonton/app/theme.dart';
import 'package:ditonton/app/theme_mode_notifier.dart';
import 'package:ditonton_core/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: AppProviders.getChangeNotifierProviders(),
      child: MultiBlocProvider(
        providers: AppProviders.getBlocProviders(),
        child: Consumer<ThemeModeNotifier>(
          builder: (context, theme, _) {
            return MaterialApp(
              title: 'Ditonton',
              theme: AppTheme.light(),
              darkTheme: AppTheme.dark(),
              themeMode: theme.themeMode,
              home: const AppShell(),
              navigatorObservers: [routeObserver],
              onGenerateRoute: AppRoutes.onGenerateRoute,
            );
          },
        ),
      ),
    );
  }
}
