import 'dart:convert';
import 'dart:io';

int getPositionOfZlibBit(int index) => index % 8;

int getPositionOfGZipBit(int index) => 7 - (index % 8);

int getByte(int index) => index ~/ 8;

int getBit({
  required int index,
  required String encodedList,
}) {
  final bytes = getByte(index);
  final decompressedBytes = decodeAndGzibDecompress(encodedList);

  final byteToCheck = decompressedBytes[bytes];
  final bitPosition = getPositionOfGZipBit(index);

  // byte => 32 =0100000
  // The bit in position 5 is set to 1 !!!
  // so bit = 1
  final bit = (byteToCheck & (1 << bitPosition)) != 0;
  return bit ? 1 : 0;
}

List<int> decodeAndZlibDecompress(String lst) {
  final paddedBase64 = lst.padRight((lst.length + 3) & ~3, '=');
  final compressedBytes = base64Url.decode(paddedBase64);

  final zlib = ZLibCodec();
  final decompressedBytes = zlib.decode(compressedBytes);

  return decompressedBytes;
}

List<int> decodeAndGzibDecompress(String lst) {
  final paddedBase64 = lst.padRight((lst.length + 3) & ~3, '=');
  final compressedBytes = base64Url.decode(paddedBase64);

  final gzib = GZipCodec();
  final decompressedBytes = gzib.decode(compressedBytes);

  return decompressedBytes;
}
