// ignore_for_file: avoid_dynamic_calls, public_member_api_docs

import 'dart:convert';

import 'package:bip32/bip32.dart' as bip32;
import 'package:bip39/bip39.dart' as bip393;
import 'package:dio/dio.dart';
import 'package:ebsi/src/issuer_token_parameters.dart';
import 'package:ebsi/src/token_parameters.dart';
import 'package:ebsi/src/verifier_token_parameters.dart';
import 'package:flutter/foundation.dart';
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
  Future<String> privateKeyFromMnemonic({required String mnemonic}) async {
    final seed = bip393.mnemonicToSeed(mnemonic);

    final rootKey = bip32.BIP32.fromSeed(seed); //Instance of 'BIP32'
    final child = rootKey.derivePath(
      "m/44'/5467'/0'/1'",
    ); //Instance of 'BIP32'
    final Iterable<int> iterable = child.privateKey!;
    final seedBytes = Uint8List.fromList(List.from(iterable));

    final key = jwkFromSeed(
      seedBytes: seedBytes,
    );

    return jsonEncode(key);
  }

  /// create JWK from seed
  Map<String, String> jwkFromSeed({required Uint8List seedBytes}) {
    // generate JWK for secp256k from bip39 mnemonic
    // see https://iancoleman.io/bip39/
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
    /// we are using P-256K for dart library conformance which is
    /// the same as secp256k1
    final jwk = {
      'crv': 'P-256K',
      'd': d,
      'kty': 'EC',
      'x': x,
      'y': y,
    };
    return jwk;
  }

  /// https://www.rfc-editor.org/rfc/rfc7638
  /// Received JWT is already filtered on required members
  /// Received JWT keys are already sorted in lexicographic order

  /// Verifiy is url is first EBSI url, starting point to get a credential
  @visibleForTesting
  bool isEbsiInitiateIssuanceUrl(String url) {
    if (url.startsWith('openid://initiate_issuance?')) {
      return true;
    }
    return false;
  }

  /// getAuthorizationUriForIssuer
  Future<Uri> getAuthorizationUriForIssuer(
    String openIdRequest,
    String redirectUrl,
  ) async {
    if (isEbsiInitiateIssuanceUrl(openIdRequest)) {
      try {
        final jsonPath = JsonPath(r'$..authorization_endpoint');
        final openidConfigurationUrl =
            '${getIssuerFromOpenidRequest(openIdRequest)}/.well-known/openid-configuration';

        final openidConfigurationResponse =
            await client.get<String>(openidConfigurationUrl);
        final authorizationEndpoint = jsonPath
            .readValues(jsonDecode(openidConfigurationResponse.data!))
            .first as String;
        final authorizationRequestParemeters =
            getAuthorizationRequestParemeters(openIdRequest, redirectUrl);

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

  @visibleForTesting
  Map<String, dynamic> getAuthorizationRequestParemeters(
    String openIdRequest,
    String redirectUrl,
  ) {
    final openIdRequestUri = Uri.parse(openIdRequest);
    final credentialType = openIdRequestUri.queryParameters['credential_type'];
    final opState = openIdRequestUri.queryParameters['op_state'];
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
      'state': opState,
      'op_state': opState
    };
    return myRequest;
  }

  @visibleForTesting
  String getIssuerFromOpenidRequest(String openIdRequest) {
    final openIdRequestUri = Uri.parse(openIdRequest);
    final issuer = openIdRequestUri.queryParameters['issuer'] ?? '';
    return issuer;
  }

  /// Extract credential_type's Url from openid request
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
    Uri credentialRequestUri,
    String? mnemonic,
    String? privateKey,
  ) async {
    final issuer = getIssuer(credentialRequestUri);

    final tokenData = buildTokenData(credentialRequestUri);

    final openidConfigurationUrl = '$issuer/.well-known/openid-configuration';

    final openidConfigurationResponse =
        await client.get<Map<String, dynamic>>(openidConfigurationUrl);

    final tokenEndPoint = readTokenEndPoint(openidConfigurationResponse);

    final response = await getToken(tokenEndPoint, tokenData);

    final credentialData = await buildCredentialData(
      response as Map<String, dynamic>,
      mnemonic,
      privateKey,
      issuer,
      credentialRequestUri,
    );

    final credentialEndpoint =
        readCredentialEndpoint(openidConfigurationResponse);

    final credentialHeaders = buildCredentialHeaders(response);

    final dynamic credentialResponse = await client.post<dynamic>(
      credentialEndpoint,
      options: Options(headers: credentialHeaders),
      data: credentialData,
    );
    return credentialResponse.data;
  }

  Map<String, dynamic> buildTokenData(Uri credentialRequestUri) {
    late Map<String, dynamic> tokenData;

    final preAuthorizedCode =
        credentialRequestUri.queryParameters['pre-authorized_code'];
    if (preAuthorizedCode != null) {
      tokenData = <String, dynamic>{
        'pre-authorized_code': preAuthorizedCode,
        'grant_type': 'urn:ietf:params:oauth:grant-type:pre-authorized_code',
      };
    } else {
      final issuerAndCode = credentialRequestUri.queryParameters['issuer'];
      final issuerAndCodeUri = Uri.parse(issuerAndCode!);
      final code = issuerAndCodeUri.queryParameters['code'];
      tokenData = <String, dynamic>{
        'code': code,
        'grant_type': 'authorization_code',
      };
    }
    return tokenData;
  }

  String getIssuer(Uri credentialRequestUri) {
    late String issuer;

    final preAuthorizedCode =
        credentialRequestUri.queryParameters['pre-authorized_code'];

    if (preAuthorizedCode != null) {
      issuer = credentialRequestUri.queryParameters['issuer']!;
    } else {
      final issuerAndCode = credentialRequestUri.queryParameters['issuer'];
      final issuerAndCodeUri = Uri.parse(issuerAndCode!);
      issuer =
          '${issuerAndCodeUri.scheme}://${issuerAndCodeUri.authority}${issuerAndCodeUri.path}';
    }

    return issuer;
  }

  String readTokenEndPoint(
    Response<Map<String, dynamic>> openidConfigurationResponse,
  ) {
    final jsonPath = JsonPath(r'$..token_endpoint');
    final tokenEndPoint =
        jsonPath.readValues(openidConfigurationResponse.data).first as String;
    return tokenEndPoint;
  }

  Future<Map<String, dynamic>> getPrivateKey(
    String? mnemonic,
    String? privateKey,
  ) async {
    late Map<String, dynamic> private;

    if (mnemonic != null) {
      private = jsonDecode(await privateKeyFromMnemonic(mnemonic: mnemonic))
          as Map<String, dynamic>;
    } else {
      private = jsonDecode(privateKey!) as Map<String, dynamic>;
    }

    return private;
  }

  Future<Map<String, dynamic>> buildCredentialData(
    Map<String, dynamic> response,
    String? mnemonic,
    String? privateKey,
    String issuer,
    Uri credentialRequestUri,
  ) async {
    final nonce = response['c_nonce'] as String;

    final private = await getPrivateKey(mnemonic, privateKey);

    final issuerTokenParameters = IssuerTokenParameters(private, issuer);
    final jwt = await getIssuerJwt(issuerTokenParameters, nonce);
    final credentialType =
        credentialRequestUri.queryParameters['credential_type'];
    final credentialData = <String, dynamic>{
      'type': credentialType,
      'format': 'jwt_vc',
      'proof': {'proof_type': 'jwt', 'jwt': jwt}
    };
    return credentialData;
  }

  String readCredentialEndpoint(
    Response<Map<String, dynamic>> openidConfigurationResponse,
  ) {
    final jsonPathCredential = JsonPath(r'$..credential_endpoint');

    final credentialEndpoint = jsonPathCredential
        .readValues(openidConfigurationResponse.data)
        .first as String;
    return credentialEndpoint;
  }

  Map<String, dynamic> buildCredentialHeaders(dynamic response) {
    final accessToken = response['access_token'] as String;
    final credentialHeaders = <String, dynamic>{
      // 'Conformance': conformance,
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };
    return credentialHeaders;
  }

  @visibleForTesting
  Future<String> getIssuerJwt(
    IssuerTokenParameters tokenParameters,
    String nonce,
  ) async {
    final payload = {
      'iss': tokenParameters.didKey,
      'nonce': nonce,
      'iat': DateTime.now().microsecondsSinceEpoch,
      'aud': tokenParameters.issuer
    };
    final jwt = generateToken(payload, tokenParameters);
    return jwt;
  }

  @visibleForTesting
  Future<dynamic> getToken(
    String tokenEndPoint,
    Map<String, dynamic> tokenData,
  ) async {
    try {
      /// getting token
      final tokenHeaders = <String, dynamic>{
        'Content-Type': 'application/x-www-form-urlencoded'
      };

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

  Future<void> sendPresentation(
    Uri uri,
    List<String> credentialsToBePresented,
    String? mnemonic,
    String? privateKey,
  ) async {
    final private = await getPrivateKey(mnemonic, privateKey);

    final tokenParameters = VerifierTokenParameters(
      private,
      uri,
      credentialsToBePresented,
    );

    // structures
    final verifierIdToken = await getIdToken(tokenParameters);

    /// build vp token

    final vpToken = await getVpToken(tokenParameters);

    final responseHeaders = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    final responseData = <String, dynamic>{
      'id_token': verifierIdToken,
      'vp_token': vpToken
    };
    try {
      final presentationResponse = await client.post<dynamic>(
        uri.queryParameters['redirect_uri']!,
        options: Options(headers: responseHeaders),
        data: responseData,
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  @visibleForTesting
  Future<String> getVpToken(
    VerifierTokenParameters tokenParameters,
  ) async {
    final iat = (DateTime.now().millisecondsSinceEpoch / 1000).round();
    final vpTokenPayload = {
      'iat': iat,
      'jti': 'http://example.org/presentations/talao/01',
      'nbf': iat - 10,
      'aud': tokenParameters.audience,
      'exp': iat + 1000,
      'sub': tokenParameters.didKey,
      'iss': tokenParameters.didKey,
      'vp': {
        '@context': ['https://www.w3.org/2018/credentials/v1'],
        'id': 'http://example.org/presentations/talao/01',
        'type': ['VerifiablePresentation'],
        'holder': tokenParameters.didKey,
        'verifiableCredential': [jsonEncode(tokenParameters.jwtsOfCredentials)]
      },
      'nonce': tokenParameters.nonce
    };
    final verifierVpJwt = generateToken(vpTokenPayload, tokenParameters);
    return verifierVpJwt;
  }

  @visibleForTesting
  String generateToken(
    Map<String, Object> vpTokenPayload,
    TokenParameters tokenParameters,
  ) {
    final vpVerifierClaims = JsonWebTokenClaims.fromJson(vpTokenPayload);
    // create a builder, decoding the JWT in a JWS, so using a
    // JsonWebSignatureBuilder
    final vpBuilder = JsonWebSignatureBuilder()
      // set the content
      ..jsonContent = vpVerifierClaims.toJson()
      ..setProtectedHeader('typ', 'JWT')
      ..setProtectedHeader('alg', tokenParameters.alg)
      ..setProtectedHeader('jwk', tokenParameters.publicJWK)
      ..setProtectedHeader('kid', tokenParameters.kid)

      // add a key to sign, can only add one for JWT
      ..addRecipient(
        JsonWebKey.fromJson(tokenParameters.privateKey),
        algorithm: tokenParameters.alg,
      );
    // build the jws
    final vpJws = vpBuilder.build();

    // output the compact serialization
    final verifierVpJwt = vpJws.toCompactSerialization();
    return verifierVpJwt;
  }

  @visibleForTesting
  Future<String> getIdToken(
    VerifierTokenParameters tokenParameters,
  ) async {
    /// build id token
    final payload = {
      'iat': DateTime.now().microsecondsSinceEpoch,
      'aud': tokenParameters.audience, // devrait être verifier
      'exp': DateTime.now().microsecondsSinceEpoch + 1000,
      'sub': tokenParameters.didKey,
      'iss': 'https://self-issued.me/v2',
      'nonce': tokenParameters.nonce,
      '_vp_token': {
        'presentation_submission': {
          'definition_id': 'conformance_mock_vp_request',
          'id': 'VA presentation Talao',
          'descriptor_map': [
            {
              'id': 'conformance_mock_vp',
              'format': 'jwt_vp',
              'path': r'$',
            }
          ]
        }
      }
    };
    final verifierIdJwt = generateToken(payload, tokenParameters);
    return verifierIdJwt;
  }

  Future<String> getDidFromMnemonic(
    String? mnemonic,
    String? privateKey,
  ) async {
    final private = await getPrivateKey(mnemonic, privateKey);

    final tokenParameters = TokenParameters(private);
    return tokenParameters.didKey;
  }
}
