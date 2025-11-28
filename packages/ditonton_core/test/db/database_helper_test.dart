import 'dart:io';

import 'package:ditonton_core/core/db/database_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  group('DatabaseHelper', () {
    late DatabaseHelper helper;
    late String dbPath;

    setUp(() async {
      helper = DatabaseHelper();
      final base = await getDatabasesPath();
      dbPath = '$base/ditonton.db';
      // Clean up any existing db to isolate tests
      if (await File(dbPath).exists()) {
        await deleteDatabase(dbPath);
      }
    });

    tearDown(() async {
      await helper.close();
      if (await File(dbPath).exists()) {
        await deleteDatabase(dbPath);
      }
    });

    test('creates database and movie/tv tables, and CRUD works', () async {
      // Trigger creation (version 2)
      final db = await helper.database;
      expect(db, isNotNull);

      // Movies CRUD
      final movieRow = {
        'id': 7,
        'title': 'M',
        'overview': 'O',
        'posterPath': '/p',
      };
      expect(await helper.insertWatchlist(movieRow), isA<int>());
      final gotMovie = await helper.getMovieById(7);
      expect(gotMovie?['title'], 'M');
      final allMovies = await helper.getWatchlistMovies();
      expect(allMovies.length, 1);
      expect(await helper.removeWatchlist(7), 1);

      // TV CRUD
      final tvRow = {
        'id': 17,
        'name': 'T',
        'overview': 'O',
        'posterPath': '/p',
      };
      expect(await helper.insertWatchlistTv(tvRow), isA<int>());
      final gotTv = await helper.getTvById(17);
      expect(gotTv?['name'], 'T');
      final allTvs = await helper.getWatchlistTvs();
      expect(allTvs.length, 1);
      expect(await helper.removeWatchlistTv(17), 1);
    });

    test('onUpgrade does not throw when migrating v1 -> v2', () async {
      // Simulate existing v1 db (only movie table)
      final base = await getDatabasesPath();
      final path = '$base/ditonton.db';
      await deleteDatabase(path);
      final dbV1 =
          await openDatabase(path, version: 1, onCreate: (db, v) async {
        await db.execute('''
          CREATE TABLE  watchlist (
            id INTEGER PRIMARY KEY,
            title TEXT,
            overview TEXT,
            posterPath TEXT
          );
        ''');
      });
      await dbV1.close();
      // Now open via helper (v2) -> should run onUpgrade
      await helper.database;
      // If no exception thrown, migration path is OK.
      expect(true, true);
    });
  });
}
