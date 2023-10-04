import 'dart:async';
import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/connection_bridge/connection_bridge.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/deep_link/deep_link.dart';
import 'package:altme/did/did.dart';
import 'package:altme/oidc4vc/oidc4vc.dart';
import 'package:altme/polygon_id/polygon_id.dart';
import 'package:altme/query_by_example/query_by_example.dart';
import 'package:altme/scan/scan.dart';
import 'package:beacon_flutter/beacon_flutter.dart';
import 'package:bloc/bloc.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:did_kit/did_kit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
    required this.oidc4vc,
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
  final OIDC4VC oidc4vc;

  final log = getLogger('QRCodeScanCubit');

  @override
  Future<void> close() async {
    //cancel streams
    return super.close();
  }

  Future<void> process({required String? scannedResponse}) async {
    log.i('processing scanned qr code - $scannedResponse');
    goBack();
    await Future<void>.delayed(const Duration(milliseconds: 500));
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
          message: ResponseString.RESPONSE_STRING_THIS_QR_CODE_IS_NOT_SUPPORTED,
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
          message: ResponseString.RESPONSE_STRING_THIS_QR_CODE_IS_NOT_SUPPORTED,
        ),
      );
    } catch (e, s) {
      log.e('Error -$e, stack: $s');
      if (e is MessageHandler) {
        emitError(e);
      } else {
        var message =
            ResponseString.RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER;

        if (e.toString().startsWith('Exception: VERIFICATION_ISSUE')) {
          message = ResponseString.RESPONSE_STRING_FAILED_TO_VERIFY_CREDENTIAL;
        } else if (e.toString().startsWith('Exception: INIT_ISSUE')) {
          message = ResponseString.RESPONSE_STRING_deviceIncompatibilityMessage;
        }
        emitError(ResponseMessage(message: message));
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
            message: ResponseString
                .RESPONSE_STRING_THIS_URL_DOSE_NOT_CONTAIN_A_VALID_MESSAGE,
          ),
        );
      }
    }
  }

  void emitError(dynamic e) {
    final messageHandler = getMessageHandler(e);

    emit(
      state.error(
        message: StateMessage.error(
          messageHandler: messageHandler,
          showDialog: true,
        ),
      ),
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
      /// SIOPV2 : wallet returns an id_token which is a simple jwt

      /// OIDC4VP : wallet returns one or several VP according to the request :
      /// the complex part is the syntax of teh request inside teh
      /// presentation_definition as the verifier can request with AND / OR as :
      /// i want to see your Passport OR your ID card AND your email pass...

      if (isSIOPV2OROIDC4VPUrl(uri)) {
        /// verfier case

        final String? requestUri = state.uri?.queryParameters['request_uri'];
        final String? request = state.uri?.queryParameters['request'];

        /// check if request uri is provided or not
        if (requestUri != null || request != null) {
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
      emitError(e);
    }
  }

  late dynamic encodedData;

  Future<void> accept({
    required Issuer issuer,
    required QRCodeScanCubit qrCodeScanCubit,
    OIDC4VCType? oidcType,
  }) async {
    emit(state.loading());
    final log = getLogger('QRCodeScanCubit - accept');

    late final dynamic data;

    try {
      if (isOIDC4VCIUrl(state.uri!)) {
        /// issuer side (oidc4VCI)

        if (oidcType != null) {
          await startOIDC4VCCredentialIssuance(
            scannedResponse: state.uri.toString(),
            isEBSIV3: oidcType == OIDC4VCType.EBSIV3,
            qrCodeScanCubit: qrCodeScanCubit,
          );
          return;
        }
      }

      if (isSIOPV2OROIDC4VPUrl(state.uri!)) {
        await startSIOPV2OIDC4VPProcess(state.uri!);
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
                message:
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
            message: ResponseString.RESPONSE_STRING_SCAN_UNSUPPORTED_MESSAGE,
          );
      }
    } catch (e) {
      log.e(
        'An error occurred while connecting to the server. $e',
      );
      emitError(e);
    }
  }

  Future<void> startOIDC4VCCredentialIssuance({
    required String scannedResponse,
    required bool isEBSIV3,
    required QRCodeScanCubit qrCodeScanCubit,
  }) async {
    emit(
      state.copyWith(
        uri: Uri.parse(scannedResponse),
        qrScanStatus: QrScanStatus.loading,
      ),
    );
    final Uri uriFromScannedResponse = Uri.parse(scannedResponse);
    final keys = <String>[];
    uriFromScannedResponse.queryParameters
        .forEach((key, value) => keys.add(key));

    dynamic credentialOfferJson;

    if (keys.contains('credential_offer') ||
        keys.contains('credential_offer_uri')) {
      credentialOfferJson = await getCredentialOfferJson(
        scannedResponse: scannedResponse,
        dioClient: client,
      );
      if (credentialOfferJson != null) {
        final dynamic preAuthorizedCodeGrant = credentialOfferJson['grants']
            ['urn:ietf:params:oauth:grant-type:pre-authorized_code'];

        bool? userPinRequired;

        if (preAuthorizedCodeGrant != null &&
            preAuthorizedCodeGrant is Map &&
            preAuthorizedCodeGrant.containsKey('user_pin_required')) {
          userPinRequired = preAuthorizedCodeGrant['user_pin_required'] as bool;
        }

        if (userPinRequired != null && userPinRequired) {
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
                    didKitProvider: didKitProvider,
                    qrCodeScanCubit: qrCodeScanCubit,
                    secureStorageProvider: getSecureStorage,
                    dioClient: client,
                    userPin: userPin,
                    oidc4vc: oidc4vc,
                    isEBSIV3: isEBSIV3,
                    credentialOfferJson: credentialOfferJson,
                  );
                },
              ),
            ),
          );
          return;
        }
      }
    }

    await initiateOIDC4VCCredentialIssuance(
      scannedResponse: scannedResponse,
      credentialsCubit: credentialsCubit,
      oidc4vc: oidc4vc,
      didKitProvider: didKitProvider,
      qrCodeScanCubit: qrCodeScanCubit,
      secureStorageProvider: getSecureStorage,
      dioClient: client,
      userPin: null,
      credentialOfferJson: credentialOfferJson,
      isEBSIV3: isEBSIV3,
    );
  }

  Future<void> startSIOPV2OIDC4VPProcess(Uri uri) async {
    final String? requestUri = uri.queryParameters['request_uri'];
    final String? request = uri.queryParameters['request'];
    dynamic responseType;

    /// check if request uri is provided or not
    if (requestUri != null || request != null) {
      /// verifier side (oidc4vp) or (siopv2 oidc4vc) with request_uri
      /// afer verification process
      final Map<String, dynamic> response =
          decodePayload(jwtDecode: jwtDecode, token: encodedData as String);
      encodedData = null;

      responseType = response['response_type'];
      final redirectUri = response['redirect_uri'];
      final scope = response['scope'];
      final responseUri = response['response_uri'];
      final responseMode = response['response_mode'];
      final nonce = response['nonce'];
      final clientId = response['client_id'];
      final claims = response['claims'];
      final stateValue = response['state'];
      final presentationDefinition = response['presentation_definition'];
      final presentationDefinitionUri = response['presentation_definition_uri'];
      final registration = response['registration'];

      final queryJson = <String, dynamic>{};

      if (scope != null) {
        queryJson['scope'] = scope;
      }

      if (clientId != null) {
        queryJson['client_id'] = clientId;
      }

      if (redirectUri != null) {
        queryJson['redirect_uri'] = redirectUri;
      }

      if (responseUri != null) {
        queryJson['response_uri'] = responseUri;
      }

      if (responseMode != null) {
        queryJson['response_mode'] = responseMode;
      }

      if (nonce != null) {
        queryJson['nonce'] = nonce;
      }

      if (stateValue != null) {
        queryJson['state'] = stateValue;
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

      if (presentationDefinitionUri != null) {
        queryJson['presentation_definition_uri'] = presentationDefinitionUri;
      }

      if (registration != null) {
        queryJson['registration'] = registration;
      }

      final String queryString = Uri(queryParameters: queryJson).query;

      final String newUrl = '$uri&$queryString';

      emit(
        state.copyWith(
          uri: Uri.parse(newUrl),
          qrScanStatus: QrScanStatus.loading,
        ),
      );
      log.i('uri - $newUrl');
    } else {
      responseType = uri.queryParameters['response_type'] ?? '';
    }

    /// check required keys available or not
    final keys = <String>[];
    state.uri?.queryParameters.forEach((key, value) => keys.add(key));

    if (!keys.contains('response_type')) {
      throw ResponseMessage(
        data: {
          'error': 'invalid_request',
          'error_description': 'The response_type is missing.',
        },
      );
    } else if (!keys.contains('client_id')) {
      throw ResponseMessage(
        data: {
          'error': 'invalid_request',
          'error_description': 'The client_id is missing.',
        },
      );
    }

    final String? responseMode = state.uri!.queryParameters['response_mode'];
    final bool correctResponeMode = responseMode != null &&
        (responseMode == 'post' || responseMode == 'direct_post');

    /// check response mode value
    if (!correctResponeMode) {
      throw ResponseMessage(
        data: {
          'error': 'unsupported_response_type',
          'error_description': 'The response mode is not supported.',
        },
      );
    }

    final registration = state.uri!.queryParameters['registration'];
    final bool isSecurityHigh = !profileCubit.state.model.isSecurityLow;

    if (registration != null) {
      final registrationMap = jsonDecode(registration) as Map<String, dynamic>;
      final data =
          registrationMap['subject_syntax_types_supported'] as List<dynamic>;
      if (!data.contains('did:key')) {
        if (isSecurityHigh) {
          throw ResponseMessage(
            data: {
              'error': 'unsupported_response_type',
              'error_description': 'The subject syntax type is not supported.',
            },
          );
        }
      }
    }

    final scope = uri.queryParameters['scope'];
    if (scope == null || scope != 'openid') {
      throw ResponseMessage(
        data: {
          'error': 'invalid_request',
          'error_description': 'The openid is requered in teh scope list.',
        },
      );
    }

    log.i('responseType - $responseType');
    if (responseType == 'id_token') {
      /// verifier side (siopv2)

      final String? redirectUri = getRedirectUri(state.uri!);

      if (redirectUri == null) {
        throw ResponseMessage(
          data: {
            'error': 'unsupported_response_type',
            'error_description': 'The redirect_uri is missing.',
          },
        );
      }

      final clientId = uri.queryParameters['client_id'];
      if (redirectUri != clientId) {
        throw ResponseMessage(
          data: {
            'error': 'invalid_request',
            'error_description': 'The client_id must be equal to redirect_uri.',
          },
        );
      }

      if (isSecurityHigh) {
        if (!keys.contains('nonce')) {
          throw ResponseMessage(
            data: {
              'error': 'invalid_request',
              'error_description': 'The nonce is missing.',
            },
          );
        }
      }

      await completeSiopV2Flow(redirectUri: redirectUri);
    } else if (responseType == 'vp_token' ||
        responseType == 'id_token vp_token') {
      /// responseType == 'vp_token' => verifier side (oidc4vp)
      ///
      /// responseType == 'id_token vp_token' => verifier side (oidc4vp)
      /// or (oidc4vp and siopv2)

      if (!keys.contains('nonce')) {
        throw ResponseMessage(
          data: {
            'error': 'invalid_request',
            'error_description': 'The nonce is missing.',
          },
        );
      }
      if (responseMode == 'direct_post') {
        final redirectUri = state.uri!.queryParameters['redirect_uri'];
        final responseUri = state.uri!.queryParameters['response_uri'];
        final bothPresent = redirectUri != null && responseUri != null;
        final bothAbsent = redirectUri == null && responseUri == null;

        if (bothPresent || bothAbsent) {
          throw ResponseMessage(
            data: {
              'error': 'invalid_request',
              'error_description': 'One cannot engage the flow if we dont have '
                  'the url to POST !',
            },
          );
        }
      }
      await launchOIDC4VPAndSIOPV2Flow(keys);
    } else {
      throw ResponseMessage(
        data: {
          'error': 'invalid_request',
          'error_description':
              'The response type supported is id_token, or vp_token or both.',
        },
      );
    }
  }

  Future<void> startOIDC4VCDeferedCredentialIssuance({
    required CredentialModel credentialModel,
  }) async {
    try {
      emit(state.loading());

      final OIDC4VCType? currentOIIDC4VCTypeForIssuance =
          await getOIDC4VCTypeForIssuance(
        url: credentialModel.pendingInfo!.url,
        client: client,
      );

      if (currentOIIDC4VCTypeForIssuance != null) {
        await getAndAddDefferedCredential(
          credentialModel: credentialModel,
          credentialsCubit: credentialsCubit,
          dioClient: client,
          oidc4vc: oidc4vc,
        );
      } else if (credentialModel.pendingInfo!.url
          .startsWith(Parameters.authorizeEndPoint)) {
        await getAndAddDefferedCredential(
          credentialModel: credentialModel,
          credentialsCubit: credentialsCubit,
          dioClient: client,
          oidc4vc: oidc4vc,
        );
      } else {
        emitError(
          ResponseMessage(
            message: ResponseString.RESPONSE_STRING_thisRequestIsNotSupported,
          ),
        );
      }
    } catch (e) {
      emitError(e);
    }
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

        final Filter filter =
            Filter.fromJson(credentialField['filter'] as Map<String, dynamic>);

        final credentialName = filter.pattern ?? filter.contains!.containsConst;

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
    required String? preAuthorizedCode,
    required String issuer,
    required bool isEBSIV3,
    required dynamic credentialOfferJson,
  }) {
    emit(
      state.copyWith(
        qrScanStatus: QrScanStatus.success,
        route: Oidc4vcCredentialPickPage.route(
          credentials: credentials,
          userPin: userPin,
          issuer: issuer,
          preAuthorizedCode: preAuthorizedCode,
          isEBSIV3: isEBSIV3,
          credentialOfferJson: credentialOfferJson,
        ),
      ),
    );
  }

  Future<void> launchOIDC4VPAndSIOPV2Flow(List<String> keys) async {
    late PresentationDefinition presentationDefinition;
    if (keys.contains('presentation_definition')) {
      final String presentationDefinitionValue =
          state.uri?.queryParameters['presentation_definition'] ?? '';

      final json = jsonDecode(presentationDefinitionValue.replaceAll("'", '"'))
          as Map<String, dynamic>;

      presentationDefinition = PresentationDefinition.fromJson(json);
    } else if (keys.contains('presentation_definition_uri')) {
      final presentationDefinitionUri =
          state.uri!.queryParameters['presentation_definition_uri'].toString();
      final dynamic response = await client.get(presentationDefinitionUri);

      final Map<String, dynamic> data = response == String
          ? jsonDecode(response.toString()) as Map<String, dynamic>
          : response as Map<String, dynamic>;

      presentationDefinition = PresentationDefinition.fromJson(data);
    } else {
      throw ResponseMessage(
        data: {
          'error': 'invalid_request',
          'error_description':
              'The presentation_definition or presentation_definition_uri is '
                  'required, only one but one is required.',
        },
      );
    }

    if (presentationDefinition.inputDescriptors.isEmpty) {
      throw ResponseMessage(
        data: {
          'error': 'invalid_request',
          'error_description':
              'The nput_descriptors is required in the presentation_definition '
                  'object',
        },
      );
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

    final host = await getHost(uri: state.uri!, client: client);

    emit(
      state.copyWith(
        qrScanStatus: QrScanStatus.success,
        route: CredentialManifestOfferPickPage.route(
          uri: state.uri!,
          credential: credentialPreview,
          issuer: Issuer.emptyIssuer(host),
          inputDescriptorIndex: 0,
          credentialsToBePresented: [],
        ),
      ),
    );
  }

  /// verify jwt
  Future<void> verifyJWTBeforeLaunchingOIDC4VCANDSIOPV2Flow() async {
    final String? requestUri = state.uri?.queryParameters['request_uri'];
    final String? request = state.uri?.queryParameters['request'];

    if (requestUri != null) {
      encodedData = await fetchRequestUriPayload(url: requestUri);
    } else {
      encodedData = request;
    }

    final isSecurityLow = profileCubit.state.model.isSecurityLow;

    if (isSecurityLow) {
      emit(state.acceptHost());
    } else {
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
          emitError(
            ResponseMessage(
              message: ResponseString.RESPONSE_STRING_invalidRequest,
            ),
          );
        }
      } catch (e) {
        emitError(
          ResponseMessage(
            message: ResponseString.RESPONSE_STRING_invalidRequest,
          ),
        );
      }
    }
  }

  /// complete SIOPV2 Flow
  Future<void> completeSiopV2Flow({required String redirectUri}) async {
    try {
      final clientId = state.uri!.queryParameters['client_id'] ?? '';

      final nonce = state.uri?.queryParameters['nonce'];
      final stateValue = state.uri?.queryParameters['state'];

      final bool isEBSIV3 =
          await isEBSIV3ForVerifier(client: client, uri: state.uri!);

      final privateKey = await fetchPrivateKey(
        isEBSIV3: isEBSIV3,
        oidc4vc: oidc4vc,
        secureStorage: getSecureStorage,
      );

      final (did, kid) = await getDidAndKid(
        isEBSIV3: isEBSIV3,
        privateKey: privateKey,
        didKitProvider: didKitProvider,
      );

      final response = await oidc4vc.proveOwnershipOfKey(
        clientId: clientId,
        privateKey: privateKey,
        did: did,
        kid: kid,
        redirectUri: redirectUri,
        nonce: nonce!,
        stateValue: stateValue,
      );

      String? url;

      if (response.headers.map.containsKey('location') &&
          response.headers.map['location'] != null &&
          response.headers.map['location'] is List<dynamic> &&
          (response.headers.map['location']!).isNotEmpty) {
        url = response.headers.map['location']![0];
      }

      if (url != null) {
        final uri = Uri.parse(url);
        if (uri.toString().startsWith(Parameters.oidc4vcUniversalLink)) {
          await authorizedFlowCompletion(uri);
          return;
        }
      }

      emit(
        state.copyWith(
          qrScanStatus: QrScanStatus.success,
          message: StateMessage.success(
            messageHandler: ResponseMessage(
              message: ResponseString.RESPONSE_STRING_authenticationSuccess,
            ),
          ),
        ),
      );
      goBack();
    } catch (e) {
      emitError(e);
    }
  }

  Future<void> processSelectedCredentials({
    required List<dynamic> selectedCredentials,
    required bool isEBSIV3,
    required String? userPin,
    required String? preAuthorizedCode,
    required String issuer,
    required dynamic credentialOfferJson,
  }) async {
    try {
      if (preAuthorizedCode != null) {
        await addCredentialsInLoop(
          selectedCredentials: selectedCredentials,
          isEBSIV3: isEBSIV3,
          userPin: userPin,
          preAuthorizedCode: preAuthorizedCode,
          issuer: issuer,
          codeForAuthorisedFlow: null,
          codeVerifier: null,
        );
      } else {
        emit(state.loading());
        await getAuthorizationUriForIssuer(
          scannedResponse: state.uri.toString(),
          oidc4vc: oidc4vc,
          isEBSIV3: isEBSIV3,
          didKitProvider: didKitProvider,
          selectedCredentials: selectedCredentials,
          secureStorageProvider: secureStorageProvider,
          credentialOfferJson: credentialOfferJson,
          issuer: issuer,
        );
        goBack();
      }
    } catch (e) {
      emitError(e);
    }
  }

  Future<void> addCredentialsInLoop({
    required List<dynamic> selectedCredentials,
    required bool isEBSIV3,
    required String? userPin,
    required String? preAuthorizedCode,
    required String issuer,
    required String? codeForAuthorisedFlow,
    required String? codeVerifier,
  }) async {
    try {
      for (int i = 0; i < selectedCredentials.length; i++) {
        emit(state.loading());

        await getAndAddCredential(
          scannedResponse: state.uri.toString(),
          credentialsCubit: credentialsCubit,
          oidc4vc: oidc4vc,
          isEBSIV3: isEBSIV3,
          didKitProvider: didKitProvider,
          secureStorageProvider: getSecureStorage,
          credential: selectedCredentials[i],
          isLastCall: i + 1 == selectedCredentials.length,
          dioClient: client,
          userPin: userPin,
          issuer: issuer,
          preAuthorizedCode: preAuthorizedCode,
          codeForAuthorisedFlow: codeForAuthorisedFlow,
          codeVerifier: codeVerifier,
        );
      }

      oidc4vc.resetNonceAndAccessTokenAndAuthorizationDetails();
      goBack();
    } catch (e) {
      emitError(e);
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

  Future<void> authorizedFlowCompletion(Uri uri) async {
    final codeForAuthorisedFlow = uri.queryParameters['code'];
    final state = uri.queryParameters['state'];

    if (codeForAuthorisedFlow == null || state == null) {
      return;
    }
    await dotenv.load();
    final String authorizationUriSecretKey =
        dotenv.get('AUTHORIZATION_URI_SECRET_KEY');

    final jwt = JWT.verify(state, SecretKey(authorizationUriSecretKey));

    final payload = jwt.payload as Map<String, dynamic>;

    final containsAllRequiredKey = payload.containsKey('credentials') &&
        payload.containsKey('codeVerifier') &&
        payload.containsKey('issuer') &&
        payload.containsKey('isEBSIV3');

    if (!containsAllRequiredKey) {
      return;
    }

    final selectedCredentials = payload['credentials'] as List<dynamic>;
    final String codeVerifier = payload['codeVerifier'].toString();
    final String issuer = payload['issuer'].toString();
    final bool isEBSIV3 = payload['isEBSIV3'] as bool;

    await addCredentialsInLoop(
      selectedCredentials: selectedCredentials,
      userPin: null,
      issuer: issuer,
      preAuthorizedCode: null,
      isEBSIV3: isEBSIV3,
      codeForAuthorisedFlow: codeForAuthorisedFlow,
      codeVerifier: codeVerifier,
    );

    return;
  }
}
