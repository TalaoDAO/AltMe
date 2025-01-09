import 'dart:convert';

import 'package:bs58/bs58.dart';

Map<String, dynamic> publicKeyBase58ToPublicJwk(String publicKeyBase58) {
  ///step 1 : change the publicKeyBase58 format from base58 to base64 :
  ///decode base58 then encode in base64 urlsafe

  final pubKey =
      base64UrlEncode(base58.decode(publicKeyBase58)).replaceAll('=', '');

  ///step 2 : create the JWK for the "type": "Ed
  ///25519VerificationKey2018",
  ///it is a edDSA key
  final jwk = {
    'crv': 'Ed25519',
    'kty': 'OKP',
    'x': pubKey,
  };
  return jwk;
}
