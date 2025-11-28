import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton_tv/features/tv/data/models/tv_table.dart';
import 'package:ditonton_tv/features/tv/domain/entities/tv_detail.dart';

void main() {
  test('TvTable mapping and equality', () {
    final detail = TvDetail(
      id: 2,
      name: 'N',
      overview: 'O',
      posterPath: null,
      voteAverage: 0,
      genres: const [],
      seasons: const [],
    );
    final table = TvTable.fromEntity(detail);
    final map = table.toJson();
    expect(map['name'], 'N');

    final fromMap = TvTable.fromMap(map);
    expect(fromMap, table); // equatable props hit

    final entity = fromMap.toEntity();
    expect(entity.name, 'N');
    expect(entity.voteAverage, 0);
  });
}
