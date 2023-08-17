// ignore_for_file: avoid_dynamic_calls, public_member_api_docs

import 'dart:convert';

import 'package:bip32/bip32.dart' as bip32;
import 'package:bip39/bip39.dart' as bip393;
import 'package:cryptography/cryptography.dart' as cryptography;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hex/hex.dart';
import 'package:jose/jose.dart';
import 'package:json_path/json_path.dart';
import 'package:oidc4vc/src/iodc4vc_model.dart';
import 'package:oidc4vc/src/issuer_token_parameters.dart';
import 'package:oidc4vc/src/token_parameters.dart';
import 'package:oidc4vc/src/verification_type.dart';
import 'package:oidc4vc/src/verifier_token_parameters.dart';
import 'package:secp256k1/secp256k1.dart';
import 'package:uuid/uuid.dart';

/// {@template ebsi}
/// EBSI wallet compliance
/// {@endtemplate}
class OIDC4VC {
  /// {@macro ebsi}
  OIDC4VC({
    required this.client,
    required this.oidc4vcModel,
  });

  ///
  final Dio client;
  final OIDC4VCModel oidc4vcModel;

  /// create JWK from mnemonic
  Future<String> privateKeyFromMnemonic({
    required String mnemonic,
    required int index,
  }) async {
    final seed = bip393.mnemonicToSeed(mnemonic);

    final rootKey = bip32.BIP32.fromSeed(seed); //Instance of 'BIP32'
    final child = rootKey.derivePath(
      "m/44'/5467'/0'/$index'",
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
    /// we were using P-256K for dart library conformance which is
    /// the same as secp256k1, but we are using secp256k1 now
    final jwk = {
      'crv': 'secp256k1',
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

  /// getAuthorizationUriForIssuer
  Future<Uri> getAuthorizationUriForIssuer(
    String openIdRequest,
    String redirectUrl,
  ) async {
    if (openIdRequest.startsWith(oidc4vcModel.offerPrefix)) {
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

  String? nonce;
  String? accessToken;

  /// Retreive credential_type from url
  Future<dynamic> getCredential({
    required String issuer,
    required String credentialType,
    required String did,
    required String kid,
    required Uri credentialRequestUri,
    required List<String> credentialSupportedTypes,
    String? preAuthorizedCode,
    String? mnemonic,
    String? privateKey,
  }) async {
    final kIssuer = getIssuer(
      preAuthorizedCode: preAuthorizedCode,
      issuer: issuer,
      credentialRequestUri: credentialRequestUri,
    );

    final tokenData = buildTokenData(preAuthorizedCode, credentialRequestUri);

    final openidConfigurationUrl = '$kIssuer/.well-known/openid-configuration';

    final openidConfigurationResponse =
        await client.get<Map<String, dynamic>>(openidConfigurationUrl);

    final tokenEndPoint = readTokenEndPoint(openidConfigurationResponse);

    if (nonce == null || accessToken == null) {
      final response = await getToken(tokenEndPoint, tokenData);
      nonce = response['c_nonce'] as String;
      accessToken = response['access_token'] as String;
    }

    final private = await getPrivateKey(mnemonic, privateKey);

    final issuerTokenParameters = IssuerTokenParameters(
      private,
      did,
      kid,
      kIssuer,
    );

    if (nonce == null) throw Exception();

    final credentialData = await buildCredentialData(
      nonce: nonce!,
      issuerTokenParameters: issuerTokenParameters,
      credentialRequestUri: credentialRequestUri,
      openidConfigurationResponse: openidConfigurationResponse,
      credentialType: credentialType,
      credentialSupportedTypes: credentialSupportedTypes,
    );

    /// sign proof

    final credentialEndpoint =
        readCredentialEndpoint(openidConfigurationResponse);

    if (accessToken == null) throw Exception();

    final credentialHeaders = buildCredentialHeaders(accessToken!);

    final dynamic credentialResponse = await client.post<dynamic>(
      credentialEndpoint,
      options: Options(headers: credentialHeaders),
      data: credentialData,
    );

    nonce = credentialResponse.data['c_nonce'].toString();

    return credentialResponse.data;
  }

  void resetNonceAndAccessToken() {
    nonce = null;
    accessToken = null;
  }

  Map<String, dynamic> buildTokenData(
    String? preAuthorizedCode,
    Uri credentialRequestUri,
  ) {
    late Map<String, dynamic> tokenData;

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

  String getIssuer({
    required Uri credentialRequestUri,
    String? preAuthorizedCode,
    String? issuer,
  }) {
    if (preAuthorizedCode != null) {
      return issuer!;
    } else {
      final issuerAndCode = credentialRequestUri.queryParameters['issuer'];
      final issuerAndCodeUri = Uri.parse(issuerAndCode!);
      return '${issuerAndCodeUri.scheme}://${issuerAndCodeUri.authority}${issuerAndCodeUri.path}';
    }
  }

  Future<Response<Map<String, dynamic>>> getDidDocument(String didKey) async {
    try {
      if (didKey.startsWith('did:ebsi')) {
        final didDocument = await client.get<Map<String, dynamic>>(
          'https://api-pilot.ebsi.eu/did-registry/v3/identifiers/$didKey',
        );
        return didDocument;
      } else if (didKey.startsWith('did:web')) {
        final url = didWebToUrl(didKey);
        final didDocument = await client.get<Map<String, dynamic>>(url);
        return didDocument;
      } else {
        throw Exception();
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  String didWebToUrl(String didKey) {
    if (!didKey.startsWith('did:web:')) {
      throw const FormatException('Invalid DID format');
    }

    // Extract the path after 'did:web:'
    final didPath = didKey.substring('did:web:'.length);

    if (didPath.contains(':')) {
      final parts = didPath.split(':');
      final domain = parts[0];
      final issuer = parts[1];

      final url = 'https://$domain/$issuer/did.json';
      return url;
    } else {
      final url = 'https://$didPath/.well-known/did.json';
      return url;
    }
  }

  String readTokenEndPoint(
    Response<Map<String, dynamic>> openidConfigurationResponse,
  ) {
    final jsonPath = JsonPath(r'$..token_endpoint');

    final tokenEndPoint =
        jsonPath.readValues(openidConfigurationResponse.data).first as String;
    return tokenEndPoint;
  }

  String readIssuerDid(
    Response<Map<String, dynamic>> openidConfigurationResponse,
  ) {
    final jsonPath = JsonPath(r'$..issuer');

    final data = jsonPath.read(openidConfigurationResponse.data).first.value
        as Map<String, dynamic>;

    return data['id'] as String;
  }

  Map<String, dynamic> readPublicKeyJwk(
    String holderKid,
    Response<Map<String, dynamic>> didDocumentResponse,
  ) {
    final jsonPath = JsonPath(r'$..verificationMethod');
    final data = (jsonPath.read(didDocumentResponse.data).first.value as List)
        .where(
          (dynamic e) => e['id'].toString() == holderKid,
        )
        .toList();

    final value = data.first['publicKeyJwk'];

    return jsonDecode(jsonEncode(value)) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getPrivateKey(
    String? mnemonic,
    String? privateKey,
  ) async {
    late Map<String, dynamic> private;

    var index = 1;

    if (oidc4vcModel.cryptographicSuitesSupported[0] == 'did:ebsi') {
      index = 1;
    } else if (oidc4vcModel.cryptographicSuitesSupported[0] == 'did:key') {
      index = 2;
    }

    if (mnemonic != null) {
      private = jsonDecode(
        await privateKeyFromMnemonic(
          mnemonic: mnemonic,
          index: index,
        ),
      ) as Map<String, dynamic>;
    } else {
      private = jsonDecode(privateKey!) as Map<String, dynamic>;
    }
    return private;
  }

  Future<Map<String, dynamic>> buildCredentialData({
    required String nonce,
    required IssuerTokenParameters issuerTokenParameters,
    required Uri credentialRequestUri,
    required Response<Map<String, dynamic>> openidConfigurationResponse,
    required String credentialType,
    required List<String> credentialSupportedTypes,
  }) async {
    final vcJwt = await getIssuerJwt(issuerTokenParameters, nonce);

    //final issuerDid = readIssuerDid(openidConfigurationResponse);

    // final isVerified = await verifyEncodedData(
    //   issuerDid: issuerDid,
    //   jwt: vcJwt,
    //   holderKid: issuerTokenParameters.kid,
    // );

    // if (isVerified == VerificationType.notVerified) {
    //   throw Exception('VERIFICATION_ISSUE');
    // }

    final credentialData = <String, dynamic>{
      'type': credentialType,
      'types': credentialSupportedTypes,
      'format': oidc4vcModel.issuerVcType,
      'proof': {
        'proof_type': 'jwt',
        'jwt': vcJwt,
      }
    };
    return credentialData;
  }

  Future<VerificationType> verifyEncodedData({
    required String issuerDid,
    required String issuerKid,
    required String jwt,
  }) async {
    try {
      final didDocument = await getDidDocument(issuerDid);
      final publicKeyJwk = readPublicKeyJwk(issuerKid, didDocument);

      final kty = publicKeyJwk['kty'].toString();

      if (publicKeyJwk['crv'] == 'secp256k1') {
        publicKeyJwk['crv'] = 'P-256K';
      }

      late final bool isVerified;
      if (kty == 'OKP') {
        var xString = publicKeyJwk['x'].toString();
        final paddingLength = 4 - (xString.length % 4);
        xString += '=' * paddingLength;

        final publicKeyBytes = base64Url.decode(xString);

        final publicKey = cryptography.SimplePublicKey(
          publicKeyBytes,
          type: cryptography.KeyPairType.ed25519,
        );

        isVerified = await verifyJwt(jwt, publicKey);
      } else {
        final jws = JsonWebSignature.fromCompactSerialization(jwt);

        // create a JsonWebKey for verifying the signature
        final keyStore = JsonWebKeyStore()
          ..addKey(
            JsonWebKey.fromJson(publicKeyJwk),
          );

        isVerified = await jws.verify(keyStore);
      }

      if (isVerified) {
        return VerificationType.verified;
      } else {
        return VerificationType.notVerified;
      }
    } catch (e) {
      return VerificationType.unKnown;
    }
  }

  Future<bool> verifyJwt(
    String vcJwt,
    cryptography.SimplePublicKey publicKey,
  ) async {
    final parts = vcJwt.split('.');

    final header = parts[0];
    final payload = parts[1];

    final message = utf8.encode('$header.$payload');

    // Get the signature
    var signatureString = parts[2];
    final paddingLength = 4 - (signatureString.length % 4);
    signatureString += '=' * paddingLength;
    final signatureBytes = base64Url.decode(signatureString);

    final signature =
        cryptography.Signature(signatureBytes, publicKey: publicKey);

    //verify signature
    final result =
        await cryptography.Ed25519().verify(message, signature: signature);

    return result;
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

  Map<String, dynamic> buildCredentialHeaders(String accessToken) {
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
      'iss': tokenParameters.did,
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

  Future<void> sendPresentation({
    required Uri uri,
    required String did,
    required String kid,
    required List<String> credentialsToBePresented,
    required String nonce,
    required bool isEBSIV2,
    String? mnemonic,
    String? privateKey,
  }) async {
    // TODO(bibash):  if the "request_uri" attribute exists,
    //wallet must do a GET to endpoint to get the request value as a
    //json. The wallet receives a JWT which must be verified wit the public key
    // of the verifier. It means that wallety must call the API to get teh DID
    //document from EBSI and extract the correct public key with teh kid.

    try {
      // final dynamic response =
      //     await client.get<dynamic>(uri.queryParameters['request_uri']!);

      final private = await getPrivateKey(mnemonic, privateKey);

      final tokenParameters = VerifierTokenParameters(
        private,
        did,
        kid,
        uri,
        credentialsToBePresented,
        nonce,
      );

      // structures
      final verifierIdToken = await getIdToken(
        tokenParameters: tokenParameters,
        isEBSIV2: isEBSIV2,
      );

      /// build vp token

      final vpToken = await getVpToken(tokenParameters);

      final responseHeaders = {
        'Content-Type': 'application/x-www-form-urlencoded',
      };

      final responseData = <String, dynamic>{
        'id_token': verifierIdToken,
        'vp_token': vpToken
      };

      await client.post<dynamic>(
        uri.queryParameters['redirect_uri']!,
        options: Options(headers: responseHeaders),
        data: responseData,
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<String> extractVpToken({
    required Uri uri,
    required List<String> credentialsToBePresented,
    required String did,
    required String kid,
    String? mnemonic,
    String? privateKey,
  }) async {
    try {
      final private = await getPrivateKey(mnemonic, privateKey);

      final tokenParameters = VerifierTokenParameters(
        private,
        did,
        kid,
        uri,
        credentialsToBePresented,
        uri.queryParameters['nonce'] ?? '',
      );

      final vpToken = await getVpToken(tokenParameters);

      return vpToken;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<String> extractIdToken({
    required Uri uri,
    required List<String> credentialsToBePresented,
    required String did,
    required String kid,
    required String nonce,
    required bool isEBSIV2,
    String? mnemonic,
    String? privateKey,
  }) async {
    try {
      final private = await getPrivateKey(mnemonic, privateKey);

      final tokenParameters = VerifierTokenParameters(
        private,
        did,
        kid,
        uri,
        credentialsToBePresented,
        nonce,
      );

      final verifierIdToken = await getIdToken(
        tokenParameters: tokenParameters,
        isEBSIV2: isEBSIV2,
      );

      return verifierIdToken;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> proveOwnershipOfDid({
    required Uri uri,
    required String did,
    required String kid,
    required String redirectUri,
    required String nonce,
    required bool isEBSIV2,
    String? mnemonic,
    String? privateKey,
  }) async {
    try {
      final private = await getPrivateKey(mnemonic, privateKey);

      final tokenParameters = VerifierTokenParameters(
        private,
        did,
        kid,
        uri,
        [],
        nonce,
      );

      // structures
      final verifierIdToken = await getIdToken(
        tokenParameters: tokenParameters,
        isEBSIV2: isEBSIV2,
      );

      final responseHeaders = {
        'Content-Type': 'application/x-www-form-urlencoded',
      };

      final responseData = <String, dynamic>{
        'id_token': verifierIdToken,
      };

      await client.post<dynamic>(
        redirectUri,
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
      'sub': tokenParameters.did,
      'iss': tokenParameters.did,
      'vp': {
        '@context': ['https://www.w3.org/2018/credentials/v1'],
        'id': 'http://example.org/presentations/talao/01',
        'type': ['VerifiablePresentation'],
        'holder': tokenParameters.did,
        'verifiableCredential': tokenParameters.jsonIdOrJwtList
      },
      'nonce': tokenParameters.nonce
    };

    final verifierVpJwt = generateToken(vpTokenPayload, tokenParameters);

    return verifierVpJwt;
  }

  String generateToken(
    Map<String, Object> vpTokenPayload,
    TokenParameters tokenParameters,
  ) {
    final vpVerifierClaims = JsonWebTokenClaims.fromJson(vpTokenPayload);
    // create a builder, decoding the JWT in a JWS, so using a
    // JsonWebSignatureBuilder
    final privateKey = Map<String, dynamic>.from(tokenParameters.privateKey);

    if (tokenParameters.privateKey['crv'] == 'secp256k1') {
      privateKey['crv'] = 'P-256K';
    }

    final key = JsonWebKey.fromJson(privateKey);

    final vpBuilder = JsonWebSignatureBuilder()
      // set the content
      ..jsonContent = vpVerifierClaims.toJson()
      ..setProtectedHeader('typ', 'JWT')
      ..setProtectedHeader('alg', tokenParameters.alg);

    if (oidc4vcModel.publicJWKNeeded) {
      // ignore: avoid_single_cascade_in_expression_statements
      vpBuilder..setProtectedHeader('jwk', tokenParameters.publicJWK);
    }

    vpBuilder
      ..setProtectedHeader('kid', tokenParameters.kid)

      // add a key to sign, can only add one for JWT
      ..addRecipient(key, algorithm: tokenParameters.alg);

    // build the jws
    final vpJws = vpBuilder.build();

    // output the compact serialization
    final verifierVpJwt = vpJws.toCompactSerialization();
    return verifierVpJwt;
  }

  @visibleForTesting
  Future<String> getIdToken({
    required VerifierTokenParameters tokenParameters,
    required bool isEBSIV2,
  }) async {
    final uuid1 = const Uuid().v4();
    final uuid2 = const Uuid().v4();

    /// build id token
    final payload = {
      'iat': DateTime.now().microsecondsSinceEpoch,
      'aud': tokenParameters.audience, // devrait être verifier
      'exp': DateTime.now().microsecondsSinceEpoch + 1000,
      'sub': tokenParameters.did,
      'iss': tokenParameters.did, //'https://self-issued.me/v2',
      'nonce': tokenParameters.nonce,
    };

    if (isEBSIV2) {
      payload['_vp_token'] = {
        'presentation_submission': {
          'definition_id': 'Altme defintion for EBSI project',
          'id': uuid1,
          'descriptor_map': [
            {
              'id': uuid2,
              'format': 'jwt_vp',
              'path': r'$',
            }
          ]
        }
      };
    }

    final verifierIdJwt = generateToken(payload, tokenParameters);
    return verifierIdJwt;
  }

  Future<String> getDidFromMnemonic(
    String? mnemonic,
    String? privateKey,
    String did,
    String kid,
  ) async {
    final private = await getPrivateKey(mnemonic, privateKey);

    final tokenParameters = TokenParameters(
      private,
      did,
      kid,
    );
    return tokenParameters.did;
  }

  Future<String?> getKid(
    String? mnemonic,
    String? privateKey,
    String did,
    String kid,
  ) async {
    final private = await getPrivateKey(mnemonic, privateKey);

    final tokenParameters = TokenParameters(
      private,
      did,
      kid,
    );
    return tokenParameters.kid;
  }
}
