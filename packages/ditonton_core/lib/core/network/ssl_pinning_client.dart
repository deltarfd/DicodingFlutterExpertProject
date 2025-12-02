import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class SslPinningClient extends http.BaseClient {
  final http.Client _inner;
  HttpClient? _httpClient;

  SslPinningClient(this._inner);

  Future<HttpClient> get _secureHttpClient async {
    if (_httpClient != null) return _httpClient!;

    // CRITICAL: withTrustedRoots: false ensures ONLY our pinned certificate is trusted
    // This means if the certificate is changed/invalid, the connection WILL fail
    final context = SecurityContext(withTrustedRoots: false);

    try {
      // Load the pinned certificate from assets
      final certData =
          await rootBundle.load('assets/certificates/api_themoviedb.pem');
      final bytes = certData.buffer.asUint8List();

      if (bytes.isEmpty || bytes.length < 100) {
        throw Exception(
            'Invalid certificate file: certificate is empty or too small');
      }

      // Set ONLY this certificate as trusted
      context.setTrustedCertificatesBytes(bytes);
      debugPrint('✅ SSL Pinning: Certificate loaded (${bytes.length} bytes)');
    } catch (e) {
      debugPrint('❌ SSL Pinning: Failed to load certificate: $e');
      // DO NOT fall back to system roots - rethrow the error
      rethrow;
    }

    final client = HttpClient(context: context);

    // CRITICAL: Reject ALL certificates that don't match our pinned certificate
    client.badCertificateCallback = validateCertificate;

    _httpClient = client;
    return _httpClient!;
  }

  IOClient? _ioClient;

  Future<IOClient> get _secureIoClient async {
    if (_ioClient != null) return _ioClient!;
    final client = await _secureHttpClient;
    _ioClient = IOClient(client);
    return _ioClient!;
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final host = request.url.host;

    // Whitelist for essential services that need to bypass SSL pinning
    final whitelistedDomains = [
      'firebase',
      'google',
      'crashlytics',
      'googleapis.com',
      'firebaseio.com',
      'gstatic.com',
    ];

    // Allow whitelisted services (Firebase, Google Analytics, etc.)
    if (whitelistedDomains.any((domain) => host.contains(domain))) {
      return _inner.send(request);
    }

    // Enforce SSL pinning ONLY for TMDB API
    if (host.contains('themoviedb.org') || host.contains('tmdb.org')) {
      try {
        final ioClient = await _secureIoClient;
        return ioClient.send(request);
      } catch (e) {
        debugPrint('❌ SSL Pinning Error for $host: $e');
        rethrow;
      }
    }

    // REJECT all other domains - SSL Pinning enforces TMDB-only access
    debugPrint('🚫 SSL Pinning: Blocked request to unauthorized domain: $host');
    throw Exception(
      'SSL Pinning Error: Connection to $host is not allowed. '
      'This client is configured to only connect to TMDB API (themoviedb.org).',
    );
  }

  // Exposed for testing to ensure 100% coverage
  static bool validateCertificate(X509Certificate cert, String host, int port) {
    debugPrint('🔒 SSL Pinning: Certificate verification for $host:$port');
    // Always return false to enforce strict certificate validation
    // Only certificates that match our pinned cert will be accepted
    return false;
  }
}
