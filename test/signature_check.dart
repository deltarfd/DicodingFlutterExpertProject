import 'package:firebase_crashlytics_platform_interface/firebase_crashlytics_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';

class TestCrashlyticsPlatform extends FirebaseCrashlyticsPlatform {
  // Missing recordError implementation
}

void main() {
  test('signature check', () {
    TestCrashlyticsPlatform();
  });
}
