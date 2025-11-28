import 'dart:io';
import 'dart:async';

class TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return _TestHttpClient();
  }
}

class _TestHttpClient implements HttpClient {
  @override
  Future<HttpClientRequest> getUrl(Uri url) {
    return Future.value(_TestHttpClientRequest());
  }

  @override
  Future<HttpClientRequest> openUrl(String method, Uri url) {
    return Future.value(_TestHttpClientRequest());
  }

  @override
  Future<HttpClientRequest> postUrl(Uri url) {
    return Future.value(_TestHttpClientRequest());
  }

  @override
  Future<HttpClientRequest> putUrl(Uri url) {
    return Future.value(_TestHttpClientRequest());
  }

  @override
  Future<HttpClientRequest> deleteUrl(Uri url) {
    return Future.value(_TestHttpClientRequest());
  }

  @override
  Future<HttpClientRequest> headUrl(Uri url) {
    return Future.value(_TestHttpClientRequest());
  }

  @override
  Future<HttpClientRequest> patchUrl(Uri url) {
    return Future.value(_TestHttpClientRequest());
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return null;
  }
}

class _TestHttpClientRequest implements HttpClientRequest {
  @override
  Future<HttpClientResponse> close() {
    return Future.value(_TestHttpClientResponse());
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return null;
  }

  @override
  HttpHeaders get headers => _TestHttpHeaders();
}

class _TestHttpHeaders implements HttpHeaders {
  @override
  void add(String name, Object value, {bool preserveHeaderCase = false}) {}

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return null;
  }
}

class _TestHttpClientResponse implements HttpClientResponse {
  @override
  int get statusCode => 200;

  @override
  int get contentLength => kTransparentImage.length;

  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;

  @override
  String get reasonPhrase => "OK";

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return Stream<List<int>>.fromIterable([kTransparentImage]).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  @override
  List<RedirectInfo> get redirects => [];

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return null;
  }
}

const List<int> kTransparentImage = [
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0A,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
  0x42,
  0x60,
  0x82,
];
