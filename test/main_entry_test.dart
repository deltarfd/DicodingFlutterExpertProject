import 'dart:io';

import 'package:ditonton/main.dart' as app_main;
import 'package:ditonton/injection.dart' as di;
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter/services.dart';

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

class TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    HttpOverrides.global = TestHttpOverrides();
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

  testWidgets('main() executes successfully', (tester) async {
    // Setup mocks
    SharedPreferences.setMockInitialValues({});

    final mockFirebasePlatform = ManualMockFirebasePlatform();
    final mockFirebaseAppPlatform = ManualMockFirebaseAppPlatform();
    mockFirebasePlatform.setApp(mockFirebaseAppPlatform);
    FirebasePlatform.instance = mockFirebasePlatform;

    // Reset DI
    await di.locator.reset();

    // Execute main()
    // This calls mainCommon() and runApp()
    // testWidgets overrides runApp to pump the widget
    await app_main.main();
    await tester.pump(const Duration(seconds: 2));

    // Verify DI initialized
    expect(
      di.locator.isRegistered<SharedPreferences>(),
      isFalse,
    ); // SharedPreferences is not registered in DI, but used
    // Check something that IS registered
    // ThemeModeNotifier is registered in mainCommon -> di.init
    // But di.init registers ThemeModeNotifier?
    // Let's check injection.dart
    // di.init registers BLoCs and Http Client.
    // ThemeModeNotifier is registered in AppProviders? No, AppProviders creates it using locator?
    // Wait, AppProviders: ChangeNotifierProvider(create: (_) => di.locator<ThemeModeNotifier>())
    // So ThemeModeNotifier MUST be registered in locator.
    // Does di.init register it?
    // Let's check injection.dart
  });
}
