import 'package:ditonton_movies/features/movies/presentation/cubit/search_recent_cubit.dart';
import 'package:ditonton_movies/features/movies/presentation/cubit/search_recent_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late SearchRecentCubit cubit;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    when(() => mockSharedPreferences.getStringList('recent_searches_movies'))
        .thenReturn([]);
    cubit = SearchRecentCubit(mockSharedPreferences);
  });

  tearDown(() {
    cubit.close();
  });

  group('SearchRecentCubit', () {
    test('initial state loads from SharedPreferences', () async {
      await Future.delayed(Duration.zero); // Allow init to complete
      expect(cubit.state, isA<SearchRecentLoaded>());
      expect((cubit.state as SearchRecentLoaded).searches, isEmpty);
    });

    test('loads recent searches from SharedPreferences on init', () async {
      when(() => mockSharedPreferences.getStringList('recent_searches_movies'))
          .thenReturn(['movie1', 'movie2']);

      final cubit2 = SearchRecentCubit(mockSharedPreferences);
      await Future.delayed(Duration.zero); // Allow init to complete

      expect(cubit2.state, isA<SearchRecentLoaded>());
      expect(
          (cubit2.state as SearchRecentLoaded).searches, ['movie1', 'movie2']);

      cubit2.close();
    });

    test('addRecent adds search to list and saves to SharedPreferences',
        () async {
      when(() => mockSharedPreferences.setStringList(any(), any()))
          .thenAnswer((_) async => true);

      await Future.delayed(Duration.zero); // Wait for init
      await cubit.addRecent('test movie');

      expect(cubit.state, isA<SearchRecentLoaded>());
      final state = cubit.state as SearchRecentLoaded;
      expect(state.searches, ['test movie']);

      verify(() => mockSharedPreferences.setStringList(
            'recent_searches_movies',
            ['test movie'],
          )).called(1);
    });

    test('addRecent removes duplicates (case-insensitive)', () async {
      when(() => mockSharedPreferences.setStringList(any(), any()))
          .thenAnswer((_) async => true);

      await Future.delayed(Duration.zero);
      await cubit.addRecent('Movie');
      await cubit.addRecent('movie');

      final state = cubit.state as SearchRecentLoaded;
      expect(state.searches,
          ['movie']); // Only one entry, case-insensitive duplicate removed
    });

    test('addRecent limits to 8 items', () async {
      when(() => mockSharedPreferences.setStringList(any(), any()))
          .thenAnswer((_) async => true);

      await Future.delayed(Duration.zero);

      // Add 10 items
      for (int i = 0; i < 10; i++) {
        await cubit.addRecent('movie$i');
      }

      final state = cubit.state as SearchRecentLoaded;
      expect(state.searches.length, 8);
      // Most recent should be first
      expect(state.searches.first, 'movie9');
    });

    test('addRecent inserts new searches at beginning', () async {
      when(() => mockSharedPreferences.setStringList(any(), any()))
          .thenAnswer((_) async => true);

      await Future.delayed(Duration.zero);
      await cubit.addRecent('first');
      await cubit.addRecent('second');
      await cubit.addRecent('third');

      final state = cubit.state as SearchRecentLoaded;
      expect(state.searches, ['third', 'second', 'first']);
    });

    test('clearRecent removes all searches and clears SharedPreferences',
        () async {
      when(() => mockSharedPreferences.setStringList(any(), any()))
          .thenAnswer((_) async => true);
      when(() => mockSharedPreferences.remove('recent_searches_movies'))
          .thenAnswer((_) async => true);

      await Future.delayed(Duration.zero);
      await cubit.addRecent('test');
      await cubit.clearRecent();

      expect(cubit.state, isA<SearchRecentLoaded>());
      final state = cubit.state as SearchRecentLoaded;
      expect(state.searches, isEmpty);

      verify(() => mockSharedPreferences.remove('recent_searches_movies'))
          .called(1);
    });
  });

  group('SearchRecentState', () {
    test('SearchRecentInitial props are empty', () {
      const state = SearchRecentInitial();
      expect(state.props, isEmpty);
    });

    test('SearchRecentLoaded props contain searches', () {
      const state = SearchRecentLoaded(['movie1', 'movie2']);
      expect(state.props, [
        ['movie1', 'movie2']
      ]);
    });

    test('SearchRecentLoaded equality works correctly', () {
      const state1 = SearchRecentLoaded(['movie1']);
      const state2 = SearchRecentLoaded(['movie1']);
      const state3 = SearchRecentLoaded(['movie2']);

      expect(state1, state2);
      expect(state1, isNot(state3));
    });
  });
}
