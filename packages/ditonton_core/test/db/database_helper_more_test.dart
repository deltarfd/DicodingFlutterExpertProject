import 'dart:io';

import 'package:ditonton_core/core/db/database_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  test('DatabaseHelper returns null for non-existent ids', () async {
    final helper = DatabaseHelper.test();
    helper.databaseName = 'ditonton_more_test.db';
    final base = await getDatabasesPath();
    final path = '$base/${helper.databaseName}';
    if (await File(path).exists()) {
      await deleteDatabase(path);
    }
    await helper.database; // init

    expect(await helper.getMovieById(99999), isNull);
    expect(await helper.getTvById(99999), isNull);

    final allMovies = await helper.getWatchlistMovies();
    final allTvs = await helper.getWatchlistTvs();
    expect(allMovies, isA<List<Map<String, dynamic>>>());
    expect(allTvs, isA<List<Map<String, dynamic>>>());

    await helper.close();
    if (await File(path).exists()) {
      await deleteDatabase(path);
    }
  });
}
