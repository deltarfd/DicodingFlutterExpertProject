import 'package:ditonton/app/shell_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ShellCubit shellCubit;

  setUp(() {
    shellCubit = ShellCubit();
  });

  tearDown(() {
    shellCubit.close();
  });

  group('ShellCubit', () {
    test('initial state is 0', () {
      expect(shellCubit.state, 0);
    });

    test('setIndex emits new index', () {
      expectLater(shellCubit.stream, emitsInOrder([1, 2, 0]));

      shellCubit.setIndex(1);
      shellCubit.setIndex(2);
      shellCubit.setIndex(0);
    });

    test('setIndex updates state', () {
      shellCubit.setIndex(1);
      expect(shellCubit.state, 1);

      shellCubit.setIndex(2);
      expect(shellCubit.state, 2);

      shellCubit.setIndex(0);
      expect(shellCubit.state, 0);
    });

    test('multiple setIndex calls work correctly', () {
      for (int i = 0; i < 3; i++) {
        shellCubit.setIndex(i);
        expect(shellCubit.state, i);
      }
    });
  });
}
