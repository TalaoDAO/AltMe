import 'dart:convert';
import 'dart:typed_data';

import 'package:altme/app/app.dart';
import 'package:altme/connection_bridge/connection_bridge.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/deep_link/deep_link.dart';
import 'package:altme/issuer_websites_page/issuer_websites.dart';
import 'package:altme/query_by_example/query_by_example.dart';
import 'package:altme/scan/scan.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:base_codecs/base_codecs.dart';
import 'package:beacon_flutter/beacon_flutter.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:ebsi/ebsi.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:jose/jose.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:json_path/json_path.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:secure_storage/secure_storage.dart';

part 'qr_code_scan_cubit.g.dart';
part 'qr_code_scan_state.dart';

class QRCodeScanCubit extends Cubit<QRCodeScanState> {
  QRCodeScanCubit({
    required this.client,
    required this.requestClient,
    required this.scanCubit,
    required this.profileCubit,
    required this.walletCubit,
    required this.queryByExampleCubit,
    required this.deepLinkCubit,
    required this.jwtDecode,
    required this.beacon,
    required this.walletConnectCubit,
  }) : super(const QRCodeScanState());

  final DioClient client;
  final DioClient requestClient;
  final ScanCubit scanCubit;
  final ProfileCubit profileCubit;
  final WalletCubit walletCubit;
  final QueryByExampleCubit queryByExampleCubit;
  final DeepLinkCubit deepLinkCubit;
  final JWTDecode jwtDecode;
  final Beacon beacon;
  final WalletConnectCubit walletConnectCubit;

  final log = getLogger('QRCodeScanCubit');

  @override
  Future<void> close() async {
    //cancel streams
    return super.close();
  }

  Future<void> process({required String? scannedResponse}) async {
    log.i('processing scanned qr code - $scannedResponse');
    emit(state.loading(isDeepLink: false));
    try {
      final isInternetAvailable = await isConnected();
      if (!isInternetAvailable) {
        throw NetworkException(
          message: NetworkError.NETWORK_ERROR_NO_INTERNET_CONNECTION,
        );
      }

      if (scannedResponse == null || scannedResponse.isEmpty) {
        throw ResponseMessage(
          ResponseString.RESPONSE_STRING_THIS_QR_CODE_IS_NOT_SUPPORTED,
        );
      } else if (scannedResponse.startsWith('tezos://')) {
        final String pairingRequest =
            Uri.parse(scannedResponse).queryParameters['data'].toString();

        await beacon.pair(pairingRequest: pairingRequest);

        emit(state.copyWith(qrScanStatus: QrScanStatus.goBack));
      } else if (scannedResponse.startsWith('wc:')) {
        await walletConnectCubit.connect(scannedResponse);

        emit(state.copyWith(qrScanStatus: QrScanStatus.goBack));
      } else if (scannedResponse.startsWith('openid://initiate_issuance?')) {
        // convert String from QR code into Uri
        final uri = Uri.parse(scannedResponse);
        final String conformance = uri.queryParameters['conformance']!;
        final credential_type = uri.queryParameters['credential_type']!;
        final issuer = uri.queryParameters['issuer']!;
        const redirectUri = 'app.altme.io/app/download/callback';
        // final redirectUri = 'app.altme.io';
        final headers = {
          'Conformance': conformance,
          'Content-Type': 'application/json'
        };
        const authorizeUrl =
            'https://api-conformance.ebsi.eu/conformance/v2/issuer-mock/authorize';

        final my_request = <String, dynamic>{
          'scope': 'openid',
          'client_id': redirectUri,
          'response_type': 'code',
          'authorization_details': jsonEncode([
            {
              'type': 'openid_credential',
              'credential_type': credential_type,
              'format': 'jwt_vc'
            }
          ]),
          'redirect_uri': redirectUri,
          'state': '1234'
        };
        String code = '210901fc2fc063e9a30a';

        try {
          final Uri authorizationUri = Uri(
            scheme: 'https',
            path: '/conformance/v2/issuer-mock/authorize',
            queryParameters: my_request,
            host: 'api-conformance.ebsi.eu',
          );
          final dynamic authorizationResponse = await client.get(authorizeUrl,
              headers: headers, queryParameters: my_request);
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

        /// getting token
        final tokenHeaders = <String, dynamic>{
          'Conformance': conformance,
          'Content-Type': 'application/x-www-form-urlencoded'
        };
        final String tokenUrl =
            'https://api-conformance.ebsi.eu/conformance/v2/issuer-mock/token';

        final tokenData = <String, dynamic>{
          'code': code,
          'grant_type': 'authorization_code',
          'redirect_uri': redirectUri
        };
        String accessToken = '';
        String cNonce = '';
        try {
          final dynamic tokenResponse = await client.post(
            tokenUrl,
            headers: tokenHeaders,
            data: tokenData,
          );
          accessToken = tokenResponse['access_token'] as String;
          cNonce = tokenResponse['c_nonce'] as String;
        } catch (e) {
          print('what the !!');
        }

        /// preparation before getting credential
        final keyDict = {
          'crv': 'P-256',
          'd': 'ZpntMmvHtDxw6przKSJY-zOHMrEZd8C47D3yuqAsqrw',
          'kty': 'EC',
          'x': 'NB1ylMveV4_PPYtx9KYEjoS1WWA8qN33SJav9opWTaM',
          'y': 'UtOG2jR3NHadMMJ7wdYEq5_nHJHVfcy7QPt_OBHhBrE'
        };

        final keyJwk = {
          'crv': 'P-256',
          'kty': 'EC',
          'x': 'NB1ylMveV4_PPYtx9KYEjoS1WWA8qN33SJav9opWTaM',
          'y': 'UtOG2jR3NHadMMJ7wdYEq5_nHJHVfcy7QPt_OBHhBrE'
        };

        final verifierKey = JsonWebKey.fromJson(keyDict);
        final alg = keyDict['crv'] == 'P-256' ? 'ES256' : 'ES256K';
        final did = 'did:ebsi:zmSKef6zQZDC66MppKLHou9zCwjYE4Fwar7NSVy2c7aya';
        final kid =
            'did:ebsi:zmSKef6zQZDC66MppKLHou9zCwjYE4Fwar7NSVy2c7aya#lD7U7tcVLZWmqECJYRyGeLnDcU4ETX3reBN3Zdd0iTU';

        final proofHeader = {
          'typ': 'JWT',
          'alg': alg,
          'jwk': keyJwk,
          'kid': kid
        };
        final payload = {
          'iss': did,
          'nonce': cNonce,
          'iat': DateTime.now().microsecondsSinceEpoch,
          'aud': issuer
        };
        final claims = new JsonWebTokenClaims.fromJson(payload);
// create a builder, decoding the JWT in a JWS, so using a
        // JsonWebSignatureBuilder
        final builder = new JsonWebSignatureBuilder();
// set the content
        builder.jsonContent = claims.toJson();

        builder.setProtectedHeader('typ', 'JWT');
        builder.setProtectedHeader('alg', alg);
        builder.setProtectedHeader('jwk', keyJwk);
        builder.setProtectedHeader('kid', kid);

        // add a key to sign, can only add one for JWT
        builder.addRecipient(
          verifierKey,
          algorithm: alg,
        );
        // build the jws
        var jws = builder.build();

        // output the compact serialization
        print('jwt compact serialization: ${jws.toCompactSerialization()}');
        final jwt = jws.toCompactSerialization();

        const String credentialUrl =
            'https://api-conformance.ebsi.eu/conformance/v2/issuer-mock/credential';
        final credentialHeaders = <String, dynamic>{
          'Conformance': conformance,
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        };

        final credentialData = <String, dynamic>{
          'type': credential_type,
          'format': 'jwt_vc',
          'proof': {'proof_type': 'jwt', 'jwt': jwt}
        };

        final dynamic credentialResponse = await client.post(credentialUrl,
            headers: credentialHeaders, data: credentialData);
        final storage = getSecureStorage;
        await storage.set('ebsiCredential', jsonEncode(credentialResponse));
        await storage.set('conformance', conformance);

        emit(state.copyWith(qrScanStatus: QrScanStatus.goBack));
      } else if (scannedResponse
          .startsWith('openid://?scope=openid&response_type=id_token')) {
        final keyDict = {
          'crv': 'P-256',
          'd': 'ZpntMmvHtDxw6przKSJY-zOHMrEZd8C47D3yuqAsqrw',
          'kty': 'EC',
          'x': 'NB1ylMveV4_PPYtx9KYEjoS1WWA8qN33SJav9opWTaM',
          'y': 'UtOG2jR3NHadMMJ7wdYEq5_nHJHVfcy7QPt_OBHhBrE'
        };

        final keyJwk = {
          'crv': 'P-256',
          'kty': 'EC',
          'x': 'NB1ylMveV4_PPYtx9KYEjoS1WWA8qN33SJav9opWTaM',
          'y': 'UtOG2jR3NHadMMJ7wdYEq5_nHJHVfcy7QPt_OBHhBrE'
        };

        final verifierKey = JsonWebKey.fromJson(keyDict);
        final alg = keyDict['crv'] == 'P-256' ? 'ES256' : 'ES256K';
        final did = 'did:ebsi:zmSKef6zQZDC66MppKLHou9zCwjYE4Fwar7NSVy2c7aya';
        final kid =
            'did:ebsi:zmSKef6zQZDC66MppKLHou9zCwjYE4Fwar7NSVy2c7aya#lD7U7tcVLZWmqECJYRyGeLnDcU4ETX3reBN3Zdd0iTU';
        final storage = getSecureStorage;
        final conformance = await storage.get('conformance') as String;
        final credentialJson = await storage.get('ebsiCredential') as String;
        final dynamic credentialResponse = jsonDecode(credentialJson);
        final String credential = credentialResponse['credential'] as String;
        // decode the jwt, note: this constructor can only be used for JWT inside JWS
        // structures
        final jwt = new JsonWebToken.unverified(credential);
        final claims = jwt.claims;
        final String audience = claims['iss'] as String;
        final uri = Uri.parse(scannedResponse);
        final redirectUri = uri.queryParameters['redirect_uri'];
        final clientId = uri.queryParameters['client_id'];
        final nonce = uri.queryParameters['nonce'];
        final claimsFromUri = uri.queryParameters['claims'];

        /// build id token
        final payload = {
          'iat': DateTime.now().millisecondsSinceEpoch,
          'aud': audience,
          'exp': DateTime.now().millisecondsSinceEpoch + 1000,
          'sub': did,
          'iss': 'https://self-issued.me/v2',
          'nonce': nonce,
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
        final verifierClaims = new JsonWebTokenClaims.fromJson(payload);
// create a builder, decoding the JWT in a JWS, so using a
        // JsonWebSignatureBuilder
        final builder = new JsonWebSignatureBuilder();
// set the content
        builder.jsonContent = verifierClaims.toJson();

        builder.setProtectedHeader('typ', 'JWT');
        builder.setProtectedHeader('alg', alg);
        builder.setProtectedHeader('jwk', keyJwk);
        builder.setProtectedHeader('kid', kid);

        // add a key to sign, can only add one for JWT
        builder.addRecipient(
          verifierKey,
          algorithm: alg,
        );
        // build the jws
        final jws = builder.build();

        // output the compact serialization
        final verifierIdJwt = jws.toCompactSerialization();

        /// build vp token
        final iat = DateTime.now().millisecondsSinceEpoch;
        final vpTokenPayload = {
          'iat': iat,
          'jti': 'http://example.org/presentations/talao/01',
          'nbf': iat - 10,
          'aud': audience,
          'exp': iat + 1000,
          'sub': did,
          'iss': did,
          'vp': {
            '@context': ['https://www.w3.org/2018/credentials/v1'],
            'id': 'http://example.org/presentations/talao/01',
            'type': ['VerifiablePresentation'],
            'holder': did,
            'verifiableCredential': [credential]
          },
          'nonce': nonce
        };
        final vpVerifierClaims = new JsonWebTokenClaims.fromJson(payload);
// create a builder, decoding the JWT in a JWS, so using a
        // JsonWebSignatureBuilder
        final vpBuilder = new JsonWebSignatureBuilder();
// set the content
        vpBuilder.jsonContent = vpVerifierClaims.toJson();

        vpBuilder.setProtectedHeader('typ', 'JWT');
        vpBuilder.setProtectedHeader('alg', alg);
        vpBuilder.setProtectedHeader('jwk', keyJwk);
        vpBuilder.setProtectedHeader('kid', kid);

        // add a key to sign, can only add one for JWT
        vpBuilder.addRecipient(
          verifierKey,
          algorithm: alg,
        );
        // build the jws
        final vpJws = vpBuilder.build();

        // output the compact serialization
        final verifierVpJwt = vpJws.toCompactSerialization();

        final responseHeaders = {
          'Conformance': conformance,
          'Content-Type': 'application/x-www-form-urlencoded',
        };

        final responseData = "id_token=$verifierIdJwt&vp_token=$verifierVpJwt";
        final dynamic verifierResponse = await client.post(redirectUri!,
            headers: responseHeaders, data: responseData);
        emit(state.copyWith(qrScanStatus: QrScanStatus.goBack));
      } else {
        await host(url: scannedResponse);
      }
    } on FormatException {
      log.i('Format Exception');
      emit(
        state.error(
          messageHandler: ResponseMessage(
            ResponseString.RESPONSE_STRING_THIS_QR_CODE_IS_NOT_SUPPORTED,
          ),
        ),
      );
    } catch (e) {
      log.i('Error -$e');
      if (e is MessageHandler) {
        emit(state.error(messageHandler: e));
      } else {
        emit(
          state.error(
            messageHandler: ResponseMessage(
              ResponseString
                  .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
            ),
          ),
        );
      }
    }
  }

  Future<void> host({required String? url}) async {
    emit(state.loading(isDeepLink: false));
    try {
      final isInternetAvailable = await isConnected();
      if (!isInternetAvailable) {
        throw NetworkException(
          message: NetworkError.NETWORK_ERROR_NO_INTERNET_CONNECTION,
        );
      }
      if (url == null || url.isEmpty) {
        throw ResponseMessage(
          ResponseString.RESPONSE_STRING_THIS_QR_CODE_IS_NOT_SUPPORTED,
        );
      } else {
        final uri = Uri.parse(url);
        await verify(uri: uri);
      }
    } on FormatException {
      emit(
        state.error(
          messageHandler: ResponseMessage(
            ResponseString.RESPONSE_STRING_THIS_QR_CODE_IS_NOT_SUPPORTED,
          ),
        ),
      );
    } catch (e) {
      if (e is MessageHandler) {
        emit(state.error(messageHandler: e));
      } else {
        emit(
          state.error(
            messageHandler: ResponseMessage(
              ResponseString
                  .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
            ),
          ),
        );
      }
    }
  }

  Future<void> deepLink() async {
    emit(state.loading(isDeepLink: true));
    final deepLinkUrl = deepLinkCubit.state;
    if (deepLinkUrl != '') {
      deepLinkCubit.resetDeepLink();
      try {
        final uri = Uri.parse(deepLinkUrl);
        await verify(uri: uri);
      } on FormatException {
        emit(
          state.error(
            messageHandler: ResponseMessage(
              ResponseString
                  .RESPONSE_STRING_THIS_URL_DOSE_NOT_CONTAIN_A_VALID_MESSAGE,
            ),
          ),
        );
      }
    }
  }

  Future<void> openidDeepLink() async {
    emit(state.loading(isDeepLink: true));
    final deepLinkUrl = deepLinkCubit.state;
    if (deepLinkUrl != '') {
      deepLinkCubit.resetDeepLink();
      try {
        final Dio client = Dio();
        final credentialType =
            Ebsi(client: client).getCredentialType(deepLinkUrl);
        print(credentialType);
      } on FormatException {
        emit(
          state.error(
            messageHandler: ResponseMessage(
              ResponseString
                  .RESPONSE_STRING_THIS_URL_DOSE_NOT_CONTAIN_A_VALID_MESSAGE,
            ),
          ),
        );
      }
    }
  }

  Future<void> emitError(MessageHandler messageHandler) async {
    emit(state.error(messageHandler: messageHandler));
  }

  Future<void> verify({
    required Uri? uri,
    bool isConnectionBridgeSSI = false,
  }) async {
    if (isConnectionBridgeSSI) {
      emit(state.loading(isDeepLink: isConnectionBridgeSSI));
    } else {
      emit(state.loading());
    }
    try {
      ///Check if SIOPV2 request
      if (uri?.queryParameters['scope'] == 'openid') {
        ///restrict non-enterprise user
        if (!profileCubit.state.model.isEnterprise) {
          throw ResponseMessage(
            ResponseString.RESPONSE_STRING_PERSONAL_OPEN_ID_RESTRICTION_MESSAGE,
          );
        }

        ///credential should not be empty since we have to present
        if (walletCubit.state.credentials.isEmpty) {
          emit(
            state.error(
              messageHandler: ResponseMessage(
                ResponseString.RESPONSE_STRING_CREDENTIAL_EMPTY_ERROR,
              ),
            ),
          );
          emit(
            state.copyWith(
              qrScanStatus: QrScanStatus.success,
              route: IssuerWebsitesPage.route(''),
            ),
          );

          return;
        }

        ///request attribute check
        if (requestAttributeExists()) {
          throw ResponseMessage(
            ResponseString.RESPONSE_STRING_SCAN_UNSUPPORTED_MESSAGE,
          );
        }

        ///request_uri attribute check
        if (!requestUriAttributeExists()) {
          throw ResponseMessage(
            ResponseString.RESPONSE_STRING_SCAN_UNSUPPORTED_MESSAGE,
          );
        }

        final sIOPV2Param = await getSIOPV2Parameters();

        ///check if claims exists
        if (sIOPV2Param.claims == null) {
          throw ResponseMessage(
            ResponseString.RESPONSE_STRING_SCAN_UNSUPPORTED_MESSAGE,
          );
        }

        final openIdCredential = getCredentialName(sIOPV2Param.claims!);
        final openIdIssuer = getIssuersName(sIOPV2Param.claims!);

        ///check if credential and issuer both are not present
        if (openIdCredential == '' && openIdIssuer == '') {
          throw ResponseMessage(
            ResponseString.RESPONSE_STRING_SCAN_UNSUPPORTED_MESSAGE,
          );
        }

        final selectedCredentials = <CredentialModel>[];
        for (final credentialModel in walletCubit.state.credentials) {
          final credentialTypeList = credentialModel.credentialPreview.type;
          final issuer = credentialModel.credentialPreview.issuer;

          ///credential and issuer provided in claims
          if (openIdCredential != '' && openIdIssuer != '') {
            if (credentialTypeList.contains(openIdCredential) &&
                openIdIssuer == issuer) {}
          }

          ///credential provided in claims
          if (openIdCredential != '' && openIdIssuer == '') {
            if (credentialTypeList.contains(openIdCredential)) {
              selectedCredentials.add(credentialModel);
            }
          }

          ///issuer provided in claims
          if (openIdCredential == '' && openIdIssuer != '') {
            if (openIdIssuer == issuer) {
              selectedCredentials.add(credentialModel);
            }
          }
        }

        if (selectedCredentials.isEmpty) {
          emit(
            state.copyWith(
              qrScanStatus: QrScanStatus.success,
              route: IssuerWebsitesPage.route(openIdCredential),
            ),
          );
          return;
        }

        emit(
          state.copyWith(
            qrScanStatus: QrScanStatus.success,
            route: SIOPV2CredentialPickPage.route(
              credentials: selectedCredentials,
              sIOPV2Param: sIOPV2Param,
              issuer: Issuer.emptyIssuer(uri.toString()),
            ),
          ),
        );
      } else {
        emit(state.acceptHost(uri: uri!));
      }
    } catch (e) {
      if (e is MessageHandler) {
        emit(state.error(messageHandler: e));
      } else {
        emit(
          state.error(
            messageHandler: ResponseMessage(
              ResponseString
                  .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
            ),
          ),
        );
      }
    }
  }

  Future<void> accept({
    required Uri uri,
    required Issuer issuer,
  }) async {
    emit(state.loading());
    final log = getLogger('QRCodeScanCubit - accept');

    late final dynamic data;

    try {
      final dynamic response = await client.get(uri.toString());
      data = response is String ? jsonDecode(response) : response;

      log.i('data - $data');
      if (data['credential_manifest'] != null) {
        log.i('credential_manifest is not null');
        final CredentialManifest credentialManifest =
            CredentialManifest.fromJson(
          data['credential_manifest'] as Map<String, dynamic>,
        );
        final PresentationDefinition? presentationDefinition =
            credentialManifest.presentationDefinition;
        if (presentationDefinition != null &&
            presentationDefinition.inputDescriptors.isNotEmpty) {
          for (final descriptor in presentationDefinition.inputDescriptors) {
            /// using JsonPath to find credential Name
            final dynamic json = jsonDecode(jsonEncode(descriptor.constraints));
            final dynamic credentialField =
                JsonPath(r'$..fields').read(json).first.value.toList().first;

            if (credentialField['filter'] == null) {
              continue;
            }

            final credentialName =
                credentialField['filter']['pattern'] as String;

            late CredentialSubjectType credentialSubjectType;

            for (final element in CredentialSubjectType.values) {
              if (credentialName == element.name) {
                credentialSubjectType = element;
                break;
              }
            }

            /// fetching all the credentials
            final CredentialsRepository repository =
                CredentialsRepository(getSecureStorage);

            final List<CredentialModel> allCredentials =
                await repository.findAll();

            bool isPresentable = false;

            for (final credential in allCredentials) {
              if (credentialSubjectType ==
                  credential.credentialPreview.credentialSubjectModel
                      .credentialSubjectType) {
                isPresentable = true;
                break;
              } else {
                isPresentable = false;
              }
            }
            if (!isPresentable) {
              emit(
                state.copyWith(
                  qrScanStatus: QrScanStatus.success,
                  route: MissingCredentialsPage.route(
                    credentialManifest: credentialManifest,
                  ),
                ),
              );
              return;
            }
          }
        }
      }

      switch (data['type']) {
        case 'CredentialOffer':
          log.i('Credential Offer');
          emit(
            state.copyWith(
              qrScanStatus: QrScanStatus.success,
              route: CredentialsReceivePage.route(
                uri: uri,
                preview: data as Map<String, dynamic>,
                issuer: issuer,
              ),
            ),
          );
          break;

        case 'VerifiablePresentationRequest':
          if (data['query'] != null) {
            queryByExampleCubit.setQueryByExampleCubit(
              (data['query']).first as Map<String, dynamic>,
            );
            log.i(data['query']);
            if (data['query'].first['type'] == 'DIDAuth') {
              log.i('DIDAuth');
              await scanCubit.askPermissionDIDAuthCHAPI(
                keyId: SecureStorageKeys.ssiKey,
                done: (done) {
                  log.i('done');
                },
                uri: uri,
                challenge: data['challenge'] as String,
                domain: data['domain'] as String,
              );
              emit(state.copyWith(qrScanStatus: QrScanStatus.idle));
            } else if (data['query'].first['type'] == 'QueryByExample') {
              log.i('QueryByExample');
              emit(
                state.copyWith(
                  qrScanStatus: QrScanStatus.success,
                  route: QueryByExamplePresentPage.route(
                    uri: uri,
                    preview: data as Map<String, dynamic>,
                    issuer: issuer,
                  ),
                ),
              );
            } else {
              throw ResponseMessage(
                ResponseString.RESPONSE_STRING_UNIMPLEMENTED_QUERY_TYPE,
              );
            }
          } else {
            emit(
              state.copyWith(
                qrScanStatus: QrScanStatus.success,
                route: QueryByExamplePresentPage.route(
                  uri: uri,
                  preview: data as Map<String, dynamic>,
                  issuer: issuer,
                ),
              ),
            );
          }
          break;
        case 'object':
          log.i('object');
          emit(
            state.copyWith(
              qrScanStatus: QrScanStatus.success,
              route: CredentialsReceivePage.route(
                uri: uri,
                preview: data as Map<String, dynamic>,
                issuer: issuer,
              ),
            ),
          );
          break;

        default:
          throw ResponseMessage(
            ResponseString.RESPONSE_STRING_SCAN_UNSUPPORTED_MESSAGE,
          );
      }
    } catch (e) {
      log.e(
        'An error occurred while connecting to the server. ${e.toString()}',
      );
      if (e is MessageHandler) {
        emit(state.error(messageHandler: e));
      } else {
        emit(
          state.error(
            messageHandler: ResponseMessage(
              ResponseString
                  .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
            ),
          ),
        );
      }
    }
  }

  bool requestAttributeExists() {
    var condition = false;
    state.uri!.queryParameters.forEach((key, value) {
      if (key == 'request') {
        condition = true;
      }
    });
    return condition;
  }

  bool requestUriAttributeExists() {
    var condition = false;
    state.uri!.queryParameters.forEach((key, value) {
      if (key == 'request_uri') {
        condition = true;
      }
    });
    return condition;
  }

  Future<SIOPV2Param> getSIOPV2Parameters() async {
    String? nonce;
    String? redirect_uri;
    String? request_uri;
    String? claims;
    String? requestUriPayload;

    state.uri!.queryParameters.forEach((key, value) {
      if (key == 'nonce') {
        nonce = value;
      }
      if (key == 'redirect_uri') {
        redirect_uri = value;
      }
      if (key == 'claims') {
        claims = value;
      }
      if (key == 'request_uri') {
        request_uri = value;
      }
    });

    if (request_uri != null) {
      final dynamic encodedData =
          await fetchRequestUriPayload(url: request_uri!);
      if (encodedData != null) {
        requestUriPayload = decoder(token: encodedData as String);
      }
    }
    return SIOPV2Param(
      claims: claims,
      nonce: nonce,
      redirect_uri: redirect_uri,
      request_uri: request_uri,
      requestUriPayload: requestUriPayload,
    );
  }

  Future<dynamic> fetchRequestUriPayload({required String url}) async {
    final log = getLogger('QRCodeScanCubit - fetchRequestUriPayload');
    late final dynamic data;

    try {
      final dynamic response = await requestClient.get(url);
      data = response.toString();
    } catch (e) {
      log.e('An error occurred while connecting to the server.', e);
    }
    return data;
  }

  String decoder({required String token}) {
    final log = getLogger('QRCodeScanCubit - jwtDecode');
    late final String data;

    try {
      final payload = jwtDecode.parseJwt(token);
      data = payload.toString();
    } catch (e) {
      log.e('An error occurred while decoding.', e);
    }
    return data;
  }
}
