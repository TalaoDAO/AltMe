// ignore_for_file: avoid_dynamic_calls, public_member_api_docs

import 'dart:convert';
import 'dart:io';

import 'package:bip32/bip32.dart' as bip32;
import 'package:bip39/bip39.dart' as bip393;
import 'package:bs58/bs58.dart';
import 'package:crypto/crypto.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:did_kit/did_kit.dart';
import 'package:dio/dio.dart';
import 'package:elliptic/elliptic.dart' as elliptic;
import 'package:flutter/foundation.dart';
import 'package:hex/hex.dart';
import 'package:jose_plus/jose.dart';
import 'package:json_path/json_path.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:oidc4vc/src/helper_function.dart';
import 'package:secp256k1/secp256k1.dart';
import 'package:secure_storage/secure_storage.dart';
import 'package:uuid/uuid.dart';

/// {@template ebsi}
/// EBSI wallet compliance
/// {@endtemplate}
class OIDC4VC {
  /// {@macro ebsi}
  OIDC4VC();

  /// create JWK from mnemonic
  String privateKeyFromMnemonic({
    required String mnemonic,
    required int indexValue,
  }) {
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

  String p256PrivateKeyFromMnemonics({
    required String mnemonic,
    required int indexValue,
  }) {
    final seed = bip393.mnemonicToSeed(mnemonic);
    final rootKey = bip32.BIP32.fromSeed(seed);

    final child = rootKey.derivePath("m/44'/5467'/0'/$indexValue'");

    final iterable = child.privateKey!;
    final keySeed = HEX.encode(List.from(iterable));

    // calculate teh pub key
    final ec = elliptic.getP256();
    final priv = elliptic.PrivateKey.fromHex(ec, keySeed);
    final pub = priv.publicKey.toString();

    // format the "d"
    final ad = HEX.decode(priv.toString());
    final d = base64Url.encode(ad);

    // extract the "x"
    final mx = pub.substring(2, 66);

    /// start at 2 to remove first byte of the pub key
    final ax = HEX.decode(mx);
    final x = base64Url.encode(ax);
    // extract the "y"
    final my = pub.substring(66, 130); // last 32 bytes
    final ay = HEX.decode(my);
    final y = base64Url.encode(ay);

    final key = {
      'kty': 'EC',
      'crv': 'P-256',
      'd': d.replaceAll('=', ''),
      'x': x.replaceAll('=', ''),
      'y': y.replaceAll('=', ''),
    };

    return jsonEncode(key);
  }

  /// https://www.rfc-editor.org/rfc/rfc7638
  /// Received JWT is already filtered on required members
  /// Received JWT keys are already sorted in lexicographic order

  /// authorization endpoint, authorizationRequestParemeters,
  /// OpenIdConfiguration
  Future<(String, Map<String, dynamic>, Map<String, dynamic>)>
      getAuthorizationData({
    required List<dynamic> selectedCredentials,
    required String? clientId,
    required String? clientSecret,
    required String redirectUri,
    required String issuer,
    required String? issuerState,
    required String nonce,
    required PkcePair pkcePair,
    required String state,
    required String authorizationEndPoint,
    required bool scope,
    required ClientAuthentication clientAuthentication,
    required OIDC4VCIDraftType oidc4vciDraftType,
    required VCFormatType vcFormatType,
    required bool secureAuthorizedFlow,
    required Dio dio,
    required dynamic credentialOfferJson,
    required bool isEBSIProfile,
    required String walletIssuer,
    required bool useOAuthAuthorizationServerLink,
    SecureStorageProvider? secureStorage,
    String? oAuthClientAttestation,
    String? oAuthClientAttestationPop,
  }) async {
    try {
      final openIdConfigurationData = await getOpenIdConfig(
        baseUrl: issuer,
        isAuthorizationServer: false,
        dio: dio,
        secureStorage: secureStorage,
        useOAuthAuthorizationServerLink: useOAuthAuthorizationServerLink,
      );

      final openIdConfiguration =
          OpenIdConfiguration.fromJson(openIdConfigurationData);

      final credentialAuthorizationEndpoint = await readAuthorizationEndPoint(
        openIdConfiguration: openIdConfiguration,
        issuer: issuer,
        oidc4vciDraftType: oidc4vciDraftType,
        dio: dio,
        credentialOfferJson: credentialOfferJson,
        secureStorage: secureStorage,
        useOAuthAuthorizationServerLink: useOAuthAuthorizationServerLink,
      );

      final authorizationRequestParemeters = getAuthorizationRequestParemeters(
        selectedCredentials: selectedCredentials,
        openIdConfiguration: openIdConfiguration,
        clientId: clientId,
        clientSecret: clientSecret,
        issuer: issuer,
        redirectUri: redirectUri,
        issuerState: issuerState,
        nonce: nonce,
        pkcePair: pkcePair,
        state: state,
        authorizationEndPoint: authorizationEndPoint,
        scope: scope,
        clientAuthentication: clientAuthentication,
        oidc4vciDraftType: oidc4vciDraftType,
        vcFormatType: vcFormatType,
        secureAuthorizedFlow: secureAuthorizedFlow,
        isEBSIProfile: isEBSIProfile,
        walletIssuer: walletIssuer,
      );

      return (
        credentialAuthorizationEndpoint,
        authorizationRequestParemeters,
        openIdConfigurationData,
      );
    } catch (e) {
      throw Exception('NOT_A_VALID_OPENID_URL');
    }
  }

  @visibleForTesting
  Map<String, dynamic> getAuthorizationRequestParemeters({
    required List<dynamic> selectedCredentials,
    required String? clientId,
    required String? clientSecret,
    required String issuer,
    required String? issuerState,
    required String nonce,
    required OpenIdConfiguration openIdConfiguration,
    required String redirectUri,
    required String authorizationEndPoint,
    required PkcePair pkcePair,
    required String state,
    required bool scope,
    required ClientAuthentication clientAuthentication,
    required OIDC4VCIDraftType oidc4vciDraftType,
    required VCFormatType vcFormatType,
    required bool secureAuthorizedFlow,
    required bool isEBSIProfile,
    required String walletIssuer,
  }) {
    //https://openid.net/specs/openid-4-verifiable-credential-issuance-1_0.html#name-successful-authorization-re

    final authorizationDetails = <dynamic>[];
    final credentials = <dynamic>[];

    for (final credential in selectedCredentials) {
      late Map<String, dynamic> data;
      if (credential is String) {
        if (openIdConfiguration.credentialsSupported != null) {
          final credentialsSupported = openIdConfiguration.credentialsSupported;

          dynamic credentailData;

          for (final dynamic cred in credentialsSupported!) {
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
            throw Exception('CREDENTIAL_SUPPORT_DATA_ERROR');
          }

          data = {
            'type': 'openid_credential',
            'locations': [issuer],
            'format': credentailData['format'],
            'types': credentailData['types'],
          };

          credentials.add((credentailData['types'] as List<dynamic>).last);
        } else if (openIdConfiguration.credentialConfigurationsSupported !=
            null) {
          // draft 13 case
          final credentialsSupported =
              openIdConfiguration.credentialConfigurationsSupported;

          if (credentialsSupported is! Map<String, dynamic>) {
            throw Exception('CREDENTIAL_SUPPORT_DATA_ERROR');
          }

          final credentialSupportedMapEntry =
              credentialsSupported.entries.where(
            (entry) {
              final dynamic ele = entry.key;

              if (ele == credential) return true;

              return false;
            },
          ).firstOrNull;

          if (credentialSupportedMapEntry == null) {
            throw Exception('CREDENTIAL_SUPPORT_DATA_ERROR');
          }

          final credentialSupported = credentialSupportedMapEntry.value;

          data = {
            'type': 'openid_credential',
            'credential_configuration_id': credential,
          };
          if (oidc4vciDraftType == OIDC4VCIDraftType.draft13 &&
              vcFormatType == VCFormatType.vcSdJWT) {
            data = {
              'type': 'openid_credential',
              'format': 'vc+sd-jwt',
              'vct': credentialSupported['vct'].toString(),
            };
          }
          final scope = credentialSupported['scope'];

          if (scope == null) {
            throw Exception('CREDENTIAL_SUPPORT_DATA_ERROR');
          }

          credentials.add(scope);
        } else {
          throw Exception('CREDENTIAL_SUPPORT_DATA_ERROR');
        }
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
    final tokenEndpointAuthMethod = clientAuthentication.value;

    final clientMetaData = getWalletClientMetadata(
      authorizationEndPoint,
      tokenEndpointAuthMethod,
    );

    final myRequest = <String, dynamic>{
      'response_type': 'code',
      'redirect_uri': redirectUri,
      'state': state,
      'nonce': nonce,
      'code_challenge': codeChallenge,
      'code_challenge_method': 'S256',
    };

    if (issuerState != null) {
      myRequest['issuer_state'] = issuerState;
    }

    if (isEBSIProfile) {
      if (secureAuthorizedFlow) {
        myRequest['client_metadata'] =
            Uri.encodeComponent(jsonEncode(clientMetaData));
      } else if (clientAuthentication != ClientAuthentication.clientSecretJwt) {
        myRequest['client_metadata'] = jsonEncode(clientMetaData);
        // paramètre config du portail,
        // on ne met pas si : client authentication :
      }
    } else {
      myRequest['wallet_issuer'] = walletIssuer;
    }

    switch (clientAuthentication) {
      case ClientAuthentication.none:
        break;
      case ClientAuthentication.clientSecretBasic:
        myRequest['authorization'] =
            base64UrlEncode(utf8.encode('$clientId:$clientSecret'));
      case ClientAuthentication.clientSecretPost:
        myRequest['client_id'] = clientId;
        myRequest['client_secret'] = clientSecret;
      case ClientAuthentication.clientId:
        myRequest['client_id'] = clientId;
      case ClientAuthentication.clientSecretJwt:
        myRequest['client_id'] = clientId;
    }

    if (scope) {
      myRequest['scope'] = listToString(credentials);
    } else {
      myRequest['scope'] = 'openid';
      myRequest['authorization_details'] = jsonEncode(authorizationDetails);
    }
    return myRequest;
  }

  Map<String, dynamic> getWalletClientMetadata(
    String authorizationEndPoint,
    String tokenEndpointAuthMethod,
  ) {
    return {
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
        'authorization_endpoint': ['request_object'],
      },
      'vp_formats_supported': {
        'jwt_vp': {
          'alg_values_supported': ['ES256', 'ES256K'],
        },
        'jwt_vc': {
          'alg_values_supported': ['ES256', 'ES256K'],
        },
      },
      'subject_syntax_types_supported': [
        'urn:ietf:params:oauth:jwk-thumbprint',
        'did:key',
        'did:pkh',
        'did:key',
        'did:polygonid',
      ],
      'subject_syntax_types_discriminations': [
        'did:key:jwk_jcs-pub',
        'did:ebsi:v1',
      ],
      'subject_trust_frameworks_supported': ['ebsi'],
      'id_token_types_supported': ['subject_signed_id_token'],
      'token_endpoint_auth_method': tokenEndpointAuthMethod,
    };
  }

  /// Retreive credential_type from url
  /// credentialResponseData, deferredCredentialEndpoint, format

  Future<
      (
        List<dynamic>,
        String?,
        String,
      )> getCredential({
    required String issuer,
    required dynamic credential,
    required String did,
    required String? clientId,
    required String kid,
    required String privateKey,
    required bool cryptoHolderBinding,
    required ClientType clientType,
    required ProofHeaderType proofHeaderType,
    required OIDC4VCIDraftType oidc4vciDraftType,
    required ClientAuthentication clientAuthentication,
    required ProofType proofType,
    required OpenIdConfiguration openIdConfiguration,
    required String accessToken,
    required String? cnonce,
    required Dio dio,
    required VCFormatType vcFormatType,
    List<dynamic>? authorizationDetails,
  }) async {
    var nonce = cnonce;

    final issuerTokenParameters = IssuerTokenParameters(
      privateKey: jsonDecode(privateKey) as Map<String, dynamic>,
      did: did,
      kid: kid,
      issuer: issuer,
      mediaType: MediaType.proofOfOwnership,
      clientType: clientType,
      proofHeaderType: proofHeaderType,
      clientId: clientId ?? '',
    );

    String? deferredCredentialEndpoint;

    if (openIdConfiguration.deferredCredentialEndpoint != null) {
      deferredCredentialEndpoint =
          openIdConfiguration.deferredCredentialEndpoint;
    }

    final (credentialType, types, credentialDefinition, vct, format) =
        await getCredentialData(
      openIdConfiguration: openIdConfiguration,
      credential: credential,
    );

    final credentialResponseData = <dynamic>[];

    if (authorizationDetails != null) {
      final dynamic authDetailForCredential = authorizationDetails
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

      if (authDetailForCredential == null) {
        throw Exception('AUTHORIZATION_DETAIL_ERROR');
      }

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
          credentialDefinition: credentialDefinition,
          clientAuthentication: clientAuthentication,
          vct: vct,
          proofType: proofType,
          did: did,
          issuer: issuer,
          kid: kid,
          privateKey: privateKey,
          accessToken: accessToken,
          nonce: nonce,
          dio: dio,
          vcFormatType: vcFormatType,
        );

        /// update nonce value
        if (credentialResponseDataValue is Map<String, dynamic>) {
          if (credentialResponseDataValue.containsKey('c_nonce')) {
            nonce = credentialResponseDataValue['c_nonce'].toString();
          }
        }

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
        credentialDefinition: credentialDefinition,
        clientAuthentication: clientAuthentication,
        vct: vct,
        credentialIdentifier: null,
        proofType: proofType,
        did: did,
        issuer: issuer,
        kid: kid,
        privateKey: privateKey,
        accessToken: accessToken,
        nonce: cnonce,
        dio: dio,
        vcFormatType: vcFormatType,
      );

      credentialResponseData.add(credentialResponseDataValue);
    }

    return (
      credentialResponseData,
      deferredCredentialEndpoint,
      format,
    );
  }

  /// tokenResponse, accessToken, cnonce, authorizationDetails
  Future<(Map<String, dynamic>?, String?, String?, List<dynamic>?)>
      getTokenResponse({
    required String issuer,
    required String? clientId,
    required String? clientSecret,
    required OIDC4VCIDraftType oidc4vciDraftType,
    required String redirectUri,
    required OpenIdConfiguration openIdConfiguration,
    required Dio dio,
    required bool useOAuthAuthorizationServerLink,
    String? preAuthorizedCode,
    String? userPin,
    String? code,
    String? codeVerifier,
    String? authorization,
    String? oAuthClientAttestation,
    String? oAuthClientAttestationPop,
  }) async {
    final tokenEndPoint = await readTokenEndPoint(
      openIdConfiguration: openIdConfiguration,
      issuer: issuer,
      oidc4vciDraftType: oidc4vciDraftType,
      dio: dio,
      useOAuthAuthorizationServerLink: useOAuthAuthorizationServerLink,
    );

    Map<String, dynamic>? tokenResponse;
    String? accessToken;
    String? cnonce;
    List<dynamic>? authorizationDetails;

    final tokenData = buildTokenData(
      preAuthorizedCode: preAuthorizedCode,
      userPin: userPin,
      code: code,
      codeVerifier: codeVerifier,
      clientId: clientId,
      clientSecret: clientSecret,
      authorization: authorization,
      redirectUri: redirectUri,
      oAuthClientAttestation: oAuthClientAttestation,
      oAuthClientAttestationPop: oAuthClientAttestationPop,
    );

    tokenResponse = await getToken(
      tokenEndPoint: tokenEndPoint,
      tokenData: tokenData,
      authorization: authorization,
      dio: dio,
      oAuthClientAttestation: oAuthClientAttestation,
      oAuthClientAttestationPop: oAuthClientAttestationPop,
    );

    if (tokenResponse.containsKey('c_nonce')) {
      cnonce = tokenResponse['c_nonce'] as String;
    }

    accessToken = tokenResponse['access_token'] as String;
    authorizationDetails =
        tokenResponse['authorization_details'] as List<dynamic>?;

    return (tokenResponse, accessToken, cnonce, authorizationDetails);
  }

  int count = 0;

  Future<dynamic> getSingleCredential({
    required IssuerTokenParameters issuerTokenParameters,
    required OpenIdConfiguration openIdConfiguration,
    required String credentialType,
    required List<String>? types,
    required String format,
    required bool cryptoHolderBinding,
    required OIDC4VCIDraftType oidc4vciDraftType,
    required ClientAuthentication clientAuthentication,
    required String? credentialIdentifier,
    required Map<String, dynamic>? credentialDefinition,
    required String? vct,
    required ProofType proofType,
    required String did,
    required String issuer,
    required String kid,
    required String privateKey,
    required String accessToken,
    required String? nonce,
    required Dio dio,
    required VCFormatType vcFormatType,
  }) async {
    try {
      final credentialData = await buildCredentialData(
        nonce: nonce,
        issuerTokenParameters: issuerTokenParameters,
        openIdConfiguration: openIdConfiguration,
        credentialType: credentialType,
        types: types,
        format: format,
        credentialIdentifier: credentialIdentifier,
        cryptoHolderBinding: cryptoHolderBinding,
        oidc4vciDraftType: oidc4vciDraftType,
        credentialDefinition: credentialDefinition,
        clientAuthentication: clientAuthentication,
        vct: vct,
        proofType: proofType,
        did: did,
        issuer: issuer,
        kid: kid,
        privateKey: privateKey,
        vcFormatType: vcFormatType,
      );

      /// sign proof

      final credentialEndpoint = readCredentialEndpoint(openIdConfiguration);

      final credentialHeaders = <String, dynamic>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      final dynamic credentialResponse = await dio.post<dynamic>(
        credentialEndpoint,
        options: Options(headers: credentialHeaders),
        data: credentialData,
      );

      final credentialResponseData = credentialResponse.data;

      return credentialResponseData;
    } catch (e) {
      if (count == 1) {
        count = 0;
        rethrow;
      }

      if (e is DioException &&
          e.response != null &&
          e.response!.data is Map<String, dynamic> &&
          (e.response!.data as Map<String, dynamic>).containsKey('c_nonce')) {
        count++;

        final nonce = e.response!.data['c_nonce'].toString();

        final credentialResponseDataValue = await getSingleCredential(
          issuerTokenParameters: issuerTokenParameters,
          openIdConfiguration: openIdConfiguration,
          credentialType: credentialType,
          types: types,
          format: format,
          cryptoHolderBinding: cryptoHolderBinding,
          oidc4vciDraftType: oidc4vciDraftType,
          credentialDefinition: credentialDefinition,
          clientAuthentication: clientAuthentication,
          vct: vct,
          credentialIdentifier: null,
          proofType: proofType,
          did: did,
          issuer: issuer,
          kid: kid,
          privateKey: privateKey,
          accessToken: accessToken,
          nonce: nonce,
          dio: dio,
          vcFormatType: vcFormatType,
        );
        count = 0;
        return credentialResponseDataValue;
      } else {
        count = 0;
        rethrow;
      }
    }
  }

  /// get Deferred credential from url
  Future<dynamic> getDeferredCredential({
    required Map<String, dynamic> credentialHeaders,
    required Map<String, dynamic>? body,
    required String deferredCredentialEndpoint,
    required Dio dio,
  }) async {
    final dynamic credentialResponse = await dio.post<dynamic>(
      deferredCredentialEndpoint,
      options: Options(headers: credentialHeaders),
      data: body,
    );

    return credentialResponse.data;
  }

  Map<String, dynamic> buildTokenData({
    required String redirectUri,
    String? preAuthorizedCode,
    String? userPin,
    String? code,
    String? codeVerifier,
    String? clientId,
    String? clientSecret,
    String? authorization,
    String? oAuthClientAttestation,
    String? oAuthClientAttestationPop,
  }) {
    late Map<String, dynamic> tokenData;

    if (preAuthorizedCode != null) {
      tokenData = <String, dynamic>{
        'pre-authorized_code': preAuthorizedCode,
        'grant_type': 'urn:ietf:params:oauth:grant-type:pre-authorized_code',
      };
    } else if (code != null && codeVerifier != null) {
      tokenData = <String, dynamic>{
        'code': code,
        'grant_type': 'authorization_code',
        'code_verifier': codeVerifier,
        'redirect_uri': redirectUri,
      };
    } else {
      throw Exception();
    }

    if (authorization == null) {
      if (clientId != null) tokenData['client_id'] = clientId;
      if (clientSecret != null) tokenData['client_secret'] = clientSecret;
    }

    if (oAuthClientAttestation != null && oAuthClientAttestationPop != null) {
      tokenData['client_id'] = clientId;
    }

    if (userPin != null) {
      tokenData['user_pin'] = userPin;

      /// draft 13
      tokenData['tx_code'] = userPin;
    }

    return tokenData;
  }

  Future<Map<String, dynamic>> getDidDocument({
    required String didKey,
    required bool fromStatusList,
    required bool isCachingEnabled,
    required Dio dio,
    required bool useOAuthAuthorizationServerLink,
    SecureStorageProvider? secureStorage,
  }) async {
    try {
      if (isURL(didKey)) {
        OpenIdConfiguration openIdConfiguration;

        var isAuthorizationServer = false;

        if (fromStatusList) {
          ///as this is not a VC issuer
          isAuthorizationServer = true;
        }

        final openIdConfigurationData = await getOpenIdConfig(
          baseUrl: didKey,
          isAuthorizationServer: isAuthorizationServer,
          isCachingEnabled: isCachingEnabled,
          dio: dio,
          secureStorage: secureStorage,
          useOAuthAuthorizationServerLink: useOAuthAuthorizationServerLink,
        );

        openIdConfiguration =
            OpenIdConfiguration.fromJson(openIdConfigurationData);

        final authorizationServer = openIdConfiguration.authorizationServer;

        if (authorizationServer != null) {
          final openIdConfigurationData = await getOpenIdConfig(
            baseUrl: authorizationServer,
            isAuthorizationServer: true,
            isCachingEnabled: isCachingEnabled,
            dio: dio,
            secureStorage: secureStorage,
            useOAuthAuthorizationServerLink: useOAuthAuthorizationServerLink,
          );
          openIdConfiguration =
              OpenIdConfiguration.fromJson(openIdConfigurationData);
        }

        if (openIdConfiguration.jwksUri == null) {
          throw Exception();
        }

        final response = await dioGet(
          openIdConfiguration.jwksUri!,
          isCachingEnabled: isCachingEnabled,
          dio: dio,
          secureStorage: secureStorage,
        );

        return response as Map<String, dynamic>;
      } else {
        try {
          final didDocument = await dio.get<dynamic>(
            'https://unires:test@unires.talao.co/1.0/identifiers/$didKey',
          );
          return didDocument.data as Map<String, dynamic>;
        } catch (e) {
          try {
            final didDocument = await dio.get<dynamic>(
              'https://dev.uniresolver.io/1.0/identifiers/$didKey',
            );
            return didDocument.data as Map<String, dynamic>;
          } catch (e) {
            rethrow;
          }
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  bool isURL(String input) {
    final uri = Uri.tryParse(input)?.hasAbsolutePath ?? false;
    return uri;
  }

  Future<String> readTokenEndPoint({
    required OpenIdConfiguration openIdConfiguration,
    required String issuer,
    required OIDC4VCIDraftType oidc4vciDraftType,
    required Dio dio,
    required bool useOAuthAuthorizationServerLink,
    SecureStorageProvider? secureStorage,
  }) async {
    var tokenEndPoint = '$issuer/token';

    if (openIdConfiguration.tokenEndpoint != null) {
      tokenEndPoint = openIdConfiguration.tokenEndpoint!;
    } else {
      final authorizationServer =
          openIdConfiguration.authorizationServer ?? issuer;

      final authorizationServerConfigurationData = await getOpenIdConfig(
        baseUrl: authorizationServer,
        isAuthorizationServer: true,
        dio: dio,
        secureStorage: secureStorage,
        useOAuthAuthorizationServerLink: useOAuthAuthorizationServerLink,
      );

      final authorizationServerConfiguration =
          OpenIdConfiguration.fromJson(authorizationServerConfigurationData);

      if (authorizationServerConfiguration.tokenEndpoint != null) {
        tokenEndPoint = authorizationServerConfiguration.tokenEndpoint!;
      }
    }

    return tokenEndPoint;
  }

  Future<String> readAuthorizationEndPoint({
    required OpenIdConfiguration openIdConfiguration,
    required String issuer,
    required OIDC4VCIDraftType oidc4vciDraftType,
    required Dio dio,
    required dynamic credentialOfferJson,
    required bool useOAuthAuthorizationServerLink,
    SecureStorageProvider? secureStorage,
  }) async {
    String? authorizationEndpoint;

    switch (oidc4vciDraftType) {
      case OIDC4VCIDraftType.draft11:
        if (openIdConfiguration.authorizationEndpoint != null) {
          authorizationEndpoint = openIdConfiguration.authorizationEndpoint;
        } else {
          final authorizationServer =
              openIdConfiguration.authorizationServer ?? issuer;

          final authorizationServerConfigurationData = await getOpenIdConfig(
            baseUrl: authorizationServer,
            isAuthorizationServer: true,
            dio: dio,
            secureStorage: secureStorage,
            useOAuthAuthorizationServerLink: useOAuthAuthorizationServerLink,
          );

          final authorizationServerConfiguration = OpenIdConfiguration.fromJson(
            authorizationServerConfigurationData,
          );

          if (authorizationServerConfiguration.authorizationEndpoint != null) {
            authorizationEndpoint =
                authorizationServerConfiguration.authorizationEndpoint;
          }
        }
      case OIDC4VCIDraftType.draft13:

        /// Extract the authorization endpoint from from first element of
        /// authorization_servers in opentIdConfiguration.authorizationServers
        final listOpenIDConfiguration =
            openIdConfiguration.authorizationServers ?? [];
        if (listOpenIDConfiguration.isNotEmpty) {
          if (listOpenIDConfiguration.length == 1) {
            authorizationEndpoint =
                '${listOpenIDConfiguration.first}/authorize';
          } else {
            try {
              /// Extract the authorization endpoint from from
              /// authorization_server in credentialOfferJson
              final jsonPathCredentialOffer = JsonPath(
                // ignore: lines_longer_than_80_chars
                r'$..["urn:ietf:params:oauth:grant-type:pre-authorized_code"].authorization_server',
              );
              final data = jsonPathCredentialOffer
                  .read(credentialOfferJson)
                  .first
                  .value! as String;
              if (listOpenIDConfiguration.contains(data)) {
                authorizationEndpoint = '$data/authorize';
              }
            } catch (e) {
              final jsonPathCredentialOffer = JsonPath(
                r'$..authorization_code.authorization_server',
              );
              final data = jsonPathCredentialOffer
                  .read(credentialOfferJson)
                  .first
                  .value! as String;
              if (data.isNotEmpty && listOpenIDConfiguration.contains(data)) {
                authorizationEndpoint = '$data/authorize';
              }
            }
          }
        }
    }
    // If authorizationEndpoint is null, we consider the issuer
    // as the authorizationEndpoint

    return authorizationEndpoint ??= '$issuer/authorize';
  }

  String readIssuerDid(
    Response<Map<String, dynamic>> openidConfigurationResponse,
  ) {
    final jsonPath = JsonPath(r'$..issuer');

    final data = jsonPath.read(openidConfigurationResponse.data).first.value!
        as Map<String, dynamic>;

    return data['id'] as String;
  }

  Map<String, dynamic> readPublicKeyJwk({
    required String issuer,
    required String? holderKid,
    required Map<String, dynamic> didDocument,
  }) {
    final isUrl = isURL(issuer);
    // if it is not url then it is did
    if (isUrl) {
      final jsonPath = JsonPath(r'$..keys');
      late dynamic data;

      if (holderKid == null) {
        data = (jsonPath.read(didDocument).first.value! as List).first;
      } else {
        data = (jsonPath.read(didDocument).first.value! as List)
            .where(
              (dynamic e) => e['kid'].toString() == holderKid,
            )
            .first;
      }

      return jsonDecode(jsonEncode(data)) as Map<String, dynamic>;
    } else {
      final totoPath = JsonPath(r'$..[?(@.verificationMethod)]');
      final toto =
          (totoPath.read(didDocument).first.value!) as Map<String, dynamic>;
      final jsonPath = JsonPath(r'$..verificationMethod');
      late List<dynamic> data;

      if (holderKid == null) {
        data = (jsonPath.read(didDocument).first.value! as List).toList();
      } else {
        data = (jsonPath.read(didDocument).first.value! as List).where(
          (dynamic e) {
            final kid = e['id'].toString();

            if (holderKid.contains('#')) {
              final identifier = '#${holderKid.split('#')[1]}';
              if (kid == identifier) return true;
            } else {
              if (holderKid == kid) return true;
            }
            return false;
          },
        ).toList();
      }

      if (data.isEmpty) {
        throw Exception('KID_DOES_NOT_MATCH_DIDDOCUMENT');
      }

      if (data.isEmpty) {
        throw Exception('KID_DOES_NOT_MATCH_DIDDOCUMENT');
      }

      final method = data.first as Map<String, dynamic>;

      dynamic publicKeyJwk;

      if (method.containsKey('publicKeyJwk')) {
        publicKeyJwk = method['publicKeyJwk'];
      } else if (method.containsKey('publicKeyBase58')) {
        publicKeyJwk =
            publicKeyBase58ToPublicJwk(method['publicKeyBase58'].toString());
      } else {
        throw Exception('PUBLICKEYJWK_EXTRACTION_ERROR');
      }

      return jsonDecode(jsonEncode(publicKeyJwk)) as Map<String, dynamic>;
    }
  }

  Future<Map<String, dynamic>> buildCredentialData({
    required IssuerTokenParameters issuerTokenParameters,
    required OpenIdConfiguration openIdConfiguration,
    required String credentialType,
    required List<String>? types,
    required String format,
    required bool cryptoHolderBinding,
    required OIDC4VCIDraftType oidc4vciDraftType,
    required ClientAuthentication clientAuthentication,
    required String? credentialIdentifier,
    required String? nonce,
    required String? vct,
    required Map<String, dynamic>? credentialDefinition,
    required ProofType proofType,
    required String did,
    required String issuer,
    required String kid,
    required String privateKey,
    required VCFormatType vcFormatType,
  }) async {
    final credentialData = <String, dynamic>{};

    if (cryptoHolderBinding) {
      var currentProofType = proofType;

      /// Proof Type is ignored for clientSecretJwt
      if (clientAuthentication == ClientAuthentication.clientSecretJwt) {
        currentProofType = ProofType.jwt;
      }

      switch (currentProofType) {
        case ProofType.ldpVp:
          final options = <String, dynamic>{
            'verificationMethod': kid,
            'proofPurpose': 'authentication',
            'domain': issuer,
          };

          if (nonce != null) {
            options['challenge'] = nonce;
          }

          final didKitProvider = DIDKitProvider();

          final didAuth = await didKitProvider.didAuth(
            did,
            jsonEncode(options),
            privateKey,
          );

          credentialData['proof'] = {
            'proof_type': 'ldp_vp',
            'ldp_vp': jsonDecode(didAuth),
          };

        case ProofType.jwt:
          final vcJwt = await getIssuerJwt(
            tokenParameters: issuerTokenParameters,
            clientAuthentication: clientAuthentication,
            cnonce: nonce,
            iss: issuerTokenParameters.clientId,
          );

          credentialData['proof'] = {
            'proof_type': 'jwt',
            'jwt': vcJwt,
          };
      }
    }

    switch (oidc4vciDraftType) {
      // case OIDC4VCIDraftType.draft8:
      //   credentialData['type'] = credentialType;
      //   credentialData['format'] = format;

      case OIDC4VCIDraftType.draft11:
        if (types == null) {
          throw Exception('CREDENTIAL_SUPPORT_DATA_ERROR');
        }

        credentialData['types'] = types;
        credentialData['format'] = format;

      // case OIDC4VCIDraftType.draft12:
      //   if (types == null) {
      //     throw Exception('CREDENTIAL_SUPPORT_DATA_ERROR');
      //   }

      //   credentialData['types'] = types;
      //   if (credentialIdentifier != null) {
      //     credentialData['credential_identifier'] = credentialIdentifier;
      //   }

      case OIDC4VCIDraftType.draft13:
        credentialData['format'] = format;

        if (credentialDefinition != null) {
          if (vcFormatType == VCFormatType.jwtVcJson) {
            credentialDefinition.removeWhere((key, _) => key != 'type');
          }

          if (vcFormatType == VCFormatType.ldpVc ||
              vcFormatType == VCFormatType.jwtVcJsonLd) {
            credentialDefinition
                .removeWhere((key, _) => key != 'type' && key != '@context');
          }
          credentialData['credential_definition'] = credentialDefinition;
        }

        if (vct != null) {
          credentialData['vct'] = vct;
        }
    }

    return credentialData;
  }

  /// (credentialType, types, credential_definition, vct, format)
  Future<(String, List<String>?, Map<String, dynamic>?, String?, String)>
      getCredentialData({
    required OpenIdConfiguration openIdConfiguration,
    required dynamic credential,
  }) async {
    String? credentialType;
    List<String>? types;
    Map<String, dynamic>? credentialDefinition;
    String? vct;
    String? format;

    if (credential is String) {
      credentialType = credential;
    } else if (credential is Map<String, dynamic>) {
      types = (credential['types'] as List<dynamic>)
          .map((e) => e.toString())
          .toList();
      credentialType = types.last;
      format = credential['format'].toString();
    } else {
      throw Exception('CREDENTIAL_SUPPORT_DATA_ERROR');
    }

    if (credentialType.startsWith('https://api.preprod.ebsi.eu')) {
      format = 'jwt_vc';
      types = [];
    } else if (openIdConfiguration.credentialsSupported != null) {
      final credentialsSupported = JsonPath(r'$..credentials_supported')
          .read(jsonDecode(jsonEncode(openIdConfiguration)))
          .first
          .value;

      if (credentialsSupported is! List<dynamic>) {
        throw Exception('CREDENTIAL_SUPPORT_DATA_ERROR');
      }

      final credentialSupported = credentialsSupported
          .where(
            (dynamic e) =>
                e is Map<String, dynamic> &&
                ((e.containsKey('scope') &&
                        e['scope'].toString() == credentialType) ||
                    (e.containsKey('id') &&
                        e['id'].toString() == credentialType) ||
                    e.containsKey('types') &&
                        e['types'] is List<dynamic> &&
                        (e['types'] as List<dynamic>).contains(credentialType)),
          )
          .firstOrNull;

      if (credentialSupported == null ||
          credentialSupported is! Map<String, dynamic>) {
        throw Exception('CREDENTIAL_SUPPORT_DATA_ERROR');
      }

      types = (credentialSupported['types'] as List<dynamic>)
          .map((e) => e.toString())
          .toList();
      format = credentialSupported['format'].toString();
    } else if (openIdConfiguration.credentialConfigurationsSupported != null) {
      // draft 13 case

      final credentialsSupported =
          JsonPath(r'$..credential_configurations_supported')
              .read(jsonDecode(jsonEncode(openIdConfiguration)))
              .first
              .value;

      if (credentialsSupported is! Map<String, dynamic>) {
        throw Exception('CREDENTIAL_SUPPORT_DATA_ERROR');
      }

      final credentialSupportedMapEntry = credentialsSupported.entries.where(
        (entry) {
          final dynamic ele = entry.key;

          if (ele == credentialType) return true;

          return false;
        },
      ).firstOrNull;

      if (credentialSupportedMapEntry == null) {
        throw Exception('CREDENTIAL_SUPPORT_DATA_ERROR');
      }

      final credentialSupported = credentialSupportedMapEntry.value;

      format = credentialSupported['format'].toString();

      if (credentialSupported is Map<String, dynamic>) {
        if (credentialSupported.containsKey('credential_definition')) {
          credentialDefinition = credentialSupported['credential_definition']
              as Map<String, dynamic>;
        }

        if (credentialSupported.containsKey('vct')) {
          vct = credentialSupported['vct'].toString();
        }
      }
    } else {
      throw Exception('CREDENTIAL_SUPPORT_DATA_ERROR');
    }

    return (credentialType, types, credentialDefinition, vct, format);
  }

  Future<VerificationType> verifyEncodedData({
    required String issuer,
    required String? issuerKid,
    required String jwt,
    required Map<String, dynamic>? publicJwk,
    required bool fromStatusList,
    required bool isCachingEnabled,
    required Dio dio,
    required bool useOAuthAuthorizationServerLink,
  }) async {
    try {
      Map<String, dynamic>? publicKeyJwk;

      if (publicJwk != null) {
        publicKeyJwk = publicJwk;
      } else {
        final didDocument = await getDidDocument(
          didKey: issuer,
          fromStatusList: fromStatusList,
          isCachingEnabled: isCachingEnabled,
          dio: dio,
          useOAuthAuthorizationServerLink: useOAuthAuthorizationServerLink,
        );

        publicKeyJwk = readPublicKeyJwk(
          issuer: issuer,
          holderKid: issuerKid,
          didDocument: didDocument,
        );
      }

      final kty = publicKeyJwk['kty'].toString();

      if (publicKeyJwk['crv'] == 'secp256k1') {
        publicKeyJwk['crv'] = 'P-256K';
      }

      publicKeyJwk.remove('kid');

      late final bool isVerified;
      if (kty == 'OKP') {
        isVerified = verifyTokenEdDSA(
          publicKey: publicKeyJwk,
          token: jwt,
        );
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
      rethrow;
    }
  }

  String generateTokenEdDSA({
    required Map<String, dynamic> payload,
    required Map<String, dynamic> privateKey,
    required String kid,
    required MediaType mediaType,
  }) {
    final d = base64Url.decode(privateKey['d'].toString());
    final x = base64Url.decode(privateKey['x'].toString());

    final secretKey = [...d, ...x];

    final jwt = JWT(
      payload,
      header: {
        'typ': mediaType.typ,
        'alg': 'EdDSA',
        'kid': kid,
      },
    );

    final token = jwt.sign(
      EdDSAPrivateKey(secretKey),
      algorithm: JWTAlgorithm.EdDSA,
    );

    return token;
  }

  bool verifyTokenEdDSA({
    required String token,
    required Map<String, dynamic> publicKey,
  }) {
    try {
      var encoded = publicKey['x'].toString();
      while (encoded.length % 4 != 0) {
        // ignore: use_string_buffers
        encoded += '=';
      }
      final x = base64Url.decode(encoded);
      JWT.verify(
        token,
        EdDSAPublicKey(x),
        checkHeaderType: false,
      );
      return true;
    } on JWTExpiredException {
      return false;
    } on JWTException catch (_) {
      return false;
    }
  }

  String readCredentialEndpoint(
    OpenIdConfiguration openIdConfiguration,
  ) {
    final jsonPathCredential = JsonPath(r'$..credential_endpoint');

    final credentialEndpoint = jsonPathCredential
        .readValues(jsonDecode(jsonEncode(openIdConfiguration)))
        .first! as String;
    return credentialEndpoint;
  }

  @visibleForTesting
  Future<String> getIssuerJwt({
    required IssuerTokenParameters tokenParameters,
    required ClientAuthentication clientAuthentication,
    required String iss,
    String? cnonce,
  }) async {
    final iat = (DateTime.now().millisecondsSinceEpoch / 1000).round() - 30;

    final payload = {
      'iss': iss,
      'iat': iat,
      'aud': tokenParameters.issuer,
    };

    if (cnonce != null) {
      payload['nonce'] = cnonce;
    }

    final jwt = generateToken(
      payload: payload,
      tokenParameters: tokenParameters,
    );
    return jwt;
  }

  @visibleForTesting
  Future<Map<String, dynamic>> getToken({
    required String tokenEndPoint,
    required Map<String, dynamic> tokenData,
    required String? authorization,
    required Dio dio,
    required String? oAuthClientAttestation,
    required String? oAuthClientAttestationPop,
  }) async {
    /// getting token
    final tokenHeaders = <String, dynamic>{
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    if (authorization != null) {
      tokenHeaders['Authorization'] = 'Basic $authorization';
    }

    if (oAuthClientAttestation != null && oAuthClientAttestationPop != null) {
      tokenHeaders['OAuth-Client-Attestation'] = oAuthClientAttestation;
      tokenHeaders['OAuth-Client-Attestation-PoP'] = oAuthClientAttestationPop;
    }

    final dynamic tokenResponse = await dio.post<Map<String, dynamic>>(
      tokenEndPoint,
      options: Options(headers: tokenHeaders),
      data: tokenData,
    );
    return tokenResponse.data as Map<String, dynamic>;
  }

  Future<String> extractVpToken({
    required String clientId,
    required String nonce,
    required List<String> credentialsToBePresented,
    required String did,
    required String kid,
    required String privateKey,
    required ProofHeaderType proofHeaderType,
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
        clientType: ClientType.did,
        proofHeaderType: proofHeaderType,
        clientId: clientId,
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
    required ClientType clientType,
    required String privateKey,
    required ProofHeaderType proofHeaderType,
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
        clientType: clientType,
        proofHeaderType: proofHeaderType,
        clientId: clientId,
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
    required ClientType clientType,
    required ProofHeaderType proofHeaderType,
    required Dio dio,
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
        clientType: clientType,
        proofHeaderType: proofHeaderType,
        clientId: clientId,
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

      final response = await dio.post<dynamic>(
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
      //'iss': tokenParameters.did,
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

  /// getSignedJwt
  String generateToken({
    required Map<String, dynamic> payload,
    required TokenParameters tokenParameters,
    bool ignoreProofHeaderType = false,
  }) {
    final kty = tokenParameters.privateKey['kty'].toString();

    if (kty == 'OKP') {
      final jwt = generateTokenEdDSA(
        payload: payload,
        privateKey: tokenParameters.privateKey,
        kid: tokenParameters.kid ?? tokenParameters.thumbprint,
        mediaType: tokenParameters.mediaType,
      );

      return jwt;
    } else {
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
        ..setProtectedHeader('alg', tokenParameters.alg)

        // add a key to sign, can only add one for JWT
        ..addRecipient(key, algorithm: tokenParameters.alg)
        ..setProtectedHeader('typ', tokenParameters.mediaType.typ);

      if (!ignoreProofHeaderType) {
        /// Proof Header Type is ignored for KB jwt

        switch (tokenParameters.proofHeaderType) {
          case ProofHeaderType.kid:
            vpBuilder.setProtectedHeader(
              'kid',
              tokenParameters.kid ?? tokenParameters.thumbprint,
            );

          case ProofHeaderType.jwk:
            vpBuilder.setProtectedHeader(
              'jwk',
              tokenParameters.publicJWK,
            );
        }
      }

      // build the jws
      final vpJws = vpBuilder.build();

      // output the compact serialization
      final verifierVpJwt = vpJws.toCompactSerialization();
      return verifierVpJwt;
    }
  }

  @visibleForTesting
  Future<String> getIdToken(VerifierTokenParameters tokenParameters) async {
    /// build id token

    var issAndSub = tokenParameters.thumbprint;

    switch (tokenParameters.clientType) {
      case ClientType.p256JWKThumprint:
        issAndSub = tokenParameters.thumbprint;
      case ClientType.did:
        issAndSub = tokenParameters.did;
      case ClientType.confidential:
        issAndSub = tokenParameters.clientId;
    }

    final iat = (DateTime.now().millisecondsSinceEpoch / 1000).round();
    final payload = {
      'iat': iat,
      'aud': tokenParameters.audience, // devrait être verifier
      'exp': iat + 1000,
      'sub': issAndSub,
      // 'iss': issAndSub,
    };

    if (tokenParameters.nonce != null) {
      payload['nonce'] = tokenParameters.nonce!;
    }

    if (tokenParameters.clientType == ClientType.p256JWKThumprint) {
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

  Future<Map<String, dynamic>> getOpenIdConfig({
    required String baseUrl,
    required bool isAuthorizationServer,
    required bool useOAuthAuthorizationServerLink,
    required Dio dio,
    bool isCachingEnabled = false,
    SecureStorageProvider? secureStorage,
  }) async {
    ///for OIDC4VCI, the server is an issuer the metadata are all in th
    ////openid-issuer-configuration or some are in the /openid-configuration
    ///(token endpoint etc,) and other are in the /openid-credential-issuer
    ///(credential supported) for OIDC4VP and SIOPV2, the serve is a client,
    ///the wallet is the authorization server the verifier metadata are in
    ////openid-configuration

    if (!isAuthorizationServer) {
      final data = await getOpenIdConfigSecondMethod(
        baseUrl,
        isCachingEnabled: isCachingEnabled,
        dio: dio,
        secureStorage: secureStorage,
      );
      return data;
    }

    var url = '$baseUrl/.well-known/openid-configuration';

    if (useOAuthAuthorizationServerLink) {
      url = '$baseUrl/.well-known/oauth-authorization-server';
    }

    try {
      final response = await dioGet(
        url,
        isCachingEnabled: isCachingEnabled,
        dio: dio,
        secureStorage: secureStorage,
      );
      final data = response is String
          ? jsonDecode(response) as Map<String, dynamic>
          : response as Map<String, dynamic>;

      return data;
    } catch (e) {
      final data = await getOpenIdConfigSecondMethod(
        baseUrl,
        isCachingEnabled: isCachingEnabled,
        dio: dio,
      );
      return data;
    }
  }

  Future<Map<String, dynamic>> getOpenIdConfigSecondMethod(
    String baseUrl, {
    required bool isCachingEnabled,
    required Dio dio,
    SecureStorageProvider? secureStorage,
  }) async {
    final url = '$baseUrl/.well-known/openid-credential-issuer';

    try {
      final response = await dioGet(
        url,
        isCachingEnabled: isCachingEnabled,
        dio: dio,
        secureStorage: secureStorage,
      );
      final data = response is String
          ? jsonDecode(response) as Map<String, dynamic>
          : response as Map<String, dynamic>;

      return data;
    } catch (e) {
      throw Exception('OPENID-CONFIGURATION-ISSUE');
    }
  }

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

  int getPositionOfZlibBit(int index) => index % 8;

  int getPositionOfGZipBit(int index) => 7 - (index % 8);

  int getByte(int index) => index ~/ 8;

  int getBit({
    required int byte,
    required int bitPosition,
  }) {
    // byte => 32 =0100000
    // The bit in position 5 is set to 1 !!!
    // so bit = 1
    final bit = (byte & (1 << bitPosition)) != 0;
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

  Future<dynamic> dioGet(
    String uri, {
    required Dio dio,
    Map<String, dynamic> headers = const <String, dynamic>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    bool isCachingEnabled = false,
    SecureStorageProvider? secureStorage,
  }) async {
    try {
      final secureStorageProvider = secureStorage ?? getSecureStorage;
      // final cachedData = await secureStorageProvider.get(uri);
      // TODO(hawkbee): To be removed.
      /// temporary solution to purge faulty stored data
      /// Will be removed in the future
      await secureStorageProvider.delete(uri);

      /// end of temporary solution
      dynamic response;

      dio.options.headers = headers;

      // if (isCachingEnabled) {
      //   final secureStorageProvider = getSecureStorage;
      //   final cachedData = await secureStorageProvider.get(uri);
      //   if (cachedData == null) {
      //     response = await dio.get<dynamic>(uri);
      //   } else {
      //     final cachedDataJson = jsonDecode(cachedData);
      //     final expiry = int.parse(cachedDataJson['expiry'].toString());

      //     final isExpired = DateTime.now().millisecondsSinceEpoch > expiry;

      //     if (isExpired) {
      //       response = await dio.get<dynamic>(uri);
      //     } else {
      //       /// directly return cached data
      //       /// returned here to avoid the caching override everytime
      //       final response = await cachedDataJson['data'];
      //       return response;
      //     }
      //   }
      // }
      // temporary deactiviting this caching du to issue with
      // flutter_secure_storage on ios #2657
      // final expiry =
      //     DateTime.now().add(const Duration(days: 2)).millisecondsSinceEpoch;

      // final value = {'expiry': expiry, 'data': response.data};
      // await secureStorageProvider.set(uri, jsonEncode(value));
      response = await dio.get<dynamic>(
        uri,
        options: Options().copyWith(
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

      return response.data;
    } on FormatException {
      throw Exception();
    } catch (e) {
      if (e is DioException) {
        throw Exception();
      } else {
        rethrow;
      }
    }
  }

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
}
