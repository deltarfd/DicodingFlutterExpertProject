import 'package:ditonton_core/core/db/database_helper.dart';
import 'package:ditonton_core/core/errors/exception.dart';
import 'package:ditonton_tv/features/tv/data/datasources/tv_local_data_source.dart';
import 'package:ditonton_tv/features/tv/data/models/tv_table.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockDb extends Mock implements DatabaseHelper {}

void main() {
  group('TvLocalDataSource error branches', () {
    late _MockDb db;
    late TvLocalDataSourceImpl ds;

    setUp(() {
      db = _MockDb();
      ds = TvLocalDataSourceImpl(databaseHelper: db);
    });

    test('insertWatchlist throws DatabaseException on error', () async {
      when(() => db.insertWatchlistTv(any())).thenThrow(Exception('x'));
      expect(
        () => ds.insertWatchlist(const TvTable(id: 1, name: 'n', overview: 'o', posterPath: null)),
        throwsA(isA<DatabaseException>()),
      );
    });

    test('removeWatchlist throws DatabaseException on error', () async {
      when(() => db.removeWatchlistTv(any())).thenThrow(Exception('x'));
      expect(
        () => ds.removeWatchlist(const TvTable(id: 1, name: 'n', overview: 'o', posterPath: null)),
        throwsA(isA<DatabaseException>()),
      );
    });
  });
}
