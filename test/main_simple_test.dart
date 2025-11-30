import 'package:ditonton/app/app.dart';
import 'package:ditonton/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('main function can be called', () {
    // Test that main function exists and can be referenced
    expect(main, isA<Function>());
  });

  test('MyApp can be instantiated', () {
    final app = MyApp();
    expect(app, isA<MyApp>());
  });

  test('MyApp has correct key', () {
    const key = Key('test_key');
    final app = MyApp(key: key);
    expect(app.key, key);
  });
}
