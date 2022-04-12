import 'package:altme/app/app.dart';
import 'package:altme/flavor/cubit/flavor_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FlavorCubit', () {
    test('development flavor state is correctly emitted', () {
      expect(FlavorCubit(FlavorMode.development).state, FlavorMode.development);
    });

    test('staging flavor state is correctly emitted', () {
      expect(FlavorCubit(FlavorMode.staging).state, FlavorMode.staging);
    });

    test('production flavor state is correctly emitted', () {
      expect(FlavorCubit(FlavorMode.production).state, FlavorMode.production);
    });
  });
}
