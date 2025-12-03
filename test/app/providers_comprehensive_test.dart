import 'package:ditonton/app/providers.dart';
import 'package:ditonton/injection.dart' as di;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() async {
    await di.locator.reset();
    di.init();
  });

  group('AppProviders', () {
    test('getBlocProviders returns list of BLoC providers', () {
      final providers = AppProviders.getBlocProviders();

      expect(providers, isA<List<BlocProvider>>());
      expect(providers.isNotEmpty, true);
      // 2 app-level (ShellCubit, ThemeModeCubit) + 7 movie (including SearchRecentCubit) + 8 TV (including TvSearchRecentCubit) blocs = 17 total
      expect(providers.length, 17);
    });

    test('AppProviders class can be instantiated', () {
      final appProviders = AppProviders();
      expect(appProviders, isA<AppProviders>());
    });
  });
}
