// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:did_kit/did_kit.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:jose_plus/jose.dart';
import 'package:json_path/json_path.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:oidc4vc/src/functions/dio_get.dart';
import 'package:oidc4vc/src/functions/get_authorization_server_from_credential_offer.dart';
import 'package:secure_storage/secure_storage.dart';
import 'package:uuid/uuid.dart';

/// {@template ebsi}
/// EBSI wallet compliance
/// {@endtemplate}
class OIDC4VC {
  OIDC4VC();

  Map<String, dynamic> getAuthorizationRequestParemeters({
    required Oidc4vcParameters oidc4vcParameters,
    required List<dynamic> selectedCredentials,
    required String? clientId,
    required String? clientSecret,
    required String nonce,
    required String redirectUri,
    required PkcePair pkcePair,
    required String state,
    required bool scope,
    required ClientAuthentication clientAuthentication,
    required List<VCFormatType> formatsSuported,
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
        if (oidc4vcParameters
                .classIssuerOpenIdConfiguration.credentialsSupported !=
            null) {
          final credentialsSupported = oidc4vcParameters
              .classIssuerOpenIdConfiguration.credentialsSupported;

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
            'locations': [oidc4vcParameters.classIssuer],
            'format': credentailData['format'],
            'types': credentailData['types'],
          };

          credentials.add((credentailData['types'] as List<dynamic>).last);
        } else if (oidc4vcParameters.classIssuerOpenIdConfiguration
                .credentialConfigurationsSupported !=
            null) {
          // draft 13 case
          final credentialsSupported = oidc4vcParameters
              .classIssuerOpenIdConfiguration.credentialConfigurationsSupported;

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
          late VCFormatType credentialSupportedType;
          try {
            credentialSupportedType = getVcFormatType(
              credentialSupported['format'] as String,
            );
          } catch (e) {
            throw Exception('CREDENTIAL_SUPPORT_DATA_ERROR');
          }

          if (oidc4vcParameters.oidc4vciDraftType ==
                  OIDC4VCIDraftType.draft13 &&
              credentialSupportedType == VCFormatType.vcSdJWT) {
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
          'locations': [oidc4vcParameters.classIssuer],
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
      'redirect_uri': redirectUri,
      'state': state,
      'nonce': nonce,
      'code_challenge': codeChallenge,
      'code_challenge_method': 'S256',
    };

    if (oidc4vcParameters.issuerState != null) {
      myRequest['issuer_state'] = oidc4vcParameters.issuerState;
    }

    if (isEBSIProfile) {
      if (secureAuthorizedFlow) {
        myRequest['client_metadata'] = Uri.encodeComponent(
          jsonEncode(
            oidc4vcParameters.walletClientMetadata,
          ),
        );
      } else if (clientAuthentication != ClientAuthentication.clientSecretJwt) {
        myRequest['client_metadata'] =
            jsonEncode(oidc4vcParameters.walletClientMetadata);
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

  ///deferredCredentialEndpoint
  String? getDeferredCredentialEndpoint(
    OpenIdConfiguration openIdConfiguration,
  ) {
    String? deferredCredentialEndpoint;

    if (openIdConfiguration.deferredCredentialEndpoint != null) {
      deferredCredentialEndpoint =
          openIdConfiguration.deferredCredentialEndpoint;
    }

    return deferredCredentialEndpoint;
  }

  /// tokenEndPoint
  Future<String> getTokenEndPoint({
    required String issuer,
    required OIDC4VCIDraftType oidc4vciDraftType,
    required OpenIdConfiguration openIdConfiguration,
    required Dio dio,
    required bool useOAuthAuthorizationServerLink,
  }) async {
    final tokenEndPoint = await readTokenEndPoint(
      openIdConfiguration: openIdConfiguration,
      issuer: issuer,
      oidc4vciDraftType: oidc4vciDraftType,
      dio: dio,
      useOAuthAuthorizationServerLink: useOAuthAuthorizationServerLink,
    );

    return tokenEndPoint;
  }

  /// tokenResponse, accessToken, cnonce, authorizationDetails
  Future<(Map<String, dynamic>?, String?, String?, List<dynamic>?)>
      getTokenResponse({
    required Dio dio,
    required String tokenEndPoint,
    required Map<String, dynamic> tokenData,
    required String? authorization,
    required String? oAuthClientAttestation,
    required String? oAuthClientAttestationPop,
    required String? dPop,
    required String issuer,
  }) async {
    Map<String, dynamic>? tokenResponse;
    String? accessToken;
    String? cnonce;
    List<dynamic>? authorizationDetails;

    tokenResponse = await getToken(
      tokenEndPoint: tokenEndPoint,
      tokenData: tokenData,
      authorization: authorization,
      dio: dio,
      oAuthClientAttestation: oAuthClientAttestation,
      oAuthClientAttestationPop: oAuthClientAttestationPop,
      dPop: dPop,
    );

    if (tokenResponse.containsKey('c_nonce')) {
      cnonce = tokenResponse['c_nonce'] as String;
    }

    accessToken = tokenResponse['access_token'] as String;
    authorizationDetails =
        tokenResponse['authorization_details'] as List<dynamic>?;

    return (tokenResponse, accessToken, cnonce, authorizationDetails);
  }

  /// nonce
  Future<String?> getNonceReponse({
    required Dio dio,
    required String nonceEndpoint,
  }) async {
    String? cnonce;

    final headers = {'Content-Type': 'application/json; charset=UTF-8'};
    final dynamic response = await dio.post<dynamic>(
      nonceEndpoint,
      options: Options(headers: headers),
    );

    final data = response.data;

    if (data is Map<String, dynamic> && data.containsKey('c_nonce')) {
      cnonce = data['c_nonce'] as String;
    }

    return cnonce;
  }

  int count = 0;

  Future<dynamic> getSingleCredential({
    required String accessToken,
    required Dio dio,
    required Map<String, dynamic> credentialData,
    required String credentialEndpoint,
    required String? dPop,
  }) async {
    try {
      final credentialHeaders = <String, dynamic>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      if (dPop != null) {
        credentialHeaders['DPoP'] = dPop;
      }

      final dynamic credentialResponse = await dio.post<dynamic>(
        credentialEndpoint,
        options: Options(headers: credentialHeaders),
        data: credentialData,
      );

      final credentialResponseData = credentialResponse.data;

      return credentialResponseData;
    } catch (e) {
      rethrow;
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
    String? txCode,
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
    }

    /// draft 13 and above
    if (txCode != null) {
      tokenData['tx_code'] = txCode;
    }

    return tokenData;
  }

  Future<Map<String, dynamic>> getDidDocument({
    required String didKey,
    required bool fromStatusList,
    required bool isCachingEnabled,
    required Dio dio,
    required bool useOAuthAuthorizationServerLink,
    required bool isSdJwtVc,
    SecureStorageProvider? secureStorage,
  }) async {
    try {
      if (isURL(didKey)) {
        OpenIdConfiguration openIdConfiguration;

        var isAuthorizationServer = false;
        var useOAuthAuthorizationServer = useOAuthAuthorizationServerLink;

        if (fromStatusList) {
          ///as this is not a VC issuer
          isAuthorizationServer = true;

          useOAuthAuthorizationServer = false;
        }

        if (isAuthorizationServer) {
          openIdConfiguration = await getAuthorizationServerMetaData(
            baseUrl: didKey,
            isCachingEnabled: isCachingEnabled,
            dio: dio,
            secureStorage: secureStorage,
            useOAuthAuthorizationServerLink: useOAuthAuthorizationServer,
          );
        } else {
          openIdConfiguration = await getIssuerMetaData(
            baseUrl: didKey,
            isCachingEnabled: isCachingEnabled,
            dio: dio,
            secureStorage: secureStorage,
            isSdJwtVc: isSdJwtVc,
          );
        }

        final authorizationServer = openIdConfiguration.authorizationServer;

        if (authorizationServer != null) {
          openIdConfiguration = await getAuthorizationServerMetaData(
            baseUrl: authorizationServer,
            isCachingEnabled: isCachingEnabled,
            dio: dio,
            secureStorage: secureStorage,
            useOAuthAuthorizationServerLink: useOAuthAuthorizationServer,
          );
        }

        // **for ldp_vc, jwt_vc_json and jwt_vc_json-ld **,
        // take the iss attribute (or theissuer attribute for ldp_vc)
        //
        // if this attribute is not a DID this attribute
        // is the credential_issuer url
        //
        // wallet must fetch the keys from <credential_issuer>/.well-known/jwks

        // for sd-jwt
        // take the iss attribute , if this attribute is not a DID this
        // attribute is the credential_issuer url
        //
        // the keys to validate the signature of the VC are situated in
        // -> /.well-known/jwt-vc-issuer if credential_issuer = <domain>
        // -> /.well-known/jwt-vc-issuer/<path> if credential_issuer = <domain>/<path>

        late dynamic response;

        if (openIdConfiguration.jwksUri != null) {
          response = await dioGet(
            openIdConfiguration.jwksUri!,
            isCachingEnabled: isCachingEnabled,
            dio: dio,
            secureStorage: secureStorage,
          );
        } else if (openIdConfiguration.jwks != null) {
          response = openIdConfiguration.jwks;
        } else {
          throw Exception();
        }

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

      final authorizationServerConfiguration =
          await getAuthorizationServerMetaData(
        baseUrl: authorizationServer,
        dio: dio,
        secureStorage: secureStorage,
        useOAuthAuthorizationServerLink: useOAuthAuthorizationServerLink,
      );

      if (authorizationServerConfiguration.tokenEndpoint != null) {
        tokenEndPoint = authorizationServerConfiguration.tokenEndpoint!;
      }
    }

    return tokenEndPoint;
  }

  Future<Oidc4vcParameters> authorizationParameters({
    required Oidc4vcParameters oidc4vcParameters,
    required Dio dio,
  }) async {
    OpenIdConfiguration? authorizationServerConfiguration;
    String? authorizationEndpoint;
    String? tokenEndpoint;
    String? nonceEndpoint;

    switch (oidc4vcParameters.oidc4vciDraftType) {
      case OIDC4VCIDraftType.draft11:
        if (oidc4vcParameters
                .classIssuerOpenIdConfiguration.authorizationEndpoint !=
            null) {
          authorizationEndpoint = oidc4vcParameters
              .classIssuerOpenIdConfiguration.authorizationEndpoint;
          tokenEndpoint =
              oidc4vcParameters.classIssuerOpenIdConfiguration.tokenEndpoint;
          nonceEndpoint =
              oidc4vcParameters.classIssuerOpenIdConfiguration.nonceEndpoint;
        } else {
          final authorizationServer = oidc4vcParameters
                  .classIssuerOpenIdConfiguration.authorizationServer ??
              oidc4vcParameters.classIssuer;

          authorizationServerConfiguration =
              await getAuthorizationServerMetaData(
            baseUrl: authorizationServer,
            dio: dio,
            useOAuthAuthorizationServerLink:
                oidc4vcParameters.useOAuthAuthorizationServerLink,
          );

          if (authorizationServerConfiguration.authorizationEndpoint != null) {
            authorizationEndpoint =
                authorizationServerConfiguration.authorizationEndpoint;
            tokenEndpoint = authorizationServerConfiguration.tokenEndpoint;
            nonceEndpoint = authorizationServerConfiguration.nonceEndpoint;
          }
        }
      case OIDC4VCIDraftType.draft13:
      case OIDC4VCIDraftType.draft14:
        String? authorizationServer;

        /// Extract the authorization endpoint from from first element of
        /// authorization_servers in opentIdConfiguration.authorizationServers
        final listOpenIDConfiguration = oidc4vcParameters
                .classIssuerOpenIdConfiguration.authorizationServers ??
            [];

        // check if authorization server is present in the credential offer
        final authorizationServerFromCredentialOffer =
            getAuthorizationServerFromCredentialOffer(
          oidc4vcParameters.classCredentialOffer,
        );
        // if authorization server is present in the credential offer
        // we check if it is present in the authorization servers
        // from credential issuer metadata
        // https://openid.net/specs/openid-4-verifiable-credential-issuance-1_0.html#name-credential-issuer-metadata-p
        if (authorizationServerFromCredentialOffer != null) {
          if (listOpenIDConfiguration
              .contains(authorizationServerFromCredentialOffer)) {
            authorizationServer = authorizationServerFromCredentialOffer;
          } else {
            // that's forbidden and we can't continue the process
            throw Exception('AUTHORIZATION_SERVER_NOT_FOUND');
          }
        }

        if (listOpenIDConfiguration.isNotEmpty && authorizationServer == null) {
          if (listOpenIDConfiguration.length == 1) {
            authorizationServer = listOpenIDConfiguration.first;
          } else {
            try {
              /// Extract the authorization endpoint from from
              /// authorization_server in credentialOfferJson
              final jsonPathCredentialOffer = JsonPath(
                // ignore: lines_longer_than_80_chars
                r'$..["urn:ietf:params:oauth:grant-type:pre-authorized_code"].authorization_server',
              );
              final data = jsonPathCredentialOffer
                  .read(oidc4vcParameters.classCredentialOffer)
                  .first
                  .value! as String;
              if (listOpenIDConfiguration.contains(data)) {
                authorizationServer = data;
              }
            } catch (e) {
              try {
                final jsonPathCredentialOffer = JsonPath(
                  r'$..authorization_code.authorization_server',
                );
                final data = jsonPathCredentialOffer
                    .read(oidc4vcParameters.classCredentialOffer)
                    .first
                    .value! as String;
                if (data.isNotEmpty && listOpenIDConfiguration.contains(data)) {
                  authorizationServer = data;
                }
              } catch (e) {
                // nothing to do
              }
            }
          }
        }
        if (authorizationServer != null) {
          authorizationServerConfiguration =
              await getAuthorizationServerMetaData(
            baseUrl: authorizationServer,
            dio: dio,
            useOAuthAuthorizationServerLink:
                oidc4vcParameters.useOAuthAuthorizationServerLink,
          );
          authorizationEndpoint =
              authorizationServerConfiguration.authorizationEndpoint;
          tokenEndpoint = authorizationServerConfiguration.tokenEndpoint;
          nonceEndpoint = authorizationServerConfiguration.nonceEndpoint;
        }
    }

    // If authorizationEndpoint is null, we fetch from oauth-
    if (authorizationEndpoint == null) {
      authorizationServerConfiguration = await getAuthorizationServerMetaData(
        baseUrl: oidc4vcParameters.classIssuer,
        dio: dio,
        useOAuthAuthorizationServerLink:
            oidc4vcParameters.useOAuthAuthorizationServerLink,
      );
      authorizationEndpoint =
          authorizationServerConfiguration.authorizationEndpoint;
      tokenEndpoint = authorizationServerConfiguration.tokenEndpoint;
      nonceEndpoint = authorizationServerConfiguration.nonceEndpoint;
    }

    // If authorizationEndpoint is null, we consider the issuer
    // as the authorizationEndpoint
    return oidc4vcParameters.copyWith(
      classAuthorizationEndpoint: authorizationEndpoint,
      classTokenEndpoint: tokenEndpoint,
      classAuthorizationServerOpenIdConfiguration:
          authorizationServerConfiguration,
      nonceEndpoint: nonceEndpoint,
    );
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
      final idAndVerificationMethodPath =
          JsonPath(r'$..[?(@.verificationMethod)]');
      final idAndVerificationMethod = (idAndVerificationMethodPath
          .read(didDocument)
          .first
          .value!) as Map<String, dynamic>;
      final jsonPath = JsonPath(r'$..verificationMethod');
      late List<dynamic> data;

      if (holderKid == null) {
        data = (jsonPath.read(didDocument).first.value! as List).toList();
      } else {
        data = (idAndVerificationMethod['verificationMethod'] as List).where(
          (dynamic e) {
            final id = idAndVerificationMethod['id'];
            final kid = e['id'].toString();

            if (kid.startsWith('#')) {
              if (holderKid == id + kid) return true;
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
    required Oidc4vcParameters oidc4vcParameters,
    required IssuerTokenParameters issuerTokenParameters,
    required String credentialType,
    required List<String>? types,
    required String format,
    required bool cryptoHolderBinding,
    required ClientAuthentication clientAuthentication,
    required String? credentialIdentifier,
    required String? nonce,
    required String? vct,
    required Map<String, dynamic>? credentialDefinition,
    required ProofType proofType,
    required String did,
    required String kid,
    required String privateKey,
    required List<VCFormatType> formatsSupported,
  }) async {
    final credentialData = <String, dynamic>{};
// check if we support the requested format
    late VCFormatType vcFormatType;
    try {
      vcFormatType = getVcFormatType(format);
    } catch (e) {
      throw Exception('CREDENTIAL_SUPPORT_DATA_ERROR');
    }
    if (!formatsSupported.contains(vcFormatType)) {
      throw Exception('CREDENTIAL_SUPPORT_DATA_ERROR');
    }

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
            'domain': oidc4vcParameters.classIssuer,
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

    switch (oidc4vcParameters.oidc4vciDraftType) {
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
      case OIDC4VCIDraftType.draft14:
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
    bool isSdJwtVc = false,
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
          isSdJwtVc: isSdJwtVc,
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
      //'iss': iss,
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
    required String? dPop,
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

    if (dPop != null) {
      tokenHeaders['DPoP'] = dPop;
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

  Future<Map<String, dynamic>> getDataForSiopV2Flow({
    required String clientId,
    required String did,
    required String kid,
    required String redirectUri,
    required String? nonce,
    required String privateKey,
    required String? stateValue,
    required ClientType clientType,
    required ProofHeaderType proofHeader,
  }) async {
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
      proofHeaderType: proofHeader,
      clientId: clientId,
    );

    // structures
    final verifierIdToken = await getIdToken(tokenParameters);

    final responseData = <String, dynamic>{
      'id_token': verifierIdToken,
    };

    if (stateValue != null) {
      responseData['state'] = stateValue;
    }

    return responseData;
  }

  Future<Response<dynamic>> siopv2Flow({
    required String redirectUri,
    required Dio dio,
    required Map<String, dynamic> responseData,
  }) async {
    final responseHeaders = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    try {
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
      'iss': issAndSub,
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

  Future<OpenIdConfiguration> getAuthorizationServerMetaData({
    required String baseUrl,
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

    var url = '$baseUrl/.well-known/openid-configuration';

    final oAuthUrl = '$baseUrl/.well-known/oauth-authorization-server';
    var fallbackUrl = oAuthUrl;

    if (useOAuthAuthorizationServerLink) {
      fallbackUrl = url;
      url = oAuthUrl;
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

      return OpenIdConfiguration.fromJson(data);
    } catch (e) {
      try {
        final response = await dioGet(
          fallbackUrl,
          isCachingEnabled: isCachingEnabled,
          dio: dio,
          secureStorage: secureStorage,
        );
        final data = response is String
            ? jsonDecode(response) as Map<String, dynamic>
            : response as Map<String, dynamic>;

        return OpenIdConfiguration.fromJson(data);
      } catch (e) {
        throw Exception('AUTHORIZATION_SERVER_METADATA_ISSUE');
      }
    }
  }

  Future<OpenIdConfiguration> getIssuerMetaData({
    required String baseUrl,
    required Dio dio,
    bool isCachingEnabled = false,
    bool isSdJwtVc = false,
    SecureStorageProvider? secureStorage,
  }) async {
    var url = '$baseUrl/.well-known/openid-credential-issuer';

    if (isSdJwtVc) {
      final uri = Uri.parse(baseUrl);

      final domain = '${uri.scheme}://${uri.host}';
      final extraPath = uri.path;

      url = '$domain/.well-known/jwt-vc-issuer$extraPath';
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

      return OpenIdConfiguration.fromJson(data);
    } catch (e) {
      throw Exception('ISSUER_METADATA_ISSUE');
    }
  }
}
