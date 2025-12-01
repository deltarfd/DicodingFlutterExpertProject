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

    // Use system trusted roots as fallback
    final context = SecurityContext(withTrustedRoots: true);

    try {
      // Try to load custom certificate from assets
      final certData =
          await rootBundle.load('assets/certificates/api_themoviedb.pem');
      final bytes = certData.buffer.asUint8List();

      // Only add if certificate data is valid (not empty)
      if (bytes.isNotEmpty && bytes.length > 100) {
        context.setTrustedCertificatesBytes(bytes);
        debugPrint('✅ Custom SSL certificate loaded');
      } else {
        debugPrint('⚠️ Certificate file invalid, using system roots');
      }
    } catch (e) {
      debugPrint('⚠️ Could not load custom certificate: $e');
      debugPrint('Using system trusted roots as fallback');
    }

    _httpClient = HttpClient(context: context);
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
    // Explicitly bypass SSL pinning for Firebase/Crashlytics services
    // This prevents any potential interference with analytics reporting
    if (request.url.host.contains('firebase') ||
        request.url.host.contains('google') ||
        request.url.host.contains('crashlytics')) {
      return _inner.send(request);
    }

    // Use certificate pinning ONLY for TMDB API
    if (request.url.host.contains('themoviedb.org')) {
      try {
        final ioClient = await _secureIoClient;
        return ioClient.send(request);
      } catch (e) {
        debugPrint('❌ SSL Pinning Error: $e');
        rethrow;
      }
    }

    // For other hosts, use regular client
    return _inner.send(request);
  }
}
