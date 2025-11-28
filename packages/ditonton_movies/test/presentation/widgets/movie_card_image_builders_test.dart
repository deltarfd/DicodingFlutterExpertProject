import 'package:ditonton_core/core/core.dart';
import 'package:ditonton_movies/features/movies/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../dummy_data/dummy_objects.dart';

void main() {
  testWidgets('MovieCard placeholder and errorWidget builders can build',
      (tester) async {
    await tester
        .pumpWidget(MaterialApp(home: Scaffold(body: MovieCard(testMovie))));
    await tester.pump();

    final ctx = tester.element(find.byType(Scaffold));
    final cachedImage =
        tester.widget<CachedNetworkImage>(find.byType(CachedNetworkImage));

    // Invoke the builders; ensure they return a widget without throwing
    final placeholder = cachedImage.placeholder!;
    final errorBuilder = cachedImage.errorWidget!;
    expect(placeholder(ctx, 'url'), isA<Widget>());
    expect(errorBuilder(ctx, 'url', Exception()), isA<Widget>());
  });
}
