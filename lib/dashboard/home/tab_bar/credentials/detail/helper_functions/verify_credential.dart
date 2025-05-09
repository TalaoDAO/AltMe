import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

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
  final compressedBytes = decodeEncodedList(lst);

  final zlib = ZLibCodec();
  final decompressedBytes = zlib.decode(compressedBytes);

  return decompressedBytes;
}

Uint8List decodeEncodedList(String lst) {
  var output = lst;
  while (output.length % 4 != 0) {
    // ignore: use_string_buffers
    output += '=';
  }
  return base64Url.decode(output);
}

List<int> decodeAndGzibDecompress(String lst) {
  final compressedBytes = decodeEncodedList(lst);

  final gzib = GZipCodec();
  final decompressedBytes = gzib.decode(compressedBytes);

  return decompressedBytes;
}
