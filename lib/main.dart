import 'package:ditonton/app/app.dart';
import 'package:ditonton/injection.dart' as di;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Initialize Firebase services
/// Returns true if successful, false if Firebase is unavailable
Future<bool> initializeFirebase() async {
  try {
    await Firebase.initializeApp();
    debugPrint('✅ Firebase initialized successfully');

    // Configure Crashlytics error handlers
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    debugPrint('✅ Firebase Crashlytics configured');
    return true;
  } catch (e) {
    debugPrint('⚠️ Firebase initialization failed: $e');
    debugPrint('App will continue without Firebase features');
    return false;
  }
}

Future<void> main() async {
  await mainCommon();
  runApp(const MyApp());
}

Future<void> mainCommon() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase();
  di.init();
}
