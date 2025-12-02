import 'dart:io';
import 'dart:typed_data';

import 'package:ditonton_core/core/network/ssl_pinning_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

// Simple mock client for testing
class MockClient extends http.BaseClient {
  int callCount = 0;
  http.BaseRequest? lastRequest;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    callCount++;
    lastRequest = request;
    return http.StreamedResponse(Stream.value([]), 200);
  }

  void reset() {
    callCount = 0;
    lastRequest = null;
  }
}

// Fake X509Certificate for testing
class FakeX509Certificate implements X509Certificate {
  @override
  Uint8List get der => Uint8List.fromList([]);

  @override
  String get pem => '';

  @override
  Uint8List get sha1 => Uint8List.fromList([]);

  @override
  String get subject => '';

  @override
  String get issuer => '';

  @override
  DateTime get startValidity => DateTime.now();

  @override
  DateTime get endValidity => DateTime.now();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SslPinningClient sslPinningClient;
  late MockClient mockInnerClient;

  setUp(() {
    mockInnerClient = MockClient();
    sslPinningClient = SslPinningClient(mockInnerClient);
  });

  group('SslPinningClient Domain Validation', () {
    test('should allow whitelisted Firebase domains', () async {
      final firebaseUrls = [
        'https://firebase.google.com/analytics',
        'https://firebaseio.com/data',
        'https://crashlytics.google.com/report',
        'https://www.googleapis.com/firebase',
        'https://fonts.gstatic.com/font',
      ];

      for (final url in firebaseUrls) {
        mockInnerClient.reset();
        final request = http.Request('GET', Uri.parse(url));
        final response = await sslPinningClient.send(request);

        expect(response.statusCode, 200,
            reason: 'Firebase URL should be allowed: $url');
        expect(mockInnerClient.callCount, 1,
            reason: 'Should use inner client for: $url');
      }
    });

    test('should allow requests with google in domain', () async {
      final request =
          http.Request('GET', Uri.parse('https://accounts.google.com/signin'));
      final response = await sslPinningClient.send(request);

      expect(response.statusCode, 200);
      expect(mockInnerClient.callCount, 1);
    });

    test('should REJECT requests to unauthorized domains', () async {
      final unauthorizedUrls = [
        'https://example.com/api',
        'https://another-api.com/data',
        'https://random-website.org/page',
        'https://malicious-site.net/endpoint',
        'https://api.github.com/repos',
      ];

      for (final url in unauthorizedUrls) {
        mockInnerClient.reset();
        final request = http.Request('GET', Uri.parse(url));

        expect(
          () async => await sslPinningClient.send(request),
          throwsA(
            predicate((e) =>
                e is Exception &&
                e.toString().contains('SSL Pinning Error') &&
                e.toString().contains('is not allowed') &&
                e.toString().contains('themoviedb.org')),
          ),
          reason: 'Should reject unauthorized domain: $url',
        );

        expect(mockInnerClient.callCount, 0,
            reason: 'Should not use inner client for: $url');
      }
    });

    test('should provide clear error message for blocked domains', () async {
      final request =
          http.Request('GET', Uri.parse('https://unauthorized.com/api'));

      try {
        await sslPinningClient.send(request);
        fail('Should have thrown an exception');
      } catch (e) {
        expect(e.toString(), contains('unauthorized.com'));
        expect(e.toString(), contains('is not allowed'));
        expect(e.toString(), contains('themoviedb.org'));
        expect(e.toString(), contains('SSL Pinning Error'));
      }
    });
  });

  group('SslPinningClient Security Validation', () {
    test('should not allow bypassing with query parameters or paths', () async {
      final trickyUrls = [
        'https://malicious.com/api?redirect=themoviedb.org',
        'https://evil.org/themoviedb.org/fake',
        'https://bad-site.net/path/to/themoviedb.org',
      ];

      for (final url in trickyUrls) {
        final request = http.Request('GET', Uri.parse(url));

        expect(
          () async => await sslPinningClient.send(request),
          throwsA(isA<Exception>()),
          reason: 'Should reject URL with themoviedb.org in path/query: $url',
        );
      }
    });

    test('validateCertificate should always return false', () {
      final cert = FakeX509Certificate();
      final result = SslPinningClient.validateCertificate(cert, 'host', 443);
      expect(result, false);
    });
  });
}
