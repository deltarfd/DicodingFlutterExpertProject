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

    bool navigationCalled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: TvCardList(tv)),
        onGenerateRoute: (settings) {
          if (settings.name == TvDetailPage.ROUTE_NAME) {
            navigationCalled = true;
            expect(settings.arguments, 123);
            return MaterialPageRoute(
              builder: (_) => const Scaffold(body: Text('Detail Page')),
            );
          }
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
