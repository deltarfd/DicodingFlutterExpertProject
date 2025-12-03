import 'package:ditonton_tv/features/tv/presentation/cubit/search_recent_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TvSearchRecentCubit extends Cubit<TvSearchRecentState> {
  final SharedPreferences sharedPreferences;
  static const String _key = 'recent_searches_tv';
  static const int _maxRecent = 8;

  TvSearchRecentCubit(this.sharedPreferences)
      : super(const TvSearchRecentInitial()) {
    _loadRecent();
  }

  Future<void> _loadRecent() async {
    final list = sharedPreferences.getStringList(_key) ?? [];
    emit(TvSearchRecentLoaded(list));
  }

  Future<void> addRecent(String query) async {
    final current = state is TvSearchRecentLoaded
        ? List<String>.from((state as TvSearchRecentLoaded).searches)
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
    emit(TvSearchRecentLoaded(current));
  }

  Future<void> clearRecent() async {
    await sharedPreferences.remove(_key);
    emit(const TvSearchRecentLoaded([]));
  }
}
