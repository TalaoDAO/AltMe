// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';
import 'dart:typed_data';

import 'package:bip39/bip39.dart' as bip393;
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:ed25519_hd_key/ed25519_hd_key.dart';
import 'package:fast_base58/fast_base58.dart';
// ignore: depend_on_referenced_packages
import 'package:hex/hex.dart';
import 'package:jose/jose.dart';
import 'package:json_path/json_path.dart';
import 'package:secp256k1/secp256k1.dart';
// ignore: implementation_imports
// ignore: implementation_imports, unnecessary_import

/// {@template ebsi}
/// EBSI wallet compliance
/// {@endtemplate}
class Ebsi {
  /// {@macro ebsi}
  Ebsi(this.client);

  ///
  final Dio client;

  /// create JWK from mnemonic
  Future<String> privateFromMnemonic({
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
    final jwk = {
      'alg': 'ES256K',
      'crv': 'P-256K',
      'd': d,
      'kty': 'EC',
      'x': x,
      'y': y,
    };
    // final jwk = {
    //   'crv': 'P-256K',
    //   'd': d,
    //   'kty': 'EC',
    //   'x': x,
    //   'y': y,
    // };
    return jwk;
  }

  /// getDidFromJwk
  String getDidFromPrivate(Map<String, dynamic> jwk) {
    final thumbprint = _thumbprint(jwk);

    final encodedAddress = Base58Encode([2, ...thumbprint.bytes]);
    return 'did:ebsi:z$encodedAddress';
  }

  /// getKidFromJwk
  String getKidFromJwk(Map<String, dynamic> private) {
    final firstPart = getDidFromPrivate(private);

    final sha256Digest = _thumbprint(private);
    final lastPart = Base58Encode(sha256Digest.bytes);

    return '$firstPart#$lastPart';
  }

  Digest _thumbprint(Map<String, dynamic> jwk) {
    final jsonString = jsonEncode(jwk);
    final bytesToHash = utf8.encode(jsonString);
    final sha256Digest = sha256.convert(bytesToHash);
    return sha256Digest;
  }

  /// Verifiy is url is first EBSI url, starting point to get a credential
  ///
  static bool _isEbsiInitiateIssuanceUrl(String url) {
    if (url.startsWith('openid://initiate_issuance?')) {
      return true;
    }
    return false;
  }

  ///
  Future<Uri> getAuthorizationUriForIssuer(
    String openIdRequest,
    String redirectUrl,
  ) async {
    if (_isEbsiInitiateIssuanceUrl(openIdRequest)) {
      try {
        final jsonPath = JsonPath(r'$..authorization_endpoint');
        final openidConfigurationUrl =
            '${_getIssuerFromOpenidRequest(openIdRequest)}/.well-known/openid-configuration';
        final openidConfigurationResponse =
            await client.get<String>(openidConfigurationUrl);
        final authorizationEndpoint = jsonPath
            .readValues(openidConfigurationResponse.data)
            .first as String;
        final authorizationRequestParemeters =
            _getAuthorizationRequestParemeters(openIdRequest, redirectUrl);

        final url = Uri.parse(authorizationEndpoint);
        final authorizationUri =
            Uri.https(url.authority, url.path, authorizationRequestParemeters);
        return authorizationUri;
      } catch (e) {
        throw Exception(e);
      }
    }
    throw Exception('Not a valid openid url to initiate issuance');
  }

  Map<String, dynamic> _getAuthorizationRequestParemeters(
    String openIdRequest,
    String redirectUrl,
  ) {
    final openIdRequestUri = Uri.parse(openIdRequest);
    final credentialType = openIdRequestUri.queryParameters['credential_type'];
    final issuerState = openIdRequestUri.queryParameters['issuer_state'];
    final issuer = openIdRequestUri.queryParameters['issuer'];
    final myRequest = <String, dynamic>{
      'scope': 'openid',
      'client_id': redirectUrl,
      'response_type': 'code',
      'authorization_details': jsonEncode([
        {
          'type': 'openid_credential',
          'credential_type': credentialType,
          'format': 'jwt_vc'
        }
      ]),
      'redirect_uri':
          '$redirectUrl?credential_type=$credentialType&issuer=$issuer',
      'state': issuerState,
      'issuer_state': issuerState
    };
    return myRequest;
  }

  String _getIssuerFromOpenidRequest(String openIdRequest) {
    final openIdRequestUri = Uri.parse(openIdRequest);
    final issuer = openIdRequestUri.queryParameters['issuer'] ?? '';
    return issuer;
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
    return credentialType;
  }

  /// extract issuer from initial openid request
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
  Future<dynamic> getCredential(
    Uri credentialRequestReceived,
    String mnemonic,
  ) async {
    /// getting token
    final tokenHeaders = <String, dynamic>{
      'Content-Type': 'application/x-www-form-urlencoded'
    };

    final credentialType =
        credentialRequestReceived.queryParameters['credential_type'];
    final issuerAndCode = credentialRequestReceived.queryParameters['issuer'];
    final issuerAndCodeUri = Uri.parse(issuerAndCode!);
    final code = issuerAndCodeUri.queryParameters['code'];
    final issuer =
        '${issuerAndCodeUri.scheme}://${issuerAndCodeUri.authority}${issuerAndCodeUri.path}';
    final jsonPath = JsonPath(r'$..token_endpoint');
    final openidConfigurationUrl = '$issuer/.well-known/openid-configuration';
    final openidConfigurationResponse =
        await client.get<String>(openidConfigurationUrl);
    final tokenEndPoint =
        jsonPath.readValues(openidConfigurationResponse.data).first as String;

    final tokenData = <String, dynamic>{
      'code': code,
      'grant_type': 'authorization_code',
      'redirect_uri': credentialRequestReceived
    };
    final response = await _getToken(tokenEndPoint, tokenHeaders, tokenData);
    final accessToken = response.data['access_token'] as String;
    final cNonce = response.data['c_nonce'] as String;

    /// preparation before getting credential
    final jwt = await _getJwt(cNonce, issuer, mnemonic);

    final jsonPathCredential = JsonPath(r'$..credential_endpoint');
    final credentialEndpoint = jsonPathCredential
        .readValues(openidConfigurationResponse.data)
        .first as String;

    final credentialHeaders = <String, dynamic>{
      // 'Conformance': conformance,
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };

    final credentialData = <String, dynamic>{
      'type': credentialType,
      'format': 'jwt_vc',
      'proof': {'proof_type': 'jwt', 'jwt': jwt}
    };

    final dynamic credentialResponse = await client.post<Map<String, dynamic>>(
      credentialEndpoint,
      options: Options(headers: credentialHeaders),
      data: credentialData,
    );

    return credentialResponse.data;
  }

  Future<String> _getJwt(String cNonce, String issuer, String mnemonic) async {
    final private = jsonDecode(await privateFromMnemonic(mnemonic: mnemonic))
        as Map<String, dynamic>;

    final public = Map.of(private)..removeWhere((key, value) => key == 'd');
    final did = getDidFromPrivate(private);
    final kid = getKidFromJwk(private);
    public.addAll({'kid': kid});
    final alg = private['crv'] == 'P-256' ? 'ES256' : 'ES256K';

    final payload = {
      'iss': did,
      'nonce': cNonce,
      'iat': DateTime.now().microsecondsSinceEpoch,
      'aud': issuer
    };
    final claims = JsonWebTokenClaims.fromJson(payload);
    // create a builder, decoding the JWT in a JWS, so using a
    // JsonWebSignatureBuilder
    final builder = JsonWebSignatureBuilder()
      ..jsonContent = claims.toJson()
      ..setProtectedHeader('typ', 'JWT')
      ..setProtectedHeader('alg', alg)
      ..setProtectedHeader('jwk', public)
      ..setProtectedHeader('kid', kid)
      // add a key to sign, can only add one for JWT
      ..addRecipient(
        JsonWebKey.fromJson(private),
        algorithm: alg,
      );
    // build the jws
    final jws = builder.build();

    // output the compact serialization
    final jwt = jws.toCompactSerialization();
    return jwt;
  }

  Future<dynamic> _getToken(
    String tokenEndPoint,
    Map<String, dynamic> tokenHeaders,
    Map<String, dynamic> tokenData,
  ) async {
    try {
      final dynamic tokenResponse = await client.post<Map<String, dynamic>>(
        tokenEndPoint,
        options: Options(headers: tokenHeaders),
        data: tokenData,
      );
      return tokenResponse.data;
    } catch (e) {
      throw Exception(e);
    }
  }

  ///
  Future<dynamic> getCredentialWithPreAuthorizedCode(
    Uri credentialRequestReceived,
    String mnemonic,
  ) async {
    /// getting token
    final tokenHeaders = <String, dynamic>{
      'Content-Type': 'application/x-www-form-urlencoded'
    };

    final credentialType =
        credentialRequestReceived.queryParameters['credential_type'];
    final issuer = credentialRequestReceived.queryParameters['issuer'];
    final preAuthorizedCode =
        credentialRequestReceived.queryParameters['pre-authorized_code'];
    final jsonPath = JsonPath(r'$..token_endpoint');
    final openidConfigurationUrl = '$issuer/.well-known/openid-configuration';
    final openidConfigurationResponse =
        await client.get<Map<String, dynamic>>(openidConfigurationUrl);
    final tokenEndPoint =
        jsonPath.readValues(openidConfigurationResponse.data).first as String;

    final tokenData = <String, dynamic>{
      'pre-authorized_code': preAuthorizedCode,
      'grant_type': 'urn:ietf:params:oauth:grant-type:pre-authorized_code',
    };

    final response = await _getToken(tokenEndPoint, tokenHeaders, tokenData);
    final accessToken = response['access_token'] as String;
    final cNonce = response['c_nonce'] as String;

    /// preparation before getting credential
    final jwt = await _getJwt(cNonce, issuer!, mnemonic);

    final jsonPathCredential = JsonPath(r'$..credential_endpoint');
    final credentialEndpoint = jsonPathCredential
        .readValues(openidConfigurationResponse.data)
        .first as String;

    final credentialHeaders = <String, dynamic>{
      // 'Conformance': conformance,
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };

    final credentialData = <String, dynamic>{
      'type': credentialType,
      'format': 'jwt_vc',
      'proof': {'proof_type': 'jwt', 'jwt': jwt}
    };

    final dynamic credentialResponse = await client.post<Map<String, dynamic>>(
      credentialEndpoint,
      options: Options(headers: credentialHeaders),
      data: credentialData,
    );

    return credentialResponse.data;
  }
}
