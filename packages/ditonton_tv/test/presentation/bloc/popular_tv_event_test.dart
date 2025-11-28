import 'package:ditonton_tv/features/tv/presentation/bloc/popular_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PopularTvEvent', () {
    group('FetchPopularTv', () {
      test('supports value equality', () {
        expect(FetchPopularTv(), equals(FetchPopularTv()));
      });

      test('props are correct', () {
        final event = FetchPopularTv();
        expect(event.props, equals([]));
      });
    });
  });
}
