import 'package:ditonton_core/core/db/database_helper.dart';
import 'package:ditonton_tv/features/tv/data/datasources/tv_local_data_source.dart';
import 'package:ditonton_tv/features/tv/data/models/tv_table.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeDbHelper implements DatabaseHelper {
  final Map<int, Map<String, dynamic>> _store = {};
  @override
  Future<int> insertWatchlistTv(Map<String, dynamic> tvMap) async {
    _store[tvMap['id'] as int] = tvMap;
    return 1;
  }

  @override
  Future<int> removeWatchlistTv(int id) async {
    _store.remove(id);
    return 1;
  }

  @override
  Future<Map<String, dynamic>?> getTvById(int id) async => _store[id];
  @override
  Future<List<Map<String, dynamic>>> getWatchlistTvs() async =>
      _store.values.toList();
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late _FakeDbHelper db;
  late TvLocalDataSourceImpl ds;

  setUp(() {
    db = _FakeDbHelper();
    ds = TvLocalDataSourceImpl(databaseHelper: db);
  });

  test('insertWatchlist returns success message', () async {
    const tv = TvTable(id: 1, name: 'N', overview: 'O', posterPath: '/p');
    final result = await ds.insertWatchlist(tv);
    expect(result, 'Added to Watchlist');
  });

  test('getTvById returns TvTable when exists', () async {
    await db.insertWatchlistTv(
        {'id': 1, 'name': 'N', 'overview': 'O', 'posterPath': '/p'});
    final result = await ds.getTvById(1);
    expect(result, isA<TvTable>());
    expect(result?.id, 1);
  });

  test('getWatchlistTv returns list and removeWatchlist works', () async {
    const tv = TvTable(id: 2, name: 'X', overview: 'OX', posterPath: '/x');
    await ds.insertWatchlist(tv);
    final list = await ds.getWatchlistTv();
    expect(list.any((e) => e.id == 2), true);
    final msg = await ds.removeWatchlist(tv);
    expect(msg, 'Removed from Watchlist');
  });
}
