import 'package:ditonton_tv/features/tv/presentation/bloc/tv_detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TvDetailEvent', () {
    group('FetchTvDetailEvent', () {
      test('supports value equality', () {
        expect(
          const FetchTvDetailEvent(1),
          equals(const FetchTvDetailEvent(1)),
        );
      });

      test('props are correct', () {
        const event = FetchTvDetailEvent(123);
        expect(event.props, equals([123]));
      });
    });

    group('ToggleWatchlistEvent', () {
      test('supports value equality', () {
        expect(ToggleWatchlistEvent(), equals(ToggleWatchlistEvent()));
      });

      test('props are correct', () {
        final event = ToggleWatchlistEvent();
        expect(event.props, equals([]));
      });
    });
  });
}
