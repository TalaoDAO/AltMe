import 'dart:convert';

import 'package:crypto/crypto.dart';

String sh256Hash(String text) {
    final bytes = utf8.encode(text);
    final digest = sha256.convert(bytes);
    return base64Url.encode(digest.bytes).replaceAll('=', '');
  }

  String getDisclosure(String content) {
    final disclosure =
        base64Url.encode(utf8.encode(content)).replaceAll('=', '');

    return disclosure;
  }

  String sh256HashOfContent(String content) {
    final disclosure = getDisclosure(content);
    final hash = sh256Hash(disclosure);
    return hash;
  }
