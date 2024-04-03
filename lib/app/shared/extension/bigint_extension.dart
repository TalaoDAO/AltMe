extension BigIntExtension on BigInt {
  List<int> get toBytes {
    var value = this;
    final List<int> bytes = [];
    while (value > BigInt.zero) {
      bytes.insert(0, (value & BigInt.from(0xFF)).toInt());
      value >>= 8;
    }
    return bytes;
  }
}
