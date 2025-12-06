import 'package:ditonton_tv/features/tv/domain/entities/tv.dart';
import 'package:ditonton_tv/features/tv/presentation/pages/tv_detail_page.dart';
import 'package:ditonton_tv/features/tv/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('TvCardList navigates to detail page on tap', (tester) async {
    const tv = Tv(
      id: 123,
      name: 'Test TV',
      overview: 'Overview',
      posterPath: '/poster.jpg',
      voteAverage: 8.5,
    );

          return null;
        },
      ),
    );

    // Tap on the card
    await tester.tap(find.byType(InkWell));
    await tester.pumpAndSettle();

    expect(navigationCalled, true);
  });
}
