import 'dart:async';
import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/connection_bridge/connection_bridge.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/deep_link/deep_link.dart';
import 'package:altme/did/did.dart';
import 'package:altme/oidc4vc/initiate_oidv4vc_credential_issuance.dart';
import 'package:altme/oidc4vc/verify_encoded_data.dart';
import 'package:altme/pin_code/pin_code.dart';
import 'package:altme/polygon_id/polygon_id.dart';
import 'package:altme/query_by_example/query_by_example.dart';
import 'package:altme/scan/scan.dart';
import 'package:beacon_flutter/beacon_flutter.dart';
import 'package:bloc/bloc.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:did_kit/did_kit.dart';
import 'package:dio/dio.dart';
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
      } else if (isPolygonIdUrl(scannedResponse)) {
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

  Future<void> verify({
    required Uri uri,
    bool? isScan,
  }) async {
    emit(
      state.copyWith(
        uri: uri,
        qrScanStatus: QrScanStatus.loading,
        isScan: isScan,
      ),
    );

    try {
      final isOID4VCUrl = state.uri.toString().startsWith('openid');

      /// SIOPV2 : wallet returns an id_token which is a simple jwt

      /// OIDC4VP : wallet returns one or several VP according to the request :
      /// the complex part is the syntax of teh request inside teh
      /// presentation_definition as the verifier can request with AND / OR as :
      /// i want to see your Passport OR your ID card AND your email pass...

      if (isOID4VCUrl &&
          (uri.toString().startsWith('openid://?') ||
              uri.toString().startsWith('openid-vc://?') ||
              uri.toString().startsWith('openid-hedera://?'))) {
        /// verfier case
        final OIDC4VCType currentOIIDC4VCType =
            profileCubit.state.model.oidc4vcType;

        /// checking if presentation prefix match for current OIDC4VC profile
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

        final String? requestUri = state.uri?.queryParameters['request_uri'];

        /// check if request uri is provided or not
        if (requestUri != null) {
          /// verifier side (oidc4vp) or (siopv2 oidc4vc) with request_uri
          /// verify the encoded data first
          await verifyJWTBeforeLaunchingOIDC4VCANDSIOPV2Flow();
          return;
        } else {
          emit(state.acceptHost());
        }
      } else {
        emit(state.acceptHost());
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

  late dynamic encodedData;

  Future<void> accept({
    required Issuer issuer,
    required QRCodeScanCubit qrCodeScanCubit,
    required DioClient dioClient,
  }) async {
    emit(state.loading());
    final log = getLogger('QRCodeScanCubit - accept');

    late final dynamic data;

    try {
      final OIDC4VCType? currentOIIDC4VCTypeForIssuance =
          getOIDC4VCTypeForIssuance(state.uri.toString());

      if (currentOIIDC4VCTypeForIssuance != null) {
        /// issuer side (oidc4VCI)

        await startOIDC4VCCredentialIssuance(
          scannedResponse: state.uri.toString(),
          currentOIIDC4VCType: currentOIIDC4VCTypeForIssuance,
          qrCodeScanCubit: qrCodeScanCubit,
          dioClient: dioClient,
        );
        return;
      }

      if (state.uri.toString().startsWith('openid://?') ||
          state.uri.toString().startsWith('openid-vc://?') ||
          state.uri.toString().startsWith('openid-hedera://?')) {
        final String? requestUri = state.uri?.queryParameters['request_uri'];
        dynamic responseType;

        /// check if request uri is provided or not
        if (requestUri != null) {
          /// verifier side (oidc4vp) or (siopv2 oidc4vc) with request_uri
          /// afer verification process
          final Map<String, dynamic> response =
              decodePayload(jwtDecode: jwtDecode, token: encodedData as String);
          encodedData = null;

          responseType = response['response_type'];
          final redirectUri = response['redirect_uri'];
          final nonce = response['nonce'];
          final clientId = response['client_id'];
          final claims = response['claims'];
          final presentationDefinition = response['presentation_definition'];

          final queryJson = <String, dynamic>{};
          if (redirectUri != null) {
            queryJson['redirect_uri'] = redirectUri;
          }
          if (nonce != null) {
            queryJson['nonce'] = nonce;
          }
          if (clientId != null) {
            queryJson['client_id'] = clientId;
          }
          if (responseType != null) {
            queryJson['response_type'] = responseType;
          }
          if (claims != null) {
            queryJson['claims'] = jsonEncode(claims).replaceAll('"', "'");
          }
          if (presentationDefinition != null) {
            queryJson['presentation_definition'] =
                jsonEncode(presentationDefinition).replaceAll('"', "'");
          }

          final String queryString = Uri(queryParameters: queryJson).query;

          final String newUrl = '${state.uri!}&$queryString';

          emit(state.copyWith(uri: Uri.parse(newUrl)));
          log.i('uri - $newUrl');
        } else {
          responseType = state.uri?.queryParameters['response_type'] ?? '';
        }

        log.i('responseType - $responseType');
        if (responseType == 'id_token') {
          /// verifier side (siopv2)

          await completeSiopV2Flow();
          return;
        } else if (responseType == 'vp_token') {
          /// verifier side (oidc4vp)
          await launchOIDC4VPAndSIOPV2Flow();
          return;
        } else if (responseType == 'id_token vp_token') {
          /// verifier side (oidc4vp) or (oidc4vp and siopv2)

          await launchOIDC4VPAndSIOPV2Flow();
          return;
        }
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
        final isPresentable = await isVCPresentable(presentationDefinition);

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

  Future<void> startOIDC4VCCredentialIssuance({
    required String scannedResponse,
    required OIDC4VCType currentOIIDC4VCType,
    required QRCodeScanCubit qrCodeScanCubit,
    required DioClient dioClient,
  }) async {
    switch (currentOIIDC4VCType) {
      case OIDC4VCType.DEFAULT:
      case OIDC4VCType.HEDERA:
        final dynamic credentialOfferJson = await getCredentialOfferJson(
          scannedResponse: scannedResponse,
          dioClient: dioClient,
        );
        if (credentialOfferJson == null) break;

        final dynamic userPinRequired = credentialOfferJson['grants']
                ['urn:ietf:params:oauth:grant-type:pre-authorized_code']
            ['user_pin_required'];

        if (userPinRequired == null) break;

        if (userPinRequired is bool && userPinRequired) {
          emit(
            state.copyWith(
              qrScanStatus: QrScanStatus.success,
              route: UserPinPage.route(
                onCancel: () {
                  goBack();
                },
                onProceed: (String userPin) async {
                  await initiateOIDC4VCCredentialIssuance(
                    scannedResponse: scannedResponse,
                    credentialsCubit: credentialsCubit,
                    oidc4vcType: currentOIIDC4VCType,
                    didKitProvider: didKitProvider,
                    qrCodeScanCubit: qrCodeScanCubit,
                    secureStorageProvider: getSecureStorage,
                    dioClient: dioClient,
                    userPin: userPin,
                  );
                },
              ),
            ),
          );
        } else {
          break;
        }

        return;

      case OIDC4VCType.GAIAX:
      case OIDC4VCType.EBSIV2:
      case OIDC4VCType.EBSIV3:
        break;

      case OIDC4VCType.JWTVC:
        throw Exception();
    }

    await initiateOIDC4VCCredentialIssuance(
      scannedResponse: scannedResponse,
      credentialsCubit: credentialsCubit,
      oidc4vcType: currentOIIDC4VCType,
      didKitProvider: didKitProvider,
      qrCodeScanCubit: qrCodeScanCubit,
      secureStorageProvider: getSecureStorage,
      dioClient: dioClient,
      userPin: null,
    );
  }

  Future<bool> isVCPresentable(
    PresentationDefinition? presentationDefinition,
  ) async {
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

        final credentialName = credentialField['filter']['pattern'] as String;

        final isPresentable = await isCredentialPresentable(credentialName);
        if (!isPresentable) {
          return false;
        }
      }
    }
    return true;
  }

  void navigateToOidc4vcCredentialPickPage({
    required List<dynamic> credentials,
    required String? userPin,
  }) {
    emit(
      state.copyWith(
        qrScanStatus: QrScanStatus.success,
        route: Oidc4vcCredentialPickPage.route(
          credentials: credentials,
          userPin: userPin,
        ),
      ),
    );
  }

  Future<void> launchOIDC4VPAndSIOPV2Flow() async {
    final OIDC4VCType currentOIIDC4VCType =
        profileCubit.state.model.oidc4vcType;
    final keys = <String>[];
    state.uri?.queryParameters.forEach((key, value) => keys.add(key));
    if (isUriAsValueValid(keys)) {
      late PresentationDefinition presentationDefinition;
      if (keys.contains('claims')) {
        // EBSIV2 normally
        var claims = state.uri?.queryParameters['claims'] ?? '';
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

        presentationDefinition =
            PresentationDefinition(inputDescriptors: inputDescriptorList);
      } else if (keys.contains('presentation_definition')) {
        final String presentationDefinitionValue =
            state.uri?.queryParameters['presentation_definition'] ?? '';

        final json =
            jsonDecode(presentationDefinitionValue.replaceAll("'", '"'))
                as Map<String, dynamic>;

        presentationDefinition = PresentationDefinition.fromJson(json);
      } else {
        throw Exception();
      }

      final CredentialManifest credentialManifest = CredentialManifest(
        'id',
        IssuedBy('', ''),
        null,
        presentationDefinition,
      );

      final isPresentable = await isVCPresentable(presentationDefinition);

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

      final CredentialModel credentialPreview = CredentialModel(
        id: 'id',
        image: 'image',
        credentialPreview: Credential.dummy(),
        shareLink: 'shareLink',
        display: Display.emptyDisplay(),
        data: const {},
        credentialManifest: credentialManifest,
      );

      final isJwtVpInJwtVCRequired =
          currentOIIDC4VCType.isJwtVpInJwtVCRequired(presentationDefinition);

      emit(
        state.copyWith(
          qrScanStatus: QrScanStatus.success,
          route: CredentialManifestOfferPickPage.route(
            uri: state.uri!,
            credential: credentialPreview,
            issuer: Issuer.emptyIssuer('domain'),
            inputDescriptorIndex: 0,
            credentialsToBePresented: [],
            isJwtVpInJwtVCRequired: isJwtVpInJwtVCRequired,
          ),
        ),
      );
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

  /// verify jwt
  Future<void> verifyJWTBeforeLaunchingOIDC4VCANDSIOPV2Flow() async {
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
        emit(state.acceptHost());
      } else {
        emit(state.acceptHost(isRequestVerified: false));
      }
    } catch (e) {
      emit(state.acceptHost());
    }
  }

  /// complete SIOPV2 Flow
  Future<void> completeSiopV2Flow() async {
    try {
      final redirectUri = state.uri?.queryParameters['redirect_uri'] ?? '';
      final nonce = state.uri?.queryParameters['nonce'] ?? '';
      final clientId = state.uri?.queryParameters['client_id'] ?? '';

      final keys = <String>[];
      state.uri?.queryParameters.forEach((key, value) => keys.add(key));

      if (!isUriAsValueValid(keys)) {
        throw Exception();
      }

      final OIDC4VCType currentOIIDC4VCType =
          profileCubit.state.model.oidc4vcType;

      final OIDC4VC oidc4vc = currentOIIDC4VCType.getOIDC4VC;
      final mnemonic =
          await getSecureStorage.get(SecureStorageKeys.ssiMnemonic);
      final privateKey = await oidc4vc.privateKeyFromMnemonic(
        mnemonic: mnemonic!,
        indexValue: currentOIIDC4VCType.indexValue,
      );

      const didMethod = AltMeStrings.defaultDIDMethod;
      final did = didKitProvider.keyToDID(didMethod, privateKey);
      final kid =
          await didKitProvider.keyToVerificationMethod(didMethod, privateKey);

      await oidc4vc.proveOwnershipOfDid(
        clientId: clientId,
        privateKey: privateKey,
        did: did,
        kid: kid,
        redirectUri: redirectUri,
        nonce: nonce,
        isEBSIV2: currentOIIDC4VCType == OIDC4VCType.EBSIV2,
        indexValue: currentOIIDC4VCType.indexValue,
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

  Future<void> addCredentialsInLoop({
    required List<dynamic> credentials,
    required String? userPin,
  }) async {
    try {
      final OIDC4VCType? currentOIIDC4VCTypeForIssuance =
          getOIDC4VCTypeForIssuance(state.uri.toString());

      if (currentOIIDC4VCTypeForIssuance != null) {
        final OIDC4VC oidc4vc = currentOIIDC4VCTypeForIssuance.getOIDC4VC;

        for (int i = 0; i < credentials.length; i++) {
          emit(state.loading());

          final (credential, credentialSupported, format) = getCredentialData(
            credential: credentials[i],
            oidc4vcType: currentOIIDC4VCTypeForIssuance,
          );

          await getAndAddCredential(
            scannedResponse: state.uri.toString(),
            credentialsCubit: credentialsCubit,
            oidc4vc: oidc4vc,
            oidc4vcType: currentOIIDC4VCTypeForIssuance,
            didKitProvider: didKitProvider,
            secureStorageProvider: getSecureStorage,
            credentialType: credential,
            isLastCall: i + 1 == credentials.length,
            dioClient: DioClient('', Dio()),
            userPin: userPin,
            credentialSupported: credentialSupported!,
            format: format!,
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

  void clearRoute() {
    emit(
      state.copyWith(
        qrScanStatus: QrScanStatus.idle,
        route: null,
      ),
    );
  }

  Future<dynamic> fetchRequestUriPayload({required String url}) async {
    final log = getLogger('QRCodeScanCubit - fetchRequestUriPayload');
    late final dynamic data;

    try {
      final dynamic response = await requestClient.get(url);
      data = response.toString();
    } catch (e, s) {
      log.e(
        'An error occurred while connecting to the server.',
        error: e,
        stackTrace: s,
      );
    }
    return data;
  }
}
