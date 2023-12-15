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
import 'package:oidc4vc/oidc4vc.dart';
import 'package:oidc4vc/src/helper_function.dart';
import 'package:secp256k1/secp256k1.dart';
import 'package:uuid/uuid.dart';

/// {@template ebsi}
/// EBSI wallet compliance
/// {@endtemplate}
class OIDC4VC {
  /// {@macro ebsi}
  OIDC4VC();

  final Dio client = Dio();

  /// create JWK from mnemonic
  Future<String> privateKeyFromMnemonic({
    required String mnemonic,
    required int indexValue,
  }) async {
    final seed = bip393.mnemonicToSeed(mnemonic);

    final rootKey = bip32.BIP32.fromSeed(seed); //Instance of 'BIP32'
    final child = rootKey.derivePath(
      "m/44'/5467'/0'/$indexValue'",
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
      'd': d.replaceAll('=', ''),
      'kty': 'EC',
      'x': x.replaceAll('=', ''),
      'y': y.replaceAll('=', ''),
    };
    return jwk;
  }

  /// https://www.rfc-editor.org/rfc/rfc7638
  /// Received JWT is already filtered on required members
  /// Received JWT keys are already sorted in lexicographic order

  /// getAuthorizationUriForIssuer
  Future<Uri> getAuthorizationUriForIssuer({
    required List<dynamic> selectedCredentials,
    required String clientId,
    required String redirectUri,
    required String issuer,
    required String issuerState,
    required String nonce,
    required PkcePair pkcePair,
    required String state,
    required String authorizationEndPoint,
    required bool scope,
    required String tokenEndpointAuthMethod,
  }) async {
    try {
      final openIdConfiguration = await getOpenIdConfig(issuer);

      final authorizationEndpoint = await readAuthorizationEndPoint(
        openIdConfiguration: openIdConfiguration,
        issuer: issuer,
      );

      final authorizationRequestParemeters = getAuthorizationRequestParemeters(
        selectedCredentials: selectedCredentials,
        openIdConfiguration: openIdConfiguration,
        clientId: clientId,
        issuer: issuer,
        redirectUri: redirectUri,
        issuerState: issuerState,
        nonce: nonce,
        pkcePair: pkcePair,
        state: state,
        authorizationEndPoint: authorizationEndPoint,
        scope: scope,
        tokenEndpointAuthMethod: tokenEndpointAuthMethod,
      );

      final url = Uri.parse(authorizationEndpoint);
      final authorizationUri =
          Uri.https(url.authority, url.path, authorizationRequestParemeters);
      return authorizationUri;
    } catch (e) {
      throw Exception('Not a valid openid url to initiate issuance');
    }
  }

  @visibleForTesting
  Map<String, dynamic> getAuthorizationRequestParemeters({
    required List<dynamic> selectedCredentials,
    required String clientId,
    required String issuer,
    required String issuerState,
    required String nonce,
    required OpenIdConfiguration openIdConfiguration,
    required String redirectUri,
    required String authorizationEndPoint,
    required PkcePair pkcePair,
    required String state,
    required bool scope,
    required String tokenEndpointAuthMethod,
  }) {
    //https://openid.net/specs/openid-4-verifiable-credential-issuance-1_0.html#name-successful-authorization-re

    final authorizationDetails = <dynamic>[];
    final credentials = <dynamic>[];

    for (final credential in selectedCredentials) {
      late Map<String, dynamic> data;
      if (credential is String) {
        //
        final credentialsSupported = openIdConfiguration.credentialsSupported;

        if (credentialsSupported == null) {
          throw Exception();
        }

        dynamic credentailData;

        for (final dynamic cred in credentialsSupported) {
          if (cred is Map<String, dynamic> &&
              ((cred.containsKey('scope') &&
                      cred['scope'].toString() == credential) ||
                  (cred.containsKey('id') &&
                      cred['id'].toString() == credential))) {
            credentailData = cred;
            break;
          }
        }

        if (credentailData == null) {
          throw Exception();
        }

        data = {
          'type': 'openid_credential',
          'locations': [issuer],
          'format': credentailData['format'],
          'types': credentailData['types'],
        };

        credentials.add((credentailData['types'] as List<dynamic>).last);
      } else if (credential is Map<String, dynamic>) {
        data = {
          'type': 'openid_credential',
          'locations': [issuer],
          'format': credential['format'],
          'types': credential['types'],
        };
        credentials.add((credential['types'] as List<dynamic>).last);
      } else {
        throw Exception();
      }

      authorizationDetails.add(data);
    }

    final codeChallenge = pkcePair.codeChallenge;

    final myRequest = <String, dynamic>{
      'response_type': 'code',
      'client_id': clientId,
      'redirect_uri': redirectUri,
      'issuer_state': issuerState,
      'state': state,
      'nonce': nonce,
      'code_challenge': codeChallenge,
      'code_challenge_method': 'S256',
      'client_metadata': getWalletClientMetadata(
        authorizationEndPoint,
        tokenEndpointAuthMethod,
      ),
    };

    if (scope) {
      myRequest['scope'] = listToString(credentials);
    } else {
      myRequest['scope'] = 'openid';
      myRequest['authorization_details'] = jsonEncode(authorizationDetails);
    }
    return myRequest;
  }

  String getWalletClientMetadata(
    String authorizationEndPoint,
    String tokenEndpointAuthMethod,
  ) {
    return jsonEncode({
      'authorization_endpoint': authorizationEndPoint,
      'scopes_supported': ['openid'],
      'response_types_supported': ['vp_token', 'id_token'],
      'client_id_schemes_supported': ['redirect_uri', 'did'],
      'grant_types_supported': ['authorization_code', 'pre-authorized_code'],
      'subject_types_supported': ['public'],
      'id_token_signing_alg_values_supported': ['ES256', 'ES256K'],
      'request_object_signing_alg_values_supported': ['ES256', 'ES256K'],
      'request_parameter_supported': true,
      'request_uri_parameter_supported': true,
      'request_authentication_methods_supported': {
        'authorization_endpoint': ['request_object']
      },
      'vp_formats_supported': {
        'jwt_vp': {
          'alg_values_supported': ['ES256', 'ES256K']
        },
        'jwt_vc': {
          'alg_values_supported': ['ES256', 'ES256K']
        }
      },
      'subject_syntax_types_supported': [
        'urn:ietf:params:oauth:jwk-thumbprint',
        'did:key',
        'did:pkh',
        'did:key',
        'did:polygonid'
      ],
      'subject_syntax_types_discriminations': [
        'did:key:jwk_jcs-pub',
        'did:ebsi:v1'
      ],
      'subject_trust_frameworks_supported': ['ebsi'],
      'id_token_types_supported': ['subject_signed_id_token'],
      'token_endpoint_auth_method': tokenEndpointAuthMethod,
    });
  }

  String? nonce;
  String? accessToken;
  List<dynamic>? authorizationDetails;

  /// Retreive credential_type from url
  Future<(List<dynamic>, String?, String, OpenIdConfiguration?)> getCredential({
    required String issuer,
    required dynamic credential,
    required String did,
    required String kid,
    required int indexValue,
    required String privateKey,
    required bool cryptoHolderBinding,
    required OIDC4VCIDraftType oidc4vciDraftType,
    String? preAuthorizedCode,
    String? userPin,
    String? code,
    String? codeVerifier,
    String? authorization,
  }) async {
    final tokenData = buildTokenData(
      preAuthorizedCode: preAuthorizedCode,
      userPin: userPin,
      code: code,
      codeVerifier: codeVerifier,
      did: did,
    );

    final openIdConfiguration = await getOpenIdConfig(issuer);

    final tokenEndPoint = await readTokenEndPoint(
      openIdConfiguration: openIdConfiguration,
      issuer: issuer,
    );

    if (nonce == null || accessToken == null) {
      final response = await getToken(
        tokenEndPoint: tokenEndPoint,
        tokenData: tokenData,
        authorization: authorization,
      );
      nonce = response['c_nonce'] as String;
      accessToken = response['access_token'] as String;
      authorizationDetails =
          response['authorization_details'] as List<dynamic>?;
    }

    final issuerTokenParameters = IssuerTokenParameters(
      privateKey: jsonDecode(privateKey) as Map<String, dynamic>,
      did: did,
      kid: kid,
      issuer: issuer,
      mediaType: MediaType.proofOfOwnership,
      useJWKThumbPrint: false,
    );

    if (nonce == null) throw Exception();

    String? deferredCredentialEndpoint;

    if (openIdConfiguration.deferredCredentialEndpoint != null) {
      deferredCredentialEndpoint =
          openIdConfiguration.deferredCredentialEndpoint;
    }

    final (credentialType, types, format) = await getCredentialData(
      openIdConfiguration: openIdConfiguration,
      credential: credential,
    );

    final credentialResponseData = <dynamic>[];

    if (authorizationDetails != null) {
      final dynamic authDetailForCredential = authorizationDetails!
          .where(
            (dynamic ele) =>
                ele is Map<String, dynamic> &&
                ((ele.containsKey('types') &&
                        (ele['types'] as List).contains(credentialType)) ||
                    (ele.containsKey('credential_definition') &&
                        (ele['credential_definition']['type'] as List)
                            .contains(credentialType))),
          )
          .firstOrNull;

      if (authDetailForCredential == null) throw Exception();

      final credentialIdentifiers =
          (authDetailForCredential['credential_identifiers'] as List<dynamic>)
              .map((dynamic element) => element.toString())
              .toList();

      for (final credentialIdentifier in credentialIdentifiers) {
        final credentialResponseDataValue = await getSingleCredential(
          issuerTokenParameters: issuerTokenParameters,
          openIdConfiguration: openIdConfiguration,
          credentialType: credentialType,
          types: types,
          format: format,
          credentialIdentifier: credentialIdentifier,
          cryptoHolderBinding: cryptoHolderBinding,
          oidc4vciDraftType: oidc4vciDraftType,
        );

        credentialResponseData.add(credentialResponseDataValue);
      }
//
    } else {
      final credentialResponseDataValue = await getSingleCredential(
        issuerTokenParameters: issuerTokenParameters,
        openIdConfiguration: openIdConfiguration,
        credentialType: credentialType,
        types: types,
        format: format,
        cryptoHolderBinding: cryptoHolderBinding,
        oidc4vciDraftType: oidc4vciDraftType,
      );

      credentialResponseData.add(credentialResponseDataValue);
    }

    return (
      credentialResponseData,
      deferredCredentialEndpoint,
      format,
      openIdConfiguration,
    );
  }

  Future<dynamic> getSingleCredential({
    required IssuerTokenParameters issuerTokenParameters,
    required OpenIdConfiguration openIdConfiguration,
    required String credentialType,
    required List<String> types,
    required String format,
    required bool cryptoHolderBinding,
    required OIDC4VCIDraftType oidc4vciDraftType,
    String? credentialIdentifier,
  }) async {
    final credentialData = await buildCredentialData(
      nonce: nonce!,
      issuerTokenParameters: issuerTokenParameters,
      openIdConfiguration: openIdConfiguration,
      credentialType: credentialType,
      types: types,
      format: format,
      credentialIdentifier: credentialIdentifier,
      cryptoHolderBinding: cryptoHolderBinding,
      oidc4vciDraftType: oidc4vciDraftType,
    );

    /// sign proof

    final credentialEndpoint = readCredentialEndpoint(openIdConfiguration);

    if (accessToken == null) throw Exception();

    final credentialHeaders = <String, dynamic>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    final dynamic credentialResponse = await client.post<dynamic>(
      credentialEndpoint,
      options: Options(headers: credentialHeaders),
      data: credentialData,
    );

    nonce = credentialResponse.data['c_nonce'].toString();

    return credentialResponse.data;
  }

  /// get Deferred credential from url
  Future<dynamic> getDeferredCredential({
    required String acceptanceToken,
    required String deferredCredentialEndpoint,
  }) async {
    final credentialHeaders = <String, dynamic>{
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $acceptanceToken',
    };

    final dynamic credentialResponse = await client.post<dynamic>(
      deferredCredentialEndpoint,
      options: Options(headers: credentialHeaders),
    );

    return credentialResponse.data;
  }

  void resetNonceAndAccessTokenAndAuthorizationDetails() {
    nonce = null;
    accessToken = null;
    authorizationDetails = null;
  }

  Map<String, dynamic> buildTokenData({
    String? preAuthorizedCode,
    String? userPin,
    String? code,
    String? codeVerifier,
    String? did,
  }) {
    late Map<String, dynamic> tokenData;

    if (preAuthorizedCode != null) {
      tokenData = <String, dynamic>{
        'pre-authorized_code': preAuthorizedCode,
        'grant_type': 'urn:ietf:params:oauth:grant-type:pre-authorized_code',
        'client_id': did,
      };
    } else if (code != null && codeVerifier != null && did != null) {
      tokenData = <String, dynamic>{
        'code': code,
        'grant_type': 'authorization_code',
        'code_verifier': codeVerifier,
        'client_id': did,
      };
    } else {
      throw Exception();
    }

    if (userPin != null) {
      tokenData['user_pin'] = userPin;
    }

    return tokenData;
  }

  Future<Response<Map<String, dynamic>>> getDidDocument(String didKey) async {
    try {
      final didDocument = await client.get<Map<String, dynamic>>(
        'https://unires:test@unires.talao.co/1.0/identifiers/$didKey',
      );

      return didDocument;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> readTokenEndPoint({
    required OpenIdConfiguration openIdConfiguration,
    required String issuer,
  }) async {
    var tokenEndPoint = '$issuer/token';

    final authorizationServer = openIdConfiguration.authorizationServer;
    if (authorizationServer != null) {
      final authorizationServerConfiguration =
          await getOpenIdConfig(authorizationServer);

      if (authorizationServerConfiguration.tokenEndpoint != null) {
        tokenEndPoint = authorizationServerConfiguration.tokenEndpoint!;
      }
    } else {
      if (openIdConfiguration.tokenEndpoint != null) {
        tokenEndPoint = openIdConfiguration.tokenEndpoint!;
      }
    }
    return tokenEndPoint;
  }

  Future<String> readAuthorizationEndPoint({
    required OpenIdConfiguration openIdConfiguration,
    required String issuer,
  }) async {
    var authorizationEndpoint = '$issuer/authorize';

    final authorizationServer = openIdConfiguration.authorizationServer;
    if (authorizationServer != null) {
      final authorizationServerConfiguration =
          await getOpenIdConfig(authorizationServer);

      if (authorizationServerConfiguration.authorizationEndpoint != null) {
        authorizationEndpoint =
            authorizationServerConfiguration.authorizationEndpoint!;
      }
    } else {
      if (openIdConfiguration.authorizationEndpoint != null) {
        authorizationEndpoint = openIdConfiguration.authorizationEndpoint!;
      }
    }
    return authorizationEndpoint;
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
    String? holderKid,
    Response<Map<String, dynamic>> didDocumentResponse,
  ) {
    final jsonPath = JsonPath(r'$..verificationMethod');
    late List<dynamic> data;

    if (holderKid == null) {
      data = (jsonPath.read(didDocumentResponse.data).first.value as List)
          .toList();
    } else {
      data = (jsonPath.read(didDocumentResponse.data).first.value as List)
          .where(
            (dynamic e) => e['id'].toString() == holderKid,
          )
          .toList();
    }

    final value = data.first['publicKeyJwk'];

    return jsonDecode(jsonEncode(value)) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> buildCredentialData({
    required String nonce,
    required IssuerTokenParameters issuerTokenParameters,
    required OpenIdConfiguration openIdConfiguration,
    required String credentialType,
    required List<String> types,
    required String format,
    required bool cryptoHolderBinding,
    required OIDC4VCIDraftType oidc4vciDraftType,
    String? credentialIdentifier,
  }) async {
    final vcJwt = await getIssuerJwt(issuerTokenParameters, nonce);

    final credentialData = <String, dynamic>{};

    if (cryptoHolderBinding) {
      credentialData['proof'] = {
        'proof_type': 'jwt',
        'jwt': vcJwt,
      };
    }

    switch (oidc4vciDraftType) {
      case OIDC4VCIDraftType.draft8:
        credentialData['type'] = credentialType;
        credentialData['format'] = format;
      case OIDC4VCIDraftType.draft11:
        credentialData['types'] = types;
        credentialData['format'] = format;
      case OIDC4VCIDraftType.draft12:
        credentialData['types'] = types;
        if (credentialIdentifier != null) {
          credentialData['credential_identifier'] = credentialIdentifier;
        }
    }

    return credentialData;
  }

  Future<(String, List<String>, String)> getCredentialData({
    required OpenIdConfiguration openIdConfiguration,
    required dynamic credential,
  }) async {
    String? credentialType;
    List<String>? types;
    String? format;

    if (credential is String) {
      credentialType = credential;

      if (credentialType.startsWith('https://api.preprod.ebsi.eu')) {
        format = 'jwt_vc';
        types = [];
      } else {
        final jsonPath = JsonPath(r'$..credentials_supported');

        final credentialSupported = (jsonPath
                .read(jsonDecode(jsonEncode(openIdConfiguration)))
                .first
                .value as List)
            .where(
              (dynamic e) =>
                  e is Map<String, dynamic> &&
                  ((e.containsKey('scope') &&
                          e['scope'].toString() == credential) ||
                      (e.containsKey('id') &&
                          e['id'].toString() == credential)),
            )
            .first as Map<String, dynamic>;
        types = (credentialSupported['types'] as List<dynamic>)
            .map((e) => e.toString())
            .toList();
        format = credentialSupported['format'].toString();
      }
    } else if (credential is Map<String, dynamic>) {
      types = (credential['types'] as List<dynamic>)
          .map((e) => e.toString())
          .toList();
      credentialType = types.last;
      format = credential['format'].toString();
    } else {
      throw Exception();
    }

    return (credentialType, types, format);
  }

  Future<VerificationType> verifyEncodedData({
    required String issuerDid,
    required String? issuerKid,
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
    OpenIdConfiguration openIdConfiguration,
  ) {
    final jsonPathCredential = JsonPath(r'$..credential_endpoint');

    final credentialEndpoint = jsonPathCredential
        .readValues(jsonDecode(jsonEncode(openIdConfiguration)))
        .first as String;
    return credentialEndpoint;
  }

  @visibleForTesting
  Future<String> getIssuerJwt(
    IssuerTokenParameters tokenParameters,
    String nonce,
  ) async {
    final iat = (DateTime.now().millisecondsSinceEpoch / 1000).round();
    final payload = {
      'iss': tokenParameters.did,
      'nonce': nonce,
      'iat': iat,
      'aud': tokenParameters.issuer,
    };

    final jwt = generateToken(
      payload: payload,
      tokenParameters: tokenParameters,
    );
    return jwt;
  }

  @visibleForTesting
  Future<dynamic> getToken({
    required String tokenEndPoint,
    required Map<String, dynamic> tokenData,
    required String? authorization,
  }) async {
    /// getting token
    final tokenHeaders = <String, dynamic>{
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    if (authorization != null) {
      tokenHeaders['Authorization'] = 'Basic $authorization';
    }

    final dynamic tokenResponse = await client.post<Map<String, dynamic>>(
      tokenEndPoint,
      options: Options(headers: tokenHeaders),
      data: tokenData,
    );
    return tokenResponse.data;
  }

  // Future<void> sendPresentation({
  //   required String clientId,
  //   required String redirectUrl,
  //   required String did,
  //   required String kid,
  //   required List<String> credentialsToBePresented,
  //   required String nonce,
  //   required int indexValue,
  //   required String? stateValue,
  //   String? mnemonic,
  //   String? privateKey,
  // }) async {
  //   try {
  //     final private = await getPrivateKey(
  //       mnemonic: mnemonic,
  //       privateKey: privateKey,
  //       indexValue: indexValue,
  //     );

  //     final tokenParameters = VerifierTokenParameters(
  //       privateKey: private,
  //       did: did,
  //       kid: kid,
  //       audience: clientId,
  //       credentials: credentialsToBePresented,
  //       nonce: nonce,
  //     );

  //     // structures
  //     final verifierIdToken = await getIdToken(tokenParameters);

  //     /// build vp token

  //     final vpToken = await getVpToken(tokenParameters);

  //     final responseHeaders = {
  //       'Content-Type': 'application/x-www-form-urlencoded',
  //     };

  //     final responseData = <String, dynamic>{
  //       'id_token': verifierIdToken,
  //       'vp_token': vpToken,
  //     };

  //     if (stateValue != null) {
  //       responseData['state'] = stateValue;
  //     }

  //     await client.post<dynamic>(
  //       redirectUrl,
  //       options: Options(headers: responseHeaders),
  //       data: responseData,
  //     );
  //   } catch (e) {
  //     throw Exception(e);
  //   }
  // }

  Future<String> extractVpToken({
    required String clientId,
    required String nonce,
    required List<String> credentialsToBePresented,
    required String did,
    required String kid,
    required String privateKey,
  }) async {
    try {
      final private = jsonDecode(privateKey) as Map<String, dynamic>;

      final tokenParameters = VerifierTokenParameters(
        privateKey: private,
        did: did,
        kid: kid,
        audience: clientId,
        credentials: credentialsToBePresented,
        nonce: nonce,
        mediaType: MediaType.basic,
        useJWKThumbPrint: false,
      );

      final vpToken = await getVpToken(tokenParameters);

      return vpToken;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> extractIdToken({
    required String clientId,
    required List<String> credentialsToBePresented,
    required String did,
    required String kid,
    required String nonce,
    required bool useJWKThumbPrint,
    required String privateKey,
  }) async {
    try {
      final private = jsonDecode(privateKey) as Map<String, dynamic>;
      final tokenParameters = VerifierTokenParameters(
        privateKey: private,
        did: did,
        kid: kid,
        audience: clientId,
        credentials: credentialsToBePresented,
        nonce: nonce,
        mediaType: MediaType.basic,
        useJWKThumbPrint: useJWKThumbPrint,
      );

      final verifierIdToken = await getIdToken(tokenParameters);

      return verifierIdToken;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response<dynamic>> siopv2Flow({
    required String clientId,
    required String did,
    required String kid,
    required String redirectUri,
    required String? nonce,
    required String privateKey,
    required String? stateValue,
    required bool useJWKThumbPrint,
  }) async {
    try {
      final private = jsonDecode(privateKey) as Map<String, dynamic>;

      final tokenParameters = VerifierTokenParameters(
        privateKey: private,
        did: did,
        kid: kid,
        audience: clientId,
        credentials: [],
        nonce: nonce,
        mediaType: MediaType.basic,
        useJWKThumbPrint: useJWKThumbPrint,
      );

      // structures
      final verifierIdToken = await getIdToken(tokenParameters);

      final responseHeaders = {
        'Content-Type': 'application/x-www-form-urlencoded',
      };

      final responseData = <String, dynamic>{
        'id_token': verifierIdToken,
      };

      if (stateValue != null) {
        responseData['state'] = stateValue;
      }

      final response = await client.post<dynamic>(
        redirectUri,
        options: Options(
          headers: responseHeaders,
          followRedirects: false,
          validateStatus: (status) {
            return status != null && status < 400;
          },
        ),
        data: responseData,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @visibleForTesting
  Future<String> getVpToken(
    VerifierTokenParameters tokenParameters,
  ) async {
    final iat = (DateTime.now().millisecondsSinceEpoch / 1000).round();
    final presentationId = 'urn:uuid:${const Uuid().v4()}';
    final vpTokenPayload = {
      'iat': iat,
      'jti': presentationId,
      'nbf': iat - 10,
      'aud': tokenParameters.audience,
      'exp': iat + 1000,
      'sub': tokenParameters.did,
      'iss': tokenParameters.did,
      'vp': {
        '@context': ['https://www.w3.org/2018/credentials/v1'],
        'id': presentationId,
        'type': ['VerifiablePresentation'],
        'holder': tokenParameters.did,
        'verifiableCredential': tokenParameters.jsonIdOrJwtList,
      },
      'nonce': tokenParameters.nonce!,
    };

    final verifierVpJwt = generateToken(
      payload: vpTokenPayload,
      tokenParameters: tokenParameters,
    );

    return verifierVpJwt;
  }

  String generateToken({
    required Map<String, Object> payload,
    required TokenParameters tokenParameters,
  }) {
    final vpVerifierClaims = JsonWebTokenClaims.fromJson(payload);
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
      ..setProtectedHeader('typ', tokenParameters.mediaType.typ)
      ..setProtectedHeader('alg', tokenParameters.alg)

      // add a key to sign, can only add one for JWT
      ..addRecipient(key, algorithm: tokenParameters.alg);

    if (!tokenParameters.useJWKThumbPrint) {
      vpBuilder.setProtectedHeader(
        'kid',
        tokenParameters.kid ?? tokenParameters.thumbprint,
      );
    }

    // build the jws
    final vpJws = vpBuilder.build();

    // output the compact serialization
    final verifierVpJwt = vpJws.toCompactSerialization();
    return verifierVpJwt;
  }

  @visibleForTesting
  Future<String> getIdToken(VerifierTokenParameters tokenParameters) async {
    /// build id token
    final issAndSub = tokenParameters.useJWKThumbPrint
        ? tokenParameters.thumbprint
        : tokenParameters.did;
    final iat = (DateTime.now().millisecondsSinceEpoch / 1000).round();
    final payload = {
      'iat': iat,
      'aud': tokenParameters.audience, // devrait être verifier
      'exp': iat + 1000,
      'sub': issAndSub,
      'iss': issAndSub,
    };

    if (tokenParameters.nonce != null) {
      payload['nonce'] = tokenParameters.nonce!;
    }

    if (tokenParameters.useJWKThumbPrint) {
      payload['sub_jwk'] = tokenParameters.publicJWK;
    }

    //tokenParameters.thumbprint;
    final verifierIdJwt = generateToken(
      payload: payload,
      tokenParameters: tokenParameters,
    );
    return verifierIdJwt;
  }

  // Future<String> getDidFromMnemonic({
  //   required String did,
  //   required String kid,
  //   required int indexValue,
  //   String? mnemonic,
  //   String? privateKey,
  // }) async {
  //   final private = await getPrivateKey(
  //     mnemonic: mnemonic,
  //     privateKey: privateKey,
  //     indexValue: indexValue,
  //   );

  //   final tokenParameters = TokenParameters(
  //     privateKey: private,
  //     did: did,
  //     kid: kid,
  //   );
  //   return tokenParameters.did;
  // }

  // Future<String?> getKid({
  //   required String did,
  //   required String kid,
  //   required int indexValue,
  //   String? mnemonic,
  //   String? privateKey,
  // }) async {
  //   final private = await getPrivateKey(
  //     mnemonic: mnemonic,
  //     privateKey: privateKey,
  //     indexValue: indexValue,
  //   );

  //   final tokenParameters = TokenParameters(
  //     privateKey: private,
  //     did: did,
  //     kid: kid,
  //   );
  //   return tokenParameters.kid;
  // }

  Future<OpenIdConfiguration> getOpenIdConfig(String baseUrl) async {
    final url = '$baseUrl/.well-known/openid-configuration';

    try {
      final response = await client.get<dynamic>(url);
      final data = response.data is String
          ? jsonDecode(response.data.toString()) as Map<String, dynamic>
          : response.data as Map<String, dynamic>;

      return OpenIdConfiguration.fromJson(data);
    } catch (e) {
      if (e.toString().startsWith('Exception: Second_Attempt_Fail')) {
        rethrow;
      } else {
        final data = await getOpenIdConfigSecondAttempt(baseUrl);
        return data;
      }
    }
  }

  Future<OpenIdConfiguration> getOpenIdConfigSecondAttempt(
    String baseUrl,
  ) async {
    final url = '$baseUrl/.well-known/openid-credential-issuer';

    try {
      final response = await client.get<dynamic>(url);
      final data = response.data is String
          ? jsonDecode(response.data.toString()) as Map<String, dynamic>
          : response.data as Map<String, dynamic>;
      return OpenIdConfiguration.fromJson(data);
    } catch (e) {
      throw Exception('Second_Attempt_Fail');
    }
  }
}
