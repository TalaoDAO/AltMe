import 'dart:typed_data';

extension Uint8ListExtension on Uint8List {
  Uint8List get filterPayload {
    final tester = Uint8List.fromList([5, 1]);

    if (length <= 6) {
      return this;
    }

    if (this[0] != tester[0]) {
      return this;
    }

    if (this[1] != tester[1]) {
      return this;
    }

    return sublist(6);
  }
}
