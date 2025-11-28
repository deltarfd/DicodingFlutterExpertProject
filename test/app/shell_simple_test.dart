import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton/app/shell.dart';

void main() {
  test('AppShell can be instantiated', () {
    const shell = AppShell();
    expect(shell, isA<AppShell>());
  });

  test('AppShell has correct key', () {
    const key = Key('test_key');
    const shell = AppShell(key: key);
    expect(shell.key, key);
  });

  test('AppShell createState returns correct state type', () {
    const shell = AppShell();
    final state = shell.createState();
    expect(state, isA<State<AppShell>>());
  });
}
