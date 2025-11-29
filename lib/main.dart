import 'package:ditonton/app/app.dart';
import 'package:ditonton/injection.dart' as di;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  di.init();
  runApp(const MyApp());
}
