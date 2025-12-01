import 'package:ditonton/app/providers.dart';
import 'package:ditonton/app/routes.dart';
import 'package:ditonton/app/shell.dart';
import 'package:ditonton/app/theme.dart';
import 'package:ditonton/app/theme_mode_cubit.dart';
import 'package:ditonton_core/core/utils/utils.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyApp extends StatelessWidget {
  final FirebaseAnalytics? analytics;
  final List<BlocProvider>? providers;

  const MyApp({super.key, this.analytics, this.providers});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: providers ?? AppProviders.getBlocProviders(),
      child: Builder(
        builder: (context) {
          return BlocBuilder<ThemeModeCubit, ThemeModeState>(
            builder: (context, state) {
              return MaterialApp(
                title: 'Ditonton',
                theme: AppTheme.light(),
                darkTheme: AppTheme.dark(),
                themeMode: state.themeMode,
                home: const AppShell(),
                navigatorObservers: [
                  routeObserver,
                  FirebaseAnalyticsObserver(
                    analytics: analytics ?? FirebaseAnalytics.instance,
                  ),
                ],
                onGenerateRoute: AppRoutes.onGenerateRoute,
              );
            },
          );
        },
      ),
    );
  }
}
