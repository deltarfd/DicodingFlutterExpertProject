import 'package:ditonton/injection.dart' as di;
import 'package:ditonton_tv/features/tv/domain/usecases/get_tv_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() {
  test('DI init registers dependencies', () {
    di.init();
    // spot check a few
    expect(di.locator.isRegistered<http.Client>(), true);
    expect(di.locator.isRegistered<GetTvDetail>(), true);
    // Cleanup
    di.locator.reset();
  });
}
