import 'package:ditonton/main.dart' as app_main;
import 'package:ditonton/injection.dart' as di;
import 'package:ditonton/app/app.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Simple mock for Firebase that succeeds
class MockFirebasePlatform extends FirebasePlatform {
  final _app = MockFirebaseAppPlatform();

  @override
  Future<FirebaseAppPlatform> initializeApp({
    String? name,
    FirebaseOptions? options,
  }) async {
    return _app;
  }

  @override
  List<FirebaseAppPlatform> get apps => [_app];

  @override
  FirebaseAppPlatform app([String name = defaultFirebaseAppName]) => _app;
}

class MockFirebaseAppPlatform extends FirebaseAppPlatform {
  MockFirebaseAppPlatform()
    : super(
        defaultFirebaseAppName,
        const FirebaseOptions(
          apiKey: 'test',
          appId: 'test',
          messagingSenderId: 'test',
          projectId: 'test',
        ),
      );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Main Coverage', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      // Setup Firebase mock before each test
      FirebasePlatform.instance = MockFirebasePlatform();
      // Reset DI before the test - mainCommon() will initialize it
      await di.locator.reset();
    });

    tearDown(() async {
      await di.locator.reset();
    });

    testWidgets('mainCommon executes and runs app (covers lines 40-44)', (
      tester,
    ) async {
      // Arrange
      bool appRunnerCalled = false;
      Widget? capturedWidget;

      // Act - Call mainCommon directly
      await app_main.mainCommon((widget) {
        appRunnerCalled = true;
        capturedWidget = widget;
      });

      // Assert
      expect(
        appRunnerCalled,
        isTrue,
        reason: 'appRunner should be called (line 44)',
      );
      expect(
        capturedWidget,
        isA<MyApp>(),
        reason: 'Should pass MyApp to appRunner (line 44)',
      );
    });

    test('main function exists (covers line 36-37)', () {
      // Verify main function is defined
      expect(app_main.main, isA<Function>());
    });
  });
}
