import 'package:ditonton_tv/features/tv/presentation/cubit/search_recent_cubit.dart';
import 'package:ditonton_tv/features/tv/presentation/cubit/search_recent_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late TvSearchRecentCubit cubit;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    when(
      () => mockSharedPreferences.getStringList('recent_searches_tv'),
    ).thenReturn([]);
    cubit = TvSearchRecentCubit(mockSharedPreferences);
  });

  tearDown(() {
    cubit.close();
  });

  group('TvSearchRecentCubit', () {
    test('initial state loads from SharedPreferences', () async {
      await Future.delayed(Duration.zero); // Allow init to complete
      expect(cubit.state, isA<TvSearchRecentLoaded>());
      expect((cubit.state as TvSearchRecentLoaded).searches, isEmpty);
    });

    test('loads recent searches from SharedPreferences on init', () async {
      when(
        () => mockSharedPreferences.getStringList('recent_searches_tv'),
      ).thenReturn(['tv1', 'tv2']);

      final cubit2 = TvSearchRecentCubit(mockSharedPreferences);
      await Future.delayed(Duration.zero); // Allow init to complete

      expect(cubit2.state, isA<TvSearchRecentLoaded>());
      expect((cubit2.state as TvSearchRecentLoaded).searches, ['tv1', 'tv2']);

      cubit2.close();
    });

    test(
      'addRecent adds search to list and saves to SharedPreferences',
      () async {
        when(
          () => mockSharedPreferences.setStringList(any(), any()),
        ).thenAnswer((_) async => true);

        await Future.delayed(Duration.zero); // Wait for init
        await cubit.addRecent('test tv');

        expect(cubit.state, isA<TvSearchRecentLoaded>());
        final state = cubit.state as TvSearchRecentLoaded;
        expect(state.searches, ['test tv']);

        verify(
          () => mockSharedPreferences.setStringList('recent_searches_tv', [
            'test tv',
          ]),
        ).called(1);
      },
    );

    test('addRecent removes duplicates (case-insensitive)', () async {
      when(
        () => mockSharedPreferences.setStringList(any(), any()),
      ).thenAnswer((_) async => true);

      await Future.delayed(Duration.zero);
      await cubit.addRecent('Show');
      await cubit.addRecent('show');

      final state = cubit.state as TvSearchRecentLoaded;
      expect(state.searches, [
        'show',
      ]); // Only one entry, case-insensitive duplicate removed
    });

    test('addRecent limits to 8 items', () async {
      when(
        () => mockSharedPreferences.setStringList(any(), any()),
      ).thenAnswer((_) async => true);

      await Future.delayed(Duration.zero);

      // Add 10 items
      for (int i = 0; i < 10; i++) {
        await cubit.addRecent('tv$i');
      }

      final state = cubit.state as TvSearchRecentLoaded;
      expect(state.searches.length, 8);
      // Most recent should be first
      expect(state.searches.first, 'tv9');
    });

    test('addRecent inserts new searches at beginning', () async {
      when(
        () => mockSharedPreferences.setStringList(any(), any()),
      ).thenAnswer((_) async => true);

      await Future.delayed(Duration.zero);
      await cubit.addRecent('first');
      await cubit.addRecent('second');
      await cubit.addRecent('third');

      final state = cubit.state as TvSearchRecentLoaded;
      expect(state.searches, ['third', 'second', 'first']);
    });

    test(
      'clearRecent removes all searches and clears SharedPreferences',
      () async {
        when(
          () => mockSharedPreferences.setStringList(any(), any()),
        ).thenAnswer((_) async => true);
        when(
          () => mockSharedPreferences.remove('recent_searches_tv'),
        ).thenAnswer((_) async => true);

        await Future.delayed(Duration.zero);
        await cubit.addRecent('test');
        await cubit.clearRecent();

        expect(cubit.state, isA<TvSearchRecentLoaded>());
        final state = cubit.state as TvSearchRecentLoaded;
        expect(state.searches, isEmpty);

        verify(
          () => mockSharedPreferences.remove('recent_searches_tv'),
        ).called(1);
      },
    );
  });

  group('TvSearchRecentState', () {
    test('TvSearchRecentInitial props are empty', () {
      const state = TvSearchRecentInitial();
      expect(state.props, isEmpty);
    });

    test('TvSearchRecentLoaded props contain searches', () {
      const state = TvSearchRecentLoaded(['tv1', 'tv2']);
      expect(state.props, [
        ['tv1', 'tv2'],
      ]);
    });

    test('TvSearchRecentLoaded equality works correctly', () {
      const state1 = TvSearchRecentLoaded(['tv1']);
      const state2 = TvSearchRecentLoaded(['tv1']);
      const state3 = TvSearchRecentLoaded(['tv2']);

      expect(state1, state2);
      expect(state1, isNot(state3));
    });
  });
}
