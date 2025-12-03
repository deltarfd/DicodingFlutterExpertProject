import 'package:ditonton/app/shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('AppShell can be instantiated', () {
    const shell = AppShell();
    expect(shell, isA<StatelessWidget>());
  });

  test('AppShell can be instantiated with key', () {
    const key = Key('test_key');
    const shell = AppShell(key: key);
    expect(shell.key, key);
  });
}
