import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton_tv/features/tv/data/models/genre_model.dart';
import 'package:ditonton_core/domain/entities/genre.dart';

void main() {
  test('GenreModel fromJson/toJson/toEntity', () {
    final m = GenreModel.fromJson({'id': 3, 'name': null});
    expect(m.id, 3);
    expect(m.name, '');
    expect(m.toJson(), {'id': 3, 'name': ''});
    expect(m.toEntity(), const Genre(id: 3, name: ''));
  });

  test('GenreModel props are correct', () {
    const model = GenreModel(id: 1, name: 'Drama');
    expect(model.props, [1, 'Drama']);
  });
}
