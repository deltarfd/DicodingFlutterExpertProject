import 'package:ditonton_core/core/core.dart';
import 'package:ditonton_tv/features/tv/domain/entities/tv.dart';
import 'package:ditonton_tv/features/tv/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('TvCardList placeholder and errorWidget build', (tester) async {
    final tv = const Tv(
      id: 1,
      name: 'N',
      overview: 'O',
      posterPath: '/p',
      voteAverage: 8.0,
    );
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: TvCardList(tv))));
    await tester.pump();

    final ctx = tester.element(find.byType(Scaffold));
    final cached = tester.widget<CachedNetworkImage>(
      find.byType(CachedNetworkImage),
    );
    expect(cached.placeholder!(ctx, 'u'), isA<Widget>());
    expect(cached.errorWidget!(ctx, 'u', Exception()), isA<Widget>());
  });
}
