import 'package:ditonton/app/app.dart';
import 'package:ditonton/injection.dart' as di;
import 'package:flutter/material.dart';

// Export MyApp for testing
export 'package:ditonton/app/app.dart' show MyApp;

void main() {
  di.init();
  runApp(const MyApp());
}
