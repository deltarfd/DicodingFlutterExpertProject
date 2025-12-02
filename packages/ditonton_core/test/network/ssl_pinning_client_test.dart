import 'dart:io';
import 'dart:typed_data';

import 'package:ditonton_core/core/network/ssl_pinning_client.dart';
import 'package:flutter/services.dart';
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

// Helper to create a mock certificate in PEM format (actual TMDB cert)
String getMockCertificatePem() {
  return '''-----BEGIN CERTIFICATE-----
MIIF0jCCBLqgAwIBAgIQCwOjjj6RQZ18E32Hz2ZX/jANBgkqhkiG9w0BAQsFADA8
MQswCQYDVQQGEwJVUzEPMA0GA1UEChMGQW1hem9uMRwwGgYDVQQDExNBbWF6b24g
UlNBIDIwNDggTTA0MB4XDTI1MDYxOTAwMDAwMFoXDTI2MDcxNzIzNTk1OVowGzEZ
MBcGA1UEAwwQKi50aGVtb3ZpZWRiLm9yZzCCASIwDQYJKoZIhvcNAQEBBQADggEP
ADCCAQoCggEBAJ57r4TgtnF369/cPPAqJaXNMQpFMbDk+uIsS/pxXMyOy6W/XNTe
zvEZY8urw0EoVu32/RJ9SaJ2mC9dTdEI5e6tio7rQth3hOHDH0euy6wj06BPT8Dl
VkGRVQU9hdyOtZ90yWp29bf0bl/aImoliWUob7n6oX4ccv6X7cGYqSclaEbpvc1p
mr2XIdZrCiZa8JWFb24xAg6mGZa4p5GoDdJ3RmlR0TiaZrRNo705Q6HI/JXdS+P7
IdAN7k+TUG3oZzVol8oRf/tK5/4DZcVerCUEBdQNzn1inOXQD+orau3HeQYJljYl
Or756a7fyqMYob2mgqg5as3GqYT+mIbkdkcCAwEAAaOCAu8wggLrMB8GA1UdIwQY
MBaAFB9SkmFWglR/gWbYHT0KqjJch90IMB0GA1UdDgQWBBToGs59aocX7Hy0F9XG
kb9GOh0RmDArBgNVHREEJDAighAqLnRoZW1vdmllZGIub3Jngg50aGVtb3ZpZWRi
Lm9yZzATBgNVHSAEDDAKMAgGBmeBDAECATAOBgNVHQ8BAf8EBAMCBaAwEwYDVR0l
BAwwCgYIKwYBBQUHAwEwOwYDVR0fBDQwMjAwoC6gLIYqaHR0cDovL2NybC5yMm0w
NC5hbWF6b250cnVzdC5jb20vcjJtMDQuY3JsMHUGCCsGAQUFBwEBBGkwZzAtBggr
BgEFBQcwAYYhaHR0cDovL29jc3AucjJtMDQuYW1hem9udHJ1c3QuY29tMDYGCCsG
AQUFBzAChipodHRwOi8vY3J0LnIybTA0LmFtYXpvbnRydXN0LmNvbS9yMm0wNC5j
ZXIwDAYDVR0TAQH/BAIwADCCAX4GCisGAQQB1nkCBAIEggFuBIIBagFoAHYA1219
ENGn9XfCx+lf1wC/+YLJM1pl4dCzAXMXwMjFaXcAAAGXhjta/wAABAMARzBFAiEA
ooQSiJgXpEiM/fLjCxxbb+9lCdDbPfUTYL43aHAN6uACIHpPVIWtnRpxNjOYHFYB
3M/hjBFTFJR5i4qoimPqa2YQAHYAwjF+V0UZo0XufzjespBB68fCIVoiv3/Vta12
mtkOUs0AAAGXhjtbLAAABAMARzBFAiA2hP6nrSVCgfuABcd7N0VRDeCBFQDoXJUg
Vfnu4AI+8gIhAJZOhpLmAchIOICMaQaL1b2TuspBwLz0QxHLVRO0YktuAHYAlE5D
h/rswe+B8xkkJqgYZQHH0184AgE/cmd9VTcuGdgAAAGXhjtbQQAABAMARzBFAiEA
5tESHFXqxf4Qg1TIK10Le7cc75fNpN9U0Q42c5M3xGcCICZKT2GX1CJrJi8IYn88
z8S6F92pNCgTvK/UR04QZ0nKMA0GCSqGSIb3DQEBCwUAA4IBAQDDxoJo7AdhuWGo
MvZS7Y6c2E3yd3AS74aPbiEe6SZB3sFy77g1jUMrXsD2lTD+xTUC/s2Ga/aV8IHx
TZFMI4DEb2tyf9p9vCvkNQxH02wzo6GPenHu5kDxaRg07qIjW5YBSPAvZZoLeTyp
/4qINOaIHAcAmVR7Fs6EekMbZSMypy3KuysVkhcFkWyw0GKBnk/gmuvWEZJcxxWt
ROmBUYaC4vNEPJVoROVb6Fm6G/N+ZnmlyGIBsXB8yxHFRiioBUqIHVk4KIrX7Q6L
6ErW6HmKqnUOeQc/TzOkoAJAL0hufqnhuWo8TefKhUAHMjVkk+nnlxepLhgf90Hh
Uv2GazPs
-----END CERTIFICATE-----''';
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
    test('should attempt SSL pinning for themoviedb.org domains', () async {
      // This test exercises the TMDB domain path, which calls _secureIoClient
      // and _secureHttpClient (certificate loading logic)
      final request = http.Request(
          'GET', Uri.parse('https://api.themoviedb.org/3/movie/popular'));

      try {
        await sslPinningClient.send(request);
        // If it succeeds, certificate loaded and network call worked
        // This is unlikely in test environment but possible if properly configured
      } catch (e) {
        // Expected in test environment (cert load failure or network error)
        // The important part: it should NOT be "is not allowed" error
        // That would mean we didn't enter the TMDB branch
        expect(e.toString(), isNot(contains('is not allowed')),
            reason: 'TMDB URLs should attempt SSL pinning, not be rejected');

        // We expect either:
        // 1. Certificate loading error (if asset not available)
        // 2. Network error (if cert loads but network fails)
        // 3. SSL handshake error (if cert is invalid)
        // All of these mean we successfully entered the TMDB code path
      }
    });

    test('should load certificate and create HttpClient successfully',
        () async {
      // Mock the asset bundle to return a valid certificate
      final mockCertBytes =
          Uint8List.fromList(getMockCertificatePem().codeUnits);
      final mockCertData = ByteData.sublistView(mockCertBytes);

      // Setup mock for rootBundle.load
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', (message) async {
        // Return the mock certificate data
        return mockCertData;
      });

      addTearDown(() {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMessageHandler('flutter/assets', null);
      });

      final request = http.Request(
          'GET', Uri.parse('https://api.themoviedb.org/3/movie/popular'));

      try {
        await sslPinningClient.send(request);
        // If successful, great! Certificate loaded and network call worked
      } catch (e) {
        // Expected: network error or SSL handshake error
        // The key is that we loaded the certificate successfully
        // and created the HttpClient (covering lines 25-47)
        expect(e.toString(), isNot(contains('Unable to load asset')),
            reason: 'Certificate should have loaded from mocked asset bundle');

        // Should get network or SSL error, not asset loading error
        expect(
          e.toString().contains('SocketException') ||
              e.toString().contains('HandshakeException') ||
              e.toString().contains('certificate') ||
              e.toString().contains('Connection'),
          true,
          reason: 'Should fail with network/SSL error, not asset error',
        );
      }
    });

    test('should reject certificate that is too small', () async {
      // Mock asset bundle to return a certificate that's too small
      final smallCert = Uint8List.fromList('SMALL'.codeUnits);
      final smallCertData = ByteData.sublistView(smallCert);

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', (message) async {
        return smallCertData;
      });

      addTearDown(() {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMessageHandler('flutter/assets', null);
      });

      final request = http.Request(
          'GET', Uri.parse('https://api.themoviedb.org/3/movie/popular'));

      expect(
        () async => await sslPinningClient.send(request),
        throwsA(predicate((e) =>
            e.toString().contains('Invalid certificate file') ||
            e.toString().contains('empty or too small'))),
        reason: 'Should reject certificate that is too small',
      );
    });

    test('should attempt SSL pinning for tmdb.org domains', () async {
      final request = http.Request(
          'GET', Uri.parse('https://image.tmdb.org/t/p/w500/poster.jpg'));

      try {
        await sslPinningClient.send(request);
      } catch (e) {
        expect(e.toString(), isNot(contains('is not allowed')),
            reason:
                'tmdb.org URLs should attempt SSL pinning, not be rejected');
      }
    });

    test('should attempt SSL pinning for different TMDB subdomains', () async {
      final tmdbUrls = [
        'https://www.themoviedb.org/movie/123',
        'https://api.themoviedb.org/3/tv/popular',
      ];

      for (final url in tmdbUrls) {
        final request = http.Request('GET', Uri.parse(url));

        try {
          await sslPinningClient.send(request);
        } catch (e) {
          // Should enter TMDB path (not get "is not allowed")
          expect(e.toString(), isNot(contains('is not allowed')),
              reason: 'TMDB subdomain should attempt SSL pinning: $url');
        }
      }
    });

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
