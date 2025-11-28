import 'package:ditonton_tv/features/tv/data/models/tv_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('TvModel.toJson covers json mapping', () {
    const model = TvModel(
        id: 3, name: 'N', overview: 'O', posterPath: '/p', voteAverage: 6.5);
    final json = model.toJson();
    expect(json['id'], 3);
    expect(json['name'], 'N');
    expect(json['poster_path'], '/p');
  });
}
