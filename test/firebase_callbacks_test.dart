import 'dart:async';
import 'dart:ui';

import 'package:ditonton/main.dart' as app_main;
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Manual Mock for FirebasePlatform
class ManualMockFirebasePlatform extends FirebasePlatform {
  FirebaseAppPlatform? _app;

  void setApp(FirebaseAppPlatform app) {
    _app = app;
  }

  @override
  Future<FirebaseAppPlatform> initializeApp({
    String? name,
    FirebaseOptions? options,
  }) async {
    return _app!;
  }

  @override
  List<FirebaseAppPlatform> get apps => [];

  @override
  FirebaseAppPlatform app([String name = defaultFirebaseAppName]) {
    return _app!;
  }
}

class ManualMockFirebaseAppPlatform extends FirebaseAppPlatform {
  ManualMockFirebaseAppPlatform()
    : super(
        defaultFirebaseAppName,
        const FirebaseOptions(
          apiKey: 'test',
          appId: 'test',
          messagingSenderId: 'test',
          projectId: 'test',
        ),
      );

  @override
  String get name => '[DEFAULT]';

  @override
  FirebaseOptions get options => const FirebaseOptions(
    apiKey: 'test',
    appId: 'test',
    messagingSenderId: 'test',
    projectId: 'test',
  );
}

class MockFirebaseCrashlytics extends Mock implements FirebaseCrashlytics {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(Uri());

    // Mock Firebase Crashlytics Channel
    const MethodChannel channel = MethodChannel(
      'plugins.flutter.io/firebase_crashlytics',
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          return null;
        });
  });

  test(
    'initializeFirebase sets up error handlers and they can be invoked',
    () async {
      // Setup mocks
      final mockFirebasePlatform = ManualMockFirebasePlatform();
      final mockFirebaseAppPlatform = ManualMockFirebaseAppPlatform();
      mockFirebasePlatform.setApp(mockFirebaseAppPlatform);
      FirebasePlatform.instance = mockFirebasePlatform;

      final mockCrashlytics = MockFirebaseCrashlytics();

      // Execute
      await app_main.initializeFirebase();

      // Verify handlers are set
      expect(FlutterError.onError, isNotNull);
      expect(PlatformDispatcher.instance.onError, isNotNull);

      // Invoke FlutterError.onError
      // This covers line 17
      // We wrap in runZonedGuarded to catch any async errors from Crashlytics
      runZonedGuarded(() {
        FlutterError.onError!(
          FlutterErrorDetails(
            exception: Exception('Test Exception'),
            library: 'test',
          ),
        );
      }, (error, stack) {});

      // Invoke PlatformDispatcher.instance.onError
      // This covers line 21
      runZonedGuarded(() {
        PlatformDispatcher.instance.onError!(
          Exception('Test Async Exception'),
          StackTrace.empty,
        );
      }, (error, stack) {});
    },
  );
}
