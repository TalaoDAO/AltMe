import 'package:altme/app/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MWebViewCubit', () {
    late MWebViewCubit cubit;

    setUp(() {
      cubit = MWebViewCubit();
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state is true', () {
      expect(cubit.state, true);
    });

    test('emits new state when setLoading is called', () {
      expect(cubit.state, true);
      cubit.setLoading(isLoading: false);
      expect(cubit.state, false);
      cubit.setLoading(isLoading: true);
      expect(cubit.state, true);
    });
  });
}
