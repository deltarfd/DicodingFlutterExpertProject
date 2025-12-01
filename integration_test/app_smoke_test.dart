import 'package:ditonton/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('launches and navigates to movies pages', (tester) async {
    await app.main();
    await tester.pumpAndSettle();

    // Ensure home loaded
    expect(find.text('Now Playing'), findsOneWidget);

    // Tap "See More" under Popular
    final seeMore = find.text('See More');
    expect(seeMore, findsWidgets);
    await tester.tap(seeMore.first);
    await tester.pumpAndSettle();

    // Back to home
    final back = find.byTooltip('Back');
    if (back.evaluate().isNotEmpty) {
      await tester.tap(back);
    }
    await tester.pumpAndSettle();

    // Navigate to Search and back
    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();
    final back2 = find.byTooltip('Back');
    if (back2.evaluate().isNotEmpty) {
      await tester.tap(back2);
      await tester.pumpAndSettle();
    }
  });
}
