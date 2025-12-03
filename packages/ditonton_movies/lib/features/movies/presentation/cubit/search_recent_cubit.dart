import 'package:ditonton_movies/features/movies/presentation/cubit/search_recent_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchRecentCubit extends Cubit<SearchRecentState> {
  final SharedPreferences sharedPreferences;
  static const String _key = 'recent_searches_movies';
  static const int _maxRecent = 8;

  SearchRecentCubit(this.sharedPreferences)
      : super(const SearchRecentInitial()) {
    _loadRecent();
  }

  Future<void> _loadRecent() async {
    final list = sharedPreferences.getStringList(_key) ?? [];
    emit(SearchRecentLoaded(list));
  }

  Future<void> addRecent(String query) async {
    final current = state is SearchRecentLoaded
        ? List<String>.from((state as SearchRecentLoaded).searches)
        : <String>[];

    // Remove duplicate (case-insensitive)
    current.removeWhere((e) => e.toLowerCase() == query.toLowerCase());

    // Add to beginning
    current.insert(0, query);

    // Limit to max items
    if (current.length > _maxRecent) {
      current.removeLast();
    }

    // Save and emit
    await sharedPreferences.setStringList(_key, current);
    emit(SearchRecentLoaded(current));
  }

  Future<void> clearRecent() async {
    await sharedPreferences.remove(_key);
    emit(const SearchRecentLoaded([]));
  }
}
