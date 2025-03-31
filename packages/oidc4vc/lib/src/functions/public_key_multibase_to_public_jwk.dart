import 'dart:convert';

import 'package:bs58/bs58.dart';

Map<String, dynamic> publicKeyMultibaseToPublicJwk(String publicKeyMultibase) {
  if (!publicKeyMultibase.startsWith('z')) {
    throw Exception(
      "Only Base58-btc encoding (starting with 'z') is supported.",
    );
  }

  // Decode Base58 (removing "z" prefix)
  final decodedBytes = base58.decode(publicKeyMultibase.substring(1));

  // Identify the key type based on prefix
  String curve;
  List<int> keyData;
  if (decodedBytes.sublist(0, 2).toString() == [0x04, 0x88].toString()) {
    // secp256k1 key
    keyData = decodedBytes.sublist(2);
    curve = 'secp256k1';
  } else if (decodedBytes.sublist(0, 2).toString() == [0xed, 0x01].toString()) {
    // Ed25519 key
    keyData = decodedBytes.sublist(2);
    curve = 'Ed25519';
  } else {
    throw Exception('Unsupported key type.');
  }

  // Convert to JWK format
  late Map<String, dynamic> jwk;
  if (curve == 'secp256k1') {
    final x = keyData.sublist(0, 32);
    final y = keyData.sublist(32);
    jwk = {
      'kty': 'EC',
      'crv': 'secp256k1',
      'x': base64Url.encode(x).replaceAll('=', ''),
      'y': base64Url.encode(y).replaceAll('=', ''),
    };
  } else if (curve == 'Ed25519') {
    jwk = {
      'kty': 'OKP',
      'crv': 'Ed25519',
      'x': base64Url.encode(keyData).replaceAll('=', ''),
    };
  } else {
    throw Exception('Unsupported key type.');
  }

  return jwk;
}
