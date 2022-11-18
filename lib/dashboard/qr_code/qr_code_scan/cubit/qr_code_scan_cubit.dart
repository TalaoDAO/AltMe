import 'dart:convert';
import 'dart:typed_data';

import 'package:altme/app/app.dart';
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
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:jose/jose.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:json_path/json_path.dart';
import 'package:jwt_decode/jwt_decode.dart';

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
          NetworkError.NETWORK_ERROR_NO_INTERNET_CONNECTION,
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
      }
      if (scannedResponse.startsWith('openid://')) {
        // EBSI
        final String conformance = '5d7e7d6f-2969-427e-b8ef-7a8616d40e71';

// wallet key
        final KEY_DICT = {
          'crv': 'secp256k1',
          'd': 'lbuGEjEsYQ205boyekj8qdCwB2Uv7L2FwHUNleJj_Z0',
          'kty': 'EC',
          'x': 'AARiMrLNsRka9wMEoSgMnM7BwPug4x9IqLDwHVU-1A4',
          'y': 'vKMstC3TEN3rVW32COQX002btnU70v6P73PMGcUoZQs',
          'alg': 'ES256'
        };

// pour calculer did:ebsi
        String thumbprint_ebsi(String jwk) {
          ///    https://www.rfc-editor.org/rfc/rfc7638.html

          final Map<String, dynamic> jwk2 =
              jsonDecode(jwk) as Map<String, dynamic>;
          final int x = jwk2['x'] as int;
          final int y = jwk2['y'] as int;
          final Map<String, dynamic> JWK = {
            'crv': 'P-256',
            'kty': 'EC',
            'x': x,
            'y': y,
          } as Map<String, dynamic>;
          final dynamic claims = JsonWebTokenClaims.fromJson(JWK);
// create a builder, decoding the JWT in a JWS, so using a
          // JsonWebSignatureBuilder
          final builder = JsonWebSignatureBuilder();

          // set the content
          builder.jsonContent = claims.toJson();

          // add a key to sign, can only add one for JWT
          // builder.addRecipient(
          //   JsonWebKey.fromJson(jsonDecode(ssiKey!) as Map<String, dynamic>),
          //   algorithm: 'RS256',
          // );

          // build the jws
          final jws = builder.build();

          // output the compact serialization

          return jws.toCompactSerialization();
        }

        /// pour calculer did:ebsi (Natural Person)
        String didEbsi(String jwk) {
          // https://ec.europa.eu/digital-building-blocks/wikis/display/EBSIDOC/EBSI+DID+Method

          final Map<String, dynamic> jwk2 =
              jsonDecode(jwk) as Map<String, dynamic>;
          final String address = base58BitcoinEncode(
              Uint8List.fromList(utf8.encode(thumbprint_ebsi(jwk))));
          return 'did:ebsi:z$address';
// from py code:
          // return  'did:ebsi:z' + Base58BitcoinEncode(b'\x02' + bytes.fromhex(thumbprint_ebsi(jwk))).decode();
        }

        /// calcul did:ebsi
// final String did = didEbsi(KEY_DICT);
        final String did =
            'did:ebsi:zeGEwSVjZDxc5aDmBsRSvYtwvdSSmQw2k9A39vm4PwyAt';

// qrcode du test copliance

        final DioClient client = DioClient(
          Urls.tezToolBase,
          Dio(),
        );
        final uri = Uri.parse(scannedResponse);
        final String credentialTypeRequest =
            uri.queryParameters['credential_type']!;
        final dynamic response = await client.get(credentialTypeRequest);
        final Map<String, dynamic> credentialType = response is String
            ? jsonDecode(response) as Map<String, dynamic>
            : response as Map<String, dynamic>;
        // final String issuer = uri.queryParameters['issuer']!;
        const String ngrok = 'https://1253-77-140-52-235.ngrok.io';
        Future<Map<String, dynamic>> authorization_request(String ngrok,
            String conformance, String credentialTypeRequest) async {
          final headers = {
            'Conformance': conformance,
            'Content-Type': 'application/json'
          };
          const url =
              'https://api.conformance.intebsi.xyz/conformance/v2/issuer-mock/authorize';
          final Map<String, dynamic> request = {
            'scope': 'openid',
            'client_id': '$ngrok/callback',
            'response_type': 'code',
            'authorization_details': [
              {
                'type': 'openid_credential',
                'credential_type': credentialTypeRequest,
                'format': 'jwt_vc'
              }
            ],
            'redirect_uri': ngrok + '/callback',
            'state': '1234'
          } as Map<String, dynamic>;
          final dynamic resp =
              await client.get(url, headers: headers, queryParameters: request);
          return resp as Map<String, dynamic>;
        }

        Future<String> tokenRequest(String code, String ngrok) async {
          final headers = {
            'Conformance': conformance,
            'Content-Type': 'application/x-www-form-urlencoded'
          };
          final url =
              'https://api.conformance.intebsi.xyz/conformance/v2/issuer-mock/token';
          final data = {
            'code': code,
            'grant_type': 'authorization_code',
            'redirect_uri': '$ngrok/callback'
          };
          final dynamic resp =
              await client.post(url, headers: headers, data: data);
          return resp as String;
        }
// def build_proof(nonce) :
//     verifier_key = jwk.JWK(**KEY_DICT)
//     header = {
//         'typ' :'JWT',
//         'alg': 'ES256K',
//         'jwk' : {'crv':'secp256k1',
//                 'kty':'EC',
//                 'x':'AARiMrLNsRka9wMEoSgMnM7BwPug4x9IqLDwHVU-1A4',
//                 'y':'vKMstC3TEN3rVW32COQX002btnU70v6P73PMGcUoZQs'
//                 }
//     }
//     payload = {
//         'iss' : did,
//         'nonce' : nonce,
//         'iat': datetime.timestamp(datetime.now()),
//         'aud' : issuer
//     }
//     token = jwt.JWT(header=header,claims=payload, algs=['ES256K'])
//     token.make_signed_token(verifier_key)
//     return token.serialize()
// def credential_request(access_token, proof ) :
//     headers = {
//         'Conformance' : conformance,
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer ' + access_token
//         }
//     url = 'https://api.conformance.intebsi.xyz/conformance/v2/issuer-mock/credential'
//     data = { 'type' : credential_type,
//             'format' : 'jwt_vc',
//             'proof' : {
//                 'proof_type': 'jwt',
//                 'jwt': proof
//             }
//     }
//     resp = requests.post(url, headers=headers, data = json.dumps(data))
//     if resp.status_code == 200 :
//         return resp.json()
//     else :
//         return None
// # authorization request

        final auth = await authorization_request(
            ngrok, conformance, credentialTypeRequest);
        print(auth);
// @app.route('/callback' , methods=['GET', 'POST'])
// def callback() :
//     print('callback received')
//     // # code received
//     code = request.args['code']
//     // # access token request
//     result = tokenRequest(code, ngrok )
//     access_token = result['access_token']
//     c_nonce = result['c_nonce']
//     // # build proof of kety ownership
//     proof = build_proof(c_nonce)
//     // # credetial request
//     result = credential_request(access_token, proof )
//     print('credential = ', result)
//     return jsonify('ok')

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
          NetworkError.NETWORK_ERROR_NO_INTERNET_CONNECTION,
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
                  .RESPONSE_STRING_THIS_URL_DOSE_NOT_CONTAIN_A_VALID_MESSAGE, // ignore: lines_longer_than_80_chars
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
                  .RESPONSE_STRING_THIS_URL_DOSE_NOT_CONTAIN_A_VALID_MESSAGE, // ignore: lines_longer_than_80_chars
            ),
          ),
        );
      }
    }
  }

  Future<void> emitError(MessageHandler messageHandler) async {
    emit(state.error(messageHandler: messageHandler));
  }

  Future<void> verify({required Uri? uri, bool isBeaconSSI = false}) async {
    if (isBeaconSSI) {
      emit(state.loading(isDeepLink: isBeaconSSI));
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

        final openIdCredential = getCredential(sIOPV2Param.claims!);
        final openIdIssuer = getIssuer(sIOPV2Param.claims!);

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
                  .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER, // ignore: lines_longer_than_80_chars
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
      log.e('An error occurred while connecting to the server.', e);

      if (e is MessageHandler) {
        emit(state.error(messageHandler: e));
      } else {
        emit(
          state.error(
            messageHandler: ResponseMessage(
              ResponseString.RESPONSE_STRING_THIS_QR_CODE_IS_NOT_SUPPORTED,
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

  String getCredential(String claims) {
    final dynamic claimsJson = jsonDecode(claims);
    final fieldsPath = JsonPath(r'$..fields');
    final dynamic credentialField = fieldsPath
        .read(claimsJson)
        .first
        .value
        .where(
          (dynamic e) => e['path'].toString() == r'[$.credentialSubject.type]',
        )
        .toList()
        .first;
    return credentialField['filter']['pattern'] as String;
  }

  String getIssuer(String claims) {
    final dynamic claimsJson = jsonDecode(claims);
    final fieldsPath = JsonPath(r'$..fields');
    final dynamic issuerField = fieldsPath
        .read(claimsJson)
        .first
        .value
        .where(
          (dynamic e) => e['path'].toString() == r'[$.issuer]',
        )
        .toList()
        .first;
    return issuerField['filter']['pattern'] as String;
  }
}
