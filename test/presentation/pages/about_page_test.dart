import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('AboutPage renders correctly', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: AboutPage()));
    await tester.pumpAndSettle();

    // Verify AppBar
    expect(find.text('About'), findsOneWidget);

    // Verify logo image
    expect(find.byType(Image), findsOneWidget);

    // Verify description text
    expect(find.textContaining('Ditonton merupakan'), findsOneWidget);
    expect(find.textContaining('Dicoding Indonesia'), findsOneWidget);
  });

  testWidgets('AboutPage has correct layout structure', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: AboutPage()));
    await tester.pumpAndSettle();

    // Verify structure
    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(Column), findsWidgets);
    expect(find.byType(Container), findsWidgets);
  });

  test('AboutPage has correct ROUTE_NAME', () {
    expect(AboutPage.routeName, '/about');
  });
}
