import 'dart:async';
import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/connection_bridge/connection_bridge.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/deep_link/deep_link.dart';
import 'package:altme/did/did.dart';
import 'package:altme/issuer_websites_page/issuer_websites.dart';
import 'package:altme/oidc4vc/initiate_oidv4vc_credential_issuance.dart';
import 'package:altme/oidc4vc/verify_encoded_data.dart';
import 'package:altme/polygon_id/polygon_id.dart';
import 'package:altme/query_by_example/query_by_example.dart';
import 'package:altme/scan/scan.dart';
import 'package:beacon_flutter/beacon_flutter.dart';
import 'package:bloc/bloc.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:did_kit/did_kit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:json_path/json_path.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:secure_storage/secure_storage.dart';

part 'qr_code_scan_cubit.g.dart';
part 'qr_code_scan_state.dart';

class QRCodeScanCubit extends Cubit<QRCodeScanState> {
  QRCodeScanCubit({
    required this.client,
    required this.requestClient,
    required this.scanCubit,
    required this.profileCubit,
    required this.credentialsCubit,
    required this.queryByExampleCubit,
    required this.deepLinkCubit,
    required this.jwtDecode,
    required this.beacon,
    required this.walletConnectCubit,
    required this.secureStorageProvider,
    required this.polygonIdCubit,
    required this.didCubit,
    required this.didKitProvider,
  }) : super(const QRCodeScanState());

  final DioClient client;
  final DioClient requestClient;
  final ScanCubit scanCubit;
  final ProfileCubit profileCubit;
  final CredentialsCubit credentialsCubit;
  final QueryByExampleCubit queryByExampleCubit;
  final DeepLinkCubit deepLinkCubit;
  final JWTDecode jwtDecode;
  final Beacon beacon;
  final WalletConnectCubit walletConnectCubit;
  final SecureStorageProvider secureStorageProvider;
  final PolygonIdCubit polygonIdCubit;
  final DIDCubit didCubit;
  final DIDKitProvider didKitProvider;

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
        /// beacon
        final String pairingRequest =
            Uri.parse(scannedResponse).queryParameters['data'].toString();

        await beacon.pair(pairingRequest: pairingRequest);
        emit(state.copyWith(qrScanStatus: QrScanStatus.goBack));
      } else if (scannedResponse.startsWith('wc:') ||
          scannedResponse.startsWith('wc-altme:')) {
        /// wallet connect
        await walletConnectCubit.connect(scannedResponse);
        emit(state.copyWith(qrScanStatus: QrScanStatus.goBack));
      } else if (scannedResponse.startsWith('{"id":') ||
          scannedResponse.startsWith('{"body":{"') ||
          scannedResponse.startsWith('{"from": "did:polygonid:') ||
          scannedResponse.startsWith('{"to": "did:polygonid:') ||
          scannedResponse.startsWith('{"thid":') ||
          scannedResponse.startsWith('{"typ":') ||
          scannedResponse.startsWith('{"type":')) {
        /// polygon id
        emit(state.copyWith(qrScanStatus: QrScanStatus.goBack));
        await polygonIdCubit.polygonIdFunction(scannedResponse);
      } else if (scannedResponse.startsWith('${Urls.appDeepLink}?uri=')) {
        final url = Uri.decodeFull(
          scannedResponse.substring('${Urls.appDeepLink}?uri='.length),
        );
        await verify(uri: Uri.parse(url));
      } else {
        final uri = Uri.parse(scannedResponse);
        await verify(uri: uri);
      }
    } on FormatException {
      log.i('Format Exception');
      emitError(
        ResponseMessage(
          ResponseString.RESPONSE_STRING_THIS_QR_CODE_IS_NOT_SUPPORTED,
        ),
      );
    } catch (e, s) {
      log.e('Error -$e, stack: $s');
      if (e is MessageHandler) {
        emitError(e);
      } else {
        var message =
            ResponseString.RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER;

        if (e.toString() == 'Exception: VERIFICATION_ISSUE') {
          message = ResponseString.RESPONSE_STRING_FAILED_TO_VERIFY_CREDENTIAL;
        }

        if (e.toString().startsWith('Exception: INIT_ISSUE')) {
          message = ResponseString.RESPONSE_STRING_deviceIncompatibilityMessage;
        }
        emitError(ResponseMessage(message));
      }
    }
  }

  Future<void> deepLink() async {
    final deepLinkUrl = deepLinkCubit.state;
    if (deepLinkUrl != '') {
      emit(state.loading(isScan: false));
      deepLinkCubit.resetDeepLink();
      try {
        await verify(uri: Uri.parse(deepLinkUrl));
      } on FormatException {
        emitError(
          ResponseMessage(
            ResponseString
                .RESPONSE_STRING_THIS_URL_DOSE_NOT_CONTAIN_A_VALID_MESSAGE,
          ),
        );
      }
    }
  }

  void emitError(MessageHandler messageHandler) {
    emit(
      state.error(message: StateMessage.error(messageHandler: messageHandler)),
    );
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
      /// SIOPV2 : wallet returns an id_token which is a simple jwt

      ///OIDC4VP : wallet returns one or several VP according to the request :
      ///the complex part is the syntax of teh request inside teh
      /// presentation_definition as the verifier can request with AND / OR as :
      ///  i want to see your Passport OR your ID card AND your email pass...

      /// verifier side (siopv2) without request_uri
      if (state.uri?.queryParameters['scope'] == 'openid') {
        // Check if we can respond to presentation request:
        // having credentials?
        // having correct crv in ebsi key
        await launchOIDC4VPAndSiopV2RequestFlow();

        // final openIdCredential = getCredentialName(sIOPV2Param.claims!);
        // final openIdIssuer = getIssuersName(sIOPV2Param.claims!);

        // ///check if credential and issuer both are not present
        // if (openIdCredential == '' && openIdIssuer == '') {
        //   throw ResponseMessage(
        //     ResponseString.RESPONSE_STRING_SCAN_UNSUPPORTED_MESSAGE,
        //   );
        // }

        // final selectedCredentials = <CredentialModel>[];
        // for (final credentialModel in credentialsCubit.state.credentials) {
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
      } else if (state.uri.toString().startsWith('openid://') ||
          state.uri.toString().startsWith('openid-vc://')) {
        /// ebsi v2 presentation
        /// verifier side (siopv2) with request_uri

        await verifyOIDC4VPAndSiopv2Jwt(state.uri);
      } else {
        emit(state.acceptHost(isRequestVerified: true));
      }
    } catch (e) {
      log.e(e);
      if (e is MessageHandler) {
        emit(state.error(message: StateMessage.error(messageHandler: e)));
      } else {
        emit(
          state.error(
            message: StateMessage.error(
              messageHandler: ResponseMessage(
                ResponseString
                    .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
              ),
            ),
          ),
        );
      }
    }
  }

  Future<void> launchOIDC4VPAndSiopV2RequestFlow() async {
    // Check if we can respond to presentation request:
    // having credentials?
    // having correct crv in ebsi key

    final OIDC4VCType currentOIIDC4VCType =
        profileCubit.state.model.oidc4vcType;

    if (!state.uri
        .toString()
        .startsWith(currentOIIDC4VCType.presentationPrefix)) {
      emit(
        state.error(
          message: StateMessage.error(
            messageHandler: ResponseMessage(
              ResponseString
                  .RESPONSE_STRING_pleaseSwitchToCorrectOIDC4VCProfile,
            ),
            showDialog: false,
            duration: const Duration(seconds: 20),
          ),
        ),
      );
      return;
    }

    final isRequestValid =
        await isOIDC4VPAndSiopV2WithRequestURIValid(state.uri!);
    if (!isRequestValid) {
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

  Future<void> verifyOIDC4VPAndSiopv2Jwt(Uri? uri) async {
    final OIDC4VCType currentOIIDC4VCType =
        profileCubit.state.model.oidc4vcType;

    if (!state.uri
        .toString()
        .startsWith(currentOIIDC4VCType.presentationPrefix)) {
      emit(
        state.error(
          message: StateMessage.error(
            messageHandler: ResponseMessage(
              ResponseString
                  .RESPONSE_STRING_pleaseSwitchToCorrectOIDC4VCProfile,
            ),
            showDialog: false,
            duration: const Duration(seconds: 20),
          ),
        ),
      );
      return;
    }
    final requestUri = state.uri!.queryParameters['request_uri'].toString();

    encodedData = await fetchRequestUriPayload(url: requestUri);

    final Map<String, dynamic> payload =
        decodePayload(jwtDecode: jwtDecode, token: encodedData as String);

    final Map<String, dynamic> header =
        decodeHeader(jwtDecode: jwtDecode, token: encodedData as String);

    final String issuerDid = jsonEncode(payload['client_id']);
    final String issuerKid = jsonEncode(header['kid']);

    //check Signature
    try {
      final VerificationType isVerified = await verifyEncodedData(
        issuerDid,
        issuerKid,
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

  Future<void> accept({
    required Issuer issuer,
    required QRCodeScanCubit qrCodeScanCubit,
  }) async {
    emit(state.loading());
    final log = getLogger('QRCodeScanCubit - accept');

    late final dynamic data;

    try {
      OIDC4VCType? currentOIIDC4VCType;

      for (final oidc4vcType in OIDC4VCType.values) {
        if (oidc4vcType.isEnabled &&
            state.uri.toString().startsWith(oidc4vcType.offerPrefix)) {
          currentOIIDC4VCType = oidc4vcType;
        }
      }

      if (currentOIIDC4VCType != null) {
        /// issuer side (oidc4VCI)

        await initiateOIDC4VCCredentialIssuance(
          scannedResponse: state.uri.toString(),
          credentialsCubit: credentialsCubit,
          oidc4vcType: currentOIIDC4VCType,
          didKitProvider: didKitProvider,
          qrCodeScanCubit: qrCodeScanCubit,
          secureStorageProvider: getSecureStorage,
        );
        return;
      }

      if (state.uri.toString().startsWith('openid://')) {
        /// verifier side (OIDC4VP And siopv2) with request_uri
        await launchOIDC4VPAndSiopV2WithRequestUriFlow(state.uri);
        return;
      }

      if (state.uri.toString().startsWith('openid-vc://')) {
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
                (JsonPath(r'$..fields').read(json).first.value as List)
                    .toList()
                    .first;

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
        emitError(e);
      } else {
        emitError(
          ResponseMessage(
            ResponseString.RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
          ),
        );
      }
    }
  }

  void navigateToOidc4vcCredentialPickPage(List<dynamic> credentials) {
    emit(
      state.copyWith(
        qrScanStatus: QrScanStatus.success,
        route: Oidc4vcCredentialPickPage.route(credentials: credentials),
      ),
    );
  }

  Future<void> addCredentialsInLoop(List<dynamic> credentials) async {
    try {
      OIDC4VCType? currentOIIDC4VCType;
      for (final oidc4vcType in OIDC4VCType.values) {
        if (oidc4vcType.isEnabled &&
            state.uri.toString().startsWith(oidc4vcType.offerPrefix)) {
          currentOIIDC4VCType = oidc4vcType;
        }
      }

      if (currentOIIDC4VCType != null) {
        final OIDC4VC oidc4vc = currentOIIDC4VCType.getOIDC4VC;

        for (int i = 0; i < credentials.length; i++) {
          emit(state.loading());
          final credentialTypeOrId = credentials[i];
          await getAndAddCredential(
            scannedResponse: state.uri.toString(),
            credentialsCubit: credentialsCubit,
            oidc4vc: oidc4vc,
            oidc4vcType: currentOIIDC4VCType,
            didKitProvider: didKitProvider,
            secureStorageProvider: getSecureStorage,
            credentialTypeOrId: credentialTypeOrId.toString(),
            isLastCall: i + 1 == credentials.length,
          );
        }
        oidc4vc.resetNonceAndAccessToken();
        goBack();
      }
    } catch (e) {
      if (e is MessageHandler) {
        emit(state.copyWith(message: StateMessage.error(messageHandler: e)));
      } else {
        emit(
          state.copyWith(
            message: StateMessage.error(
              messageHandler: ResponseMessage(
                ResponseString
                    .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
              ),
            ),
          ),
        );
      }
    }
  }

  void goBack() {
    emit(state.copyWith(qrScanStatus: QrScanStatus.goBack));
  }

  Future<void> launchSiopV2WithRequestUriFlow(Uri? uri) async {
    try {
      final Map<String, dynamic> response =
          decodePayload(jwtDecode: jwtDecode, token: encodedData as String);

      final redirectUri = response['redirect_uri'] ?? '';
      final nonce = response['nonce'] ?? '';

      final OIDC4VCType currentOIIDC4VCType =
          profileCubit.state.model.oidc4vcType;

      final OIDC4VC oidc4vc = currentOIIDC4VCType.getOIDC4VC;
      final mnemonic =
          await getSecureStorage.get(SecureStorageKeys.ssiMnemonic);
      final privateKey = await oidc4vc.privateKeyFromMnemonic(
        mnemonic: mnemonic!,
        index: currentOIIDC4VCType.index,
      );

      const didMethod = AltMeStrings.defaultDIDMethod;
      final did = didKitProvider.keyToDID(didMethod, privateKey);
      final kid =
          await didKitProvider.keyToVerificationMethod(didMethod, privateKey);

      await oidc4vc.proveOwnershipOfDid(
        uri: uri!,
        privateKey: privateKey,
        did: did,
        kid: kid,
        redirectUri: redirectUri.toString(),
        nonce: nonce.toString(),
      );
      emit(
        state.copyWith(
          qrScanStatus: QrScanStatus.success,
          message: StateMessage.success(
            messageHandler: ResponseMessage(
              ResponseString.RESPONSE_STRING_authenticationSuccess,
            ),
          ),
        ),
      );
      goBack();
    } catch (e) {
      if (e is MessageHandler) {
        emitError(e);
      } else {
        emitError(
          ResponseMessage(
            ResponseString.RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
          ),
        );
      }
    }
  }

  Future<void> launchOIDC4VPAndSiopV2WithRequestUriFlow(Uri? uri) async {
    final Map<String, dynamic> response =
        decodePayload(jwtDecode: jwtDecode, token: encodedData as String);

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
    claims = claims
        .replaceAll("'email': None", "'email': 'None'")
        .replaceAll("'", '"');

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
        requestUriPayload =
            decodePayload(jwtDecode: jwtDecode, token: encodedData as String)
                .toString();
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

  Future<bool> isOIDC4VPAndSiopV2WithRequestURIValid(Uri uri) async {
    ///credential should not be empty since we have to present
    if (credentialsCubit.state.credentials.isEmpty) {
      // emitError(
      //   ResponseMessage(ResponseString.RESPONSE_STRING_CREDENTIAL_EMPTY_ERROR),
      // );

      return false;
    }

    ///request attribute check
    if (requestAttributeExists(uri)) {
      // emitError(
      //   ResponseMessage(
      //     ResponseString.RESPONSE_STRING_SCAN_UNSUPPORTED_MESSAGE,
      //   ),
      // );
      return false;
    }

    ///request_uri attribute check
    // if (!requestUriAttributeExists(uri)) {
    //   throw ResponseMessage(
    //     ResponseString.RESPONSE_STRING_SCAN_UNSUPPORTED_MESSAGE,
    //   );
    // }

    final sIOPV2Param = await getSIOPV2Parameters(uri);

    ///check if claims exists
    if (sIOPV2Param.claims == null) {
      // emitError(
      //   ResponseMessage(
      //     ResponseString.RESPONSE_STRING_SCAN_UNSUPPORTED_MESSAGE,
      //   ),
      // );
      return false;
    }
    return true;
  }
}
