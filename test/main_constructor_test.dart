import 'package:ditonton/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('main function exists and can be referenced', () {
    expect(main, isA<Function>());
  });

  test('MyApp can be instantiated', () {
    final app = MyApp();
    expect(app, isA<StatelessWidget>());
  });

  test('MyApp can be instantiated with key', () {
    const key = Key('test_key');
    final app = MyApp(key: key);
    expect(app.key, key);
  });
}
