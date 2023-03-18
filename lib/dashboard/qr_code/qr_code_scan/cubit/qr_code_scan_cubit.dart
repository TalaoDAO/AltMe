import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/connection_bridge/connection_bridge.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/deep_link/deep_link.dart';
import 'package:altme/ebsi/initiate_ebsi_credential_issuance.dart';
import 'package:altme/ebsi/verify_encoded_data.dart';
import 'package:altme/issuer_websites_page/issuer_websites.dart';
import 'package:altme/query_by_example/query_by_example.dart';
import 'package:altme/scan/scan.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:beacon_flutter/beacon_flutter.dart';
import 'package:bloc/bloc.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:ebsi/ebsi.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
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
    required this.secureStorageProvider,
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
  final SecureStorageProvider secureStorageProvider;

  final log = getLogger('QRCodeScanCubit');

  @override
  Future<void> close() async {
    //cancel streams
    return super.close();
  }

  Future<void> process({required String? scannedResponse}) async {
    log.i('processing scanned qr code - $scannedResponse');
    emit(state.loading(isScan: true));
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
      } else {
        final uri = Uri.parse(scannedResponse);
        await verify(uri: uri);
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
      log.e('Error -$e');
      if (e is MessageHandler) {
        emit(state.error(messageHandler: e));
      } else {
        var message =
            ResponseString.RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER;

        if (e.toString() == 'Exception: VERIFICATION_ISSUE') {
          message = ResponseString.RESPONSE_STRING_FAILED_TO_VERIFY_CREDENTIAL;
        }

        emit(
          state.error(messageHandler: ResponseMessage(message)),
        );
      }
    }
  }

  Future<void> deepLink() async {
    final deepLinkUrl = deepLinkCubit.state;
    emit(state.loading(isScan: false));
    if (deepLinkUrl != '') {
      deepLinkCubit.resetDeepLink();
      try {
        await verify(uri: Uri.parse(deepLinkUrl));
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

  Future<void> verify({required Uri uri, bool? isScan}) async {
    emit(
      state.copyWith(
        uri: uri,
        qrScanStatus: QrScanStatus.loading,
        isScan: isScan,
      ),
    );

    try {
      /// verifier side (siopv2) without request_uri
      if (state.uri?.queryParameters['scope'] == 'openid') {
        // Check if we can respond to presentation request:
        // having credentials?
        // having correct crv in ebsi key
        await launchSiopV2RequestFlow();

        // final openIdCredential = getCredentialName(sIOPV2Param.claims!);
        // final openIdIssuer = getIssuersName(sIOPV2Param.claims!);

        // ///check if credential and issuer both are not present
        // if (openIdCredential == '' && openIdIssuer == '') {
        //   throw ResponseMessage(
        //     ResponseString.RESPONSE_STRING_SCAN_UNSUPPORTED_MESSAGE,
        //   );
        // }

        // final selectedCredentials = <CredentialModel>[];
        // for (final credentialModel in walletCubit.state.credentials) {
        //   final credentialTypeList = credentialModel.credentialPreview.type;
        //   final issuer = credentialModel.credentialPreview.issuer;

        //   ///credential and issuer provided in claims
        //   if (openIdCredential != '' && openIdIssuer != '') {
        //     if (credentialTypeList.contains(openIdCredential) &&
        //         openIdIssuer == issuer) {}
        //   }

        //   ///credential provided in claims
        //   if (openIdCredential != '' && openIdIssuer == '') {
        //     if (credentialTypeList.contains(openIdCredential)) {
        //       selectedCredentials.add(credentialModel);
        //     }
        //   }

        //   ///issuer provided in claims
        //   if (openIdCredential == '' && openIdIssuer != '') {
        //     if (openIdIssuer == issuer) {
        //       selectedCredentials.add(credentialModel);
        //     }
        //   }
        // }

        // if (selectedCredentials.isEmpty) {
        //   emit(
        //     state.copyWith(
        //       qrScanStatus: QrScanStatus.success,
        //       route: IssuerWebsitesPage.route(openIdCredential),
        //     ),
        //   );
        //   return;
        // }

        // emit(
        //   state.copyWith(
        //     qrScanStatus: QrScanStatus.success,
        //     route: SIOPV2CredentialPickPage.route(
        //       credentials: selectedCredentials,
        //       sIOPV2Param: sIOPV2Param,
        //       issuer: Issuer.emptyIssuer(uri.toString()),
        //     ),
        //   ),
        // );
      } else if (state.uri.toString().startsWith('openid://?client_id')) {
        /// ebsi presentation
        /// verifier side (siopv2) with request_uri
        await verifySiopv2Jwt(state.uri);
      } else {
        emit(state.acceptHost(isRequestVerified: true));
      }
    } catch (e) {
      log.e(e);
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

  Future<void> launchSiopV2RequestFlow() async {
    // Check if we can respond to presentation request:
    // having credentials?
    // having correct crv in ebsi key

    if (!await isSiopV2WithRequestURIValid(state.uri!)) {
      emit(
        state.copyWith(
          qrScanStatus: QrScanStatus.success,
          route: IssuerWebsitesPage.route(''),
        ),
      );
    } else {
      final claims = state.uri?.queryParameters['claims'] ?? '';
      await completeSiopV2WithClaim(claims: claims);
    }
  }

  late dynamic encodedData;

  Future<void> verifySiopv2Jwt(Uri? uri) async {
    final requestUri = state.uri!.queryParameters['request_uri'].toString();

    encodedData = await fetchRequestUriPayload(url: requestUri);

    final Map<String, dynamic> response = decoder(token: encodedData as String);

    final String issuerDid = jsonEncode(response['client_id']);

    //check Signature
    try {
      final VerificationType isVerified = await verifyEncodedData(
        issuerDid,
        client,
        secureStorageProvider,
        encodedData.toString(),
      );

      if (isVerified == VerificationType.verified) {
        emit(state.acceptHost(isRequestVerified: true));
      } else {
        emit(state.acceptHost(isRequestVerified: false));
      }
    } catch (e) {
      emit(state.acceptHost(isRequestVerified: false));
    }
  }

  Future<void> accept({required Issuer issuer}) async {
    emit(state.loading());
    final log = getLogger('QRCodeScanCubit - accept');

    late final dynamic data;

    try {
      /// ebsi credential
      /// issuer side (oidc4VCI)
      if (state.uri.toString().startsWith('openid://initiate_issuance?')) {
        await initiateEbsiCredentialIssuance(
          state.uri.toString(),
          client,
          walletCubit,
          getSecureStorage,
        );

        emit(state.copyWith(qrScanStatus: QrScanStatus.goBack));
        return;
      }

      if (state.uri.toString().startsWith('openid://?client_id')) {
        /// ebsi presentation
        /// verifier side (siopv2) with request_uri
        await launchSiopV2WithRequestUriFlow(state.uri);
        return;
      }

      /// did credential addition and presentation
      final dynamic response = await client.get(state.uri!.toString());
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

            final isPresentable = await isCredentialPresentable(credentialName);

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
                uri: state.uri!,
                preview: data as Map<String, dynamic>,
                issuer: issuer,
              ),
            ),
          );
          break;

        case 'VerifiablePresentationRequest':
          if (data['query'] != null) {
            final query =
                Query.fromJson(data['query'].first as Map<String, dynamic>);

            for (final credentialQuery in query.credentialQuery) {
              final String? credentialName = credentialQuery.example?.type;

              if (credentialName == null) {
                continue;
              }

              final isPresentable =
                  await isCredentialPresentable(credentialName);

              if (!isPresentable) {
                emit(
                  state.copyWith(
                    qrScanStatus: QrScanStatus.success,
                    route: MissingCredentialsPage.route(query: query),
                  ),
                );
                return;
              }
            }

            queryByExampleCubit.setQueryByExampleCubit(query);

            log.i(data['query']);
            if (data['query'].first['type'] == 'DIDAuth') {
              log.i('DIDAuth');
              await scanCubit.askPermissionDIDAuthCHAPI(
                keyId: SecureStorageKeys.ssiKey,
                done: (done) {
                  log.i('done');
                },
                uri: state.uri!,
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
                    uri: state.uri!,
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
                  uri: state.uri!,
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
                uri: state.uri!,
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
        'An error occurred while connecting to the server. $e',
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

  Future<void> launchSiopV2WithRequestUriFlow(Uri? uri) async {
    final Map<String, dynamic> response = decoder(token: encodedData as String);

    final String claims = jsonEncode(response['claims']);

    //update uri

    final redirectUri = response['redirect_uri'] ?? '';
    final nonce = response['nonce'] ?? '';

    final updatedUri = Uri.parse(
      '${state.uri}&redirect_uri=$redirectUri&nonce=$nonce',
    );

    emit(state.copyWith(uri: updatedUri));
    await completeSiopV2WithClaim(claims: claims);
  }

  Future<void> completeSiopV2WithClaim({required String claims}) async {
    // TODO(hawkbee): change when correction is done on verifier
    claims = claims.replaceAll("'email': None", "'email': 'None'");

    claims = claims.replaceAll("'", '"');
    final jsonPath = JsonPath(r'$..input_descriptors');
    final outputDescriptors =
        jsonPath.readValues(jsonDecode(claims)).first as List;
    final inputDescriptorList = outputDescriptors
        .map((e) => InputDescriptor.fromJson(e as Map<String, dynamic>))
        .toList();

    final PresentationDefinition presentationDefinition =
        PresentationDefinition(inputDescriptorList);
    final CredentialModel credentialPreview = CredentialModel(
      id: 'id',
      image: 'image',
      credentialPreview: Credential.dummy(),
      shareLink: 'shareLink',
      display: Display.emptyDisplay(),
      data: const {},
      credentialManifest: CredentialManifest(
        'id',
        IssuedBy('', ''),
        null,
        presentationDefinition,
      ),
    );
    emit(
      state.copyWith(
        qrScanStatus: QrScanStatus.success,
        route: CredentialManifestOfferPickPage.route(
          uri: state.uri!,
          credential: credentialPreview,
          issuer: Issuer.emptyIssuer('domain'),
          inputDescriptorIndex: 0,
          credentialsToBePresented: [],
        ),
      ),
    );
  }

  bool requestAttributeExists(Uri uri) {
    var condition = false;
    uri.queryParameters.forEach((key, value) {
      if (key == 'request') {
        condition = true;
      }
    });
    return condition;
  }

  bool requestUriAttributeExists(Uri uri) {
    var condition = false;
    uri.queryParameters.forEach((key, value) {
      if (key == 'request_uri') {
        condition = true;
      }
    });
    return condition;
  }

  Future<SIOPV2Param> getSIOPV2Parameters(Uri uri) async {
    String? nonce;
    String? redirect_uri;
    String? request_uri;
    String? claims;
    String? requestUriPayload;

    uri.queryParameters.forEach((key, value) {
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
        requestUriPayload = decoder(token: encodedData as String).toString();
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

  Map<String, dynamic> decoder({required String token}) {
    final log = getLogger('QRCodeScanCubit - jwtDecode');
    late final Map<String, dynamic> data;

    try {
      final payload = jwtDecode.parseJwt(token);
      data = payload;
    } catch (e) {
      log.e('An error occurred while decoding.', e);
    }
    return data;
  }

  Future<bool> isSiopV2WithRequestURIValid(Uri uri) async {
    bool isValid = true;

    ///credential should not be empty since we have to present
    if (walletCubit.state.credentials.isEmpty) {
      emit(
        state.error(
          messageHandler: ResponseMessage(
            ResponseString.RESPONSE_STRING_CREDENTIAL_EMPTY_ERROR,
          ),
        ),
      );
      isValid = false;
    }

    ///request attribute check
    if (requestAttributeExists(uri) && isValid) {
      isValid = false;
      emit(
        state.error(
          messageHandler: ResponseMessage(
            ResponseString.RESPONSE_STRING_SCAN_UNSUPPORTED_MESSAGE,
          ),
        ),
      );
    }

    ///request_uri attribute check
    // if (!requestUriAttributeExists(uri)) {
    //   throw ResponseMessage(
    //     ResponseString.RESPONSE_STRING_SCAN_UNSUPPORTED_MESSAGE,
    //   );
    // }

    final sIOPV2Param = await getSIOPV2Parameters(uri);

    ///check if claims exists
    if (sIOPV2Param.claims == null && isValid) {
      emit(
        state.error(
          messageHandler: ResponseMessage(
            ResponseString.RESPONSE_STRING_SCAN_UNSUPPORTED_MESSAGE,
          ),
        ),
      );
      isValid = false;
    }
    return isValid;
  }
}
