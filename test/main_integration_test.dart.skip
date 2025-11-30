import 'package:ditonton/app/app.dart';
import 'package:ditonton/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('main() should initialize and run the app', (
    WidgetTester tester,
  ) async {
    // Execute the main function
    app.main();

    // Give the app time to initialize
    await tester.pumpAndSettle();

    // Verify the application has started
    expect(find.byType(MyApp), findsOneWidget);
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
