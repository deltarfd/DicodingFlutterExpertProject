import 'dart:io';
import 'dart:async';
import 'dart:core' as core;

class MockHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return _MockHttpClient();
  }
}

class _MockHttpClient implements HttpClient {
  @override
  dynamic noSuchMethod(Invocation invocation) {
    throw UnimplementedError();
  }

  @override
  Future<HttpClientRequest> getUrl(Uri url) {
    return Future.value(_MockHttpClientRequest());
  }

  @override
  bool autoUncompress = true;
}

class _MockHttpClientRequest implements HttpClientRequest {
  @override
  dynamic noSuchMethod(Invocation invocation) {
    throw UnimplementedError();
  }

  @override
  Future<HttpClientResponse> close() {
    return Future.value(_MockHttpClientResponse());
  }

  @override
  HttpHeaders get headers => _MockHttpHeaders();
}

class _MockHttpHeaders implements HttpHeaders {
  @override
  dynamic noSuchMethod(Invocation invocation) {
    throw UnimplementedError();
  }

  @override
  void add(String name, Object value, {bool preserveHeaderCase = false}) {}
}

class _MockHttpClientResponse implements HttpClientResponse {
  @override
  dynamic noSuchMethod(Invocation invocation) {
    throw UnimplementedError();
  }

  @override
  int get statusCode => 200;

  @override
  int get contentLength => 0;

  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;

  @override
  Stream<core.List<int>> listen(
    void Function(core.List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return Stream<core.List<int>>.value(<int>[]).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}
