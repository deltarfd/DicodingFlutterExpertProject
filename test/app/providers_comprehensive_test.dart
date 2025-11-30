import 'package:ditonton/app/providers.dart';
import 'package:ditonton/injection.dart' as di;
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/single_child_widget.dart';

void main() {
  setUpAll(() async {
    await di.locator.reset();
    di.init();
  });

  group('AppProviders', () {
    test(
      'getChangeNotifierProviders returns list of ChangeNotifier providers',
      () {
        final providers = AppProviders.getChangeNotifierProviders();

        expect(providers, isA<List<SingleChildWidget>>());
        expect(providers.isNotEmpty, true);
        expect(providers.length, 1); // ThemeModeNotifier
      },
    );

    test('getBlocProviders returns list of BLoC providers', () {
      final providers = AppProviders.getBlocProviders();

      expect(providers, isA<List<SingleChildWidget>>());
      expect(providers.isNotEmpty, true);
      expect(providers.length, 13); // 6 movie + 7 TV blocs
    });

    test('getAllProviders combines ChangeNotifier and BLoC providers', () {
      final allProviders = AppProviders.getAllProviders();
      final cnProviders = AppProviders.getChangeNotifierProviders();
      final blocProviders = AppProviders.getBlocProviders();

      expect(allProviders.length, cnProviders.length + blocProviders.length);
      expect(allProviders.length, 14); // 1 CN + 13 BLoC = 14 total
    });

    test('AppProviders class can be instantiated', () {
      final appProviders = AppProviders();
      expect(appProviders, isA<AppProviders>());
    });
  });
}
