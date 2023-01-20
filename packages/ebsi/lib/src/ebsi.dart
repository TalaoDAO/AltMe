import 'dart:convert';
import 'dart:typed_data';

import 'package:bip32/bip32.dart' as bip32;
import 'package:bip39/bip39.dart' as bip393;
import 'package:dart_bip32_bip44/dart_bip32_bip44.dart';
import 'package:dart_web3/crypto.dart';
import 'package:dart_web3/dart_web3.dart';
import 'package:dio/dio.dart';
import 'package:ebsi/src/config.dart';
import 'package:ed25519_hd_key/ed25519_hd_key.dart';
import 'package:fast_base58/fast_base58.dart';
import 'package:hex/hex.dart';
import 'package:jose/jose.dart';
import 'package:secp256k1/secp256k1.dart';
// ignore: implementation_imports
import 'package:tezart/src/crypto/crypto.dart' as crypto hide Prefixes;
// ignore: implementation_imports, unnecessary_import
import 'package:tezart/src/crypto/crypto.dart' show Prefixes;
import 'package:tezart/tezart.dart';

/// {@template ebsi}
/// EBSI wallet compliance
/// {@endtemplate}
class Ebsi {
  /// {@macro ebsi}
  const Ebsi({required this.client});
  final Dio client;

  /// create JWK from mnemonic
  Future<String> jwkFromMnemonic({
    required String mnemonic,
  }) async {
    //notice photo opera keen climb agent soft parrot best joke field devote
    final seed = bip393.mnemonicToSeed(mnemonic);

    late Uint8List seedBytes;

    /// m/44'/5467'/0'/0' is already used for did:key in Altme project
    final child = await ED25519_HD_KEY.derivePath("m/44'/5467'/0'/1'", seed);
    seedBytes = Uint8List.fromList(child.key);

    final key = jwkFromSeed(
      seedBytes: seedBytes,
    );
    return jsonEncode(key);
  }

  /// create JWK from seed
  Map<String, String> jwkFromSeed({
    required Uint8List seedBytes,
  }) {
    final epk = HEX.encode(seedBytes);
    final pk = PrivateKey.fromHex(epk); //Instance of 'PrivateKey'
    final pub = pk.publicKey.toHex().substring(2);
    final ad = HEX.decode(epk);
    final d = base64Url.encode(ad).substring(0, 43);
    // remove "=" padding 43/44
    final mx = pub.substring(0, 64);
    // first 32 bytes
    final ax = HEX.decode(mx);
    final x = base64Url.encode(ax).substring(0, 43);
    // remove "=" padding 43/44
    final my = pub.substring(64);
    // last 32 bytes
    final ay = HEX.decode(my);
    final y = base64Url.encode(ay).substring(0, 43);
    // ATTENTION !!!!!
    // alg "ES256K-R" for did:ethr
    // and did:tz2 "EcdsaSecp256k1RecoverySignature2020"
    // use alg "ES256K" for did:key
    final jwk = {
      'kty': 'EC',
      'crv': 'secp256k1',
      'd': d,
      'x': x,
      'y': y,
      'alg': 'ES256K'
    };
    return jwk;
  }

  /// getDidFromJwk
  String getDidFromJwk(Map<String, String> jwk) {
    final jwkKey = JsonWebKey.fromJson(jwk);

    final thumbprint = jwkKey.toBytes();

    final encodedAddress = Base58Encode([2, ...thumbprint]);
    final decodedAddress = Base58Decode(encodedAddress);
    return 'did:ebsi:z$encodedAddress';
  }

  /// Verifiy is url is first EBSI url, starting point to get a credential
  ///
  static bool isEbsiUrl(String url) {
    if (url.startsWith('openid://initiate_issuance?')) {
      return true;
    }
    return false;
  }

  ///
  Future<void> getAuthorizationFromIssuer(
    String authorizationUrl,
    String credentialType,
  ) async {
    final uri = Uri.parse(authorizationUrl);
    final headers = {'Content-Type': 'application/json'};
    final myRequest = <String, dynamic>{
      'scope': 'openid',
      'client_id': redirectUri,
      'response_type': 'code',
      'authorization_details': jsonEncode([
        {
          'type': 'openid_credential',
          'credential_type': credentialType,
          'format': 'jwt_vc'
        }
      ]),
      'redirect_uri': redirectUri,
      'state': '1234'
    };

    try {
      final Uri authorizationUri = Uri.parse(authorizationUrl);
      authorizationUri.replace(queryParameters: myRequest);

      // final Uri authorizationUri = Uri(
      //   scheme: 'https',
      //   path: '/conformance/v2/issuer-mock/authorize',
      //   queryParameters: myRequest,
      //   host: 'api-conformance.ebsi.eu',
      // );
      final dynamic authorizationResponse = await client.get(authorizeUrl,
          headers: headers, queryParameters: myRequest);
      print('got authorization');
      // Should get code from authorization response or this callback system
      /// we should receive something through deepLink ?

    } catch (e) {
      if (e is NetworkException) {
        if (e.data != null) {
          if (e.data['detail'] != null) {
            final String error = e.data['detail'] as String;
            final codeSplit = error.split('code=');
            code = codeSplit[1];
          }
        }
      }
      print('Lokks like wa can get code from here');
    }
  }

  /// Extract credential_type's Url from openid request
  ///
  ///
  String getCredentialRequest(String openidRequest) {
    var credentialType = '';
    try {
      final uri = Uri.parse(openidRequest);
      if (uri.scheme == 'openid') {
        credentialType = uri.queryParameters['credential_type'] ?? '';
      }
    } catch (e) {
      credentialType = '';
    }
    print('openIdrequest: $openidRequest');
    return credentialType;
  }

  String getIssuerRequest(String openidRequest) {
    var issuer = '';
    try {
      final uri = Uri.parse(openidRequest);
      if (uri.scheme == 'openid') {
        issuer = uri.queryParameters['issuer'] ?? '';
      }
    } catch (e) {
      issuer = '';
    }
    return issuer;
  }

  /// Retreive credential_type from url
  Future<dynamic> getCredentialType(
    String credentialTypeRequest,
  ) async {
    final dynamic response =
        await client.get<Map<String, dynamic>>(credentialTypeRequest);
    final data = response is String ? jsonDecode(response) : response;

    return data;
  }
}
