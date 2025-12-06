import 'package:ditonton/app/routes.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('AppRoutes can navigate to About and unknown page', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        onGenerateRoute: AppRoutes.onGenerateRoute,
        initialRoute: AboutPage.routeName,
      ),
    );

    expect(find.text('About'), findsOneWidget);

    // Navigate to unknown route
    final nav = tester.state<NavigatorState>(find.byType(Navigator));
    nav.pushNamed('/unknown');
    await tester.pumpAndSettle();

    expect(find.text('Page not found :('), findsOneWidget);
  });
}
