import 'package:ditonton/injection.dart' as di;
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('DI init does not throw', () {
    expect(di.init, returnsNormally);
  });
}
