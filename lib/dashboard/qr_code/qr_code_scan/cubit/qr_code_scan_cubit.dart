import 'dart:async';
import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/connection_bridge/connection_bridge.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/present/pick/credential_manifest/helpers/apply_submission_requirements.dart';
import 'package:altme/deep_link/deep_link.dart';
import 'package:altme/enterprise/cubit/enterprise_cubit.dart';
import 'package:altme/oidc4vc/oidc4vc.dart';
import 'package:altme/polygon_id/polygon_id.dart';
import 'package:altme/query_by_example/query_by_example.dart';
import 'package:altme/scan/scan.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:beacon_flutter/beacon_flutter.dart';
import 'package:bloc/bloc.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:did_kit/did_kit.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
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
    required this.didKitProvider,
    required this.oidc4vc,
    required this.walletCubit,
    required this.enterpriseCubit,
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
  final DIDKitProvider didKitProvider;
  final OIDC4VC oidc4vc;
  final WalletCubit walletCubit;
  final EnterpriseCubit enterpriseCubit;

  final log = getLogger('QRCodeScanCubit');

  @override
  Future<void> close() async {
    //cancel streams
    return super.close();
  }

  Future<void> process({required String? scannedResponse}) async {
    log.i('processing scanned qr code - $scannedResponse');
    goBack();
    await Future<void>.delayed(const Duration(milliseconds: 1000));
    emit(state.loading(isScan: true));
    try {
      final isInternetAvailable = await isConnectedToInternet();
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
      } else if (scannedResponse.startsWith('configuration://?')) {
        /// enterprise
        final uri = Uri.parse(scannedResponse);
        emit(state.copyWith(qrScanStatus: QrScanStatus.goBack));
        await enterpriseCubit.requestTheConfiguration(uri);
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
      emitError(e);
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

  Future<void> accept({
    required Issuer approvedIssuer,
    required QRCodeScanCubit qrCodeScanCubit,
    required dynamic credentialOfferJson,
    required OpenIdConfiguration? openIdConfiguration,
    required String? issuer,
    required String? preAuthorizedCode,
    OIDC4VCType? oidcType,
  }) async {
    emit(state.loading());
    final log = getLogger('QRCodeScanCubit - accept');

    late final dynamic data;

    try {
      if (isOIDC4VCIUrl(state.uri!) && oidcType != null) {
        /// issuer side (oidc4VCI)

        if (issuer == null) {
          throw ResponseMessage(
            data: {
              'error': 'invalid_issuer_metadata',
              'error_description': 'The issuer configuration is invalid.',
            },
          );
        }

        await startOIDC4VCCredentialIssuance(
          scannedResponse: state.uri.toString(),
          isEBSIV3: oidcType == OIDC4VCType.EBSIV3,
          qrCodeScanCubit: qrCodeScanCubit,
          oidc4vciDraftType: profileCubit.state.model.profileSetting
              .selfSovereignIdentityOptions.customOidc4vcProfile.oidc4vciDraft,
          credentialOfferJson: credentialOfferJson,
          openIdConfiguration: openIdConfiguration,
          issuer: issuer,
          preAuthorizedCode: preAuthorizedCode,
        );
        return;
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
        final isPresentable = await isVCPresentable(
          presentationDefinition: presentationDefinition,
          clientMetaData: null,
          vcFormatType: profileCubit.state.model.profileSetting
              .selfSovereignIdentityOptions.customOidc4vcProfile.vcFormatType,
        );

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
                issuer: approvedIssuer,
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

              final credentialSubjectType = getCredTypeFromName(credentialName);

              final isPresentable = await isCredentialPresentable(
                credentialSubjectType: credentialSubjectType,
                vcFormatType: profileCubit
                    .state
                    .model
                    .profileSetting
                    .selfSovereignIdentityOptions
                    .customOidc4vcProfile
                    .vcFormatType,
              );
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
                    issuer: approvedIssuer,
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
                  issuer: approvedIssuer,
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
                issuer: approvedIssuer,
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
    required OIDC4VCIDraftType oidc4vciDraftType,
    required dynamic credentialOfferJson,
    required OpenIdConfiguration? openIdConfiguration,
    required String issuer,
    required String? preAuthorizedCode,
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

    final customOidc4vcProfile = profileCubit.state.model.profileSetting
        .selfSovereignIdentityOptions.customOidc4vcProfile;

    if (keys.contains('credential_offer') ||
        keys.contains('credential_offer_uri')) {
      if (credentialOfferJson != null) {
        final grants = credentialOfferJson['grants'];

        dynamic preAuthorizedCodeGrant;

        if (grants != null && grants is Map) {
          preAuthorizedCodeGrant =
              grants['urn:ietf:params:oauth:grant-type:pre-authorized_code'];
          if (preAuthorizedCodeGrant != null &&
              preAuthorizedCodeGrant is Map &&
              preAuthorizedCodeGrant.containsKey('pre-authorized_code')) {
            preAuthorizedCode =
                preAuthorizedCodeGrant['pre-authorized_code'] as String;
          }
        }

        bool? userPinRequired;
        TxCode? txCode;

        if (preAuthorizedCodeGrant != null && preAuthorizedCodeGrant is Map) {
          if (preAuthorizedCodeGrant.containsKey('user_pin_required')) {
            userPinRequired =
                preAuthorizedCodeGrant['user_pin_required'] as bool;
          } else if (preAuthorizedCodeGrant.containsKey('tx_code')) {
            /// draft 13
            final txCodeMap = preAuthorizedCodeGrant['tx_code'];

            if (txCodeMap is Map<String, dynamic>) {
              txCode = TxCode.fromJson(txCodeMap);
              userPinRequired = true;
            }
          }
        }

        if (userPinRequired != null && userPinRequired) {
          emit(
            state.copyWith(
              qrScanStatus: QrScanStatus.success,
              route: UserPinPage.route(
                txCode: txCode,
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
                    cryptoHolderBinding:
                        customOidc4vcProfile.cryptoHolderBinding,
                    oidc4vciDraftType: oidc4vciDraftType,
                    profileCubit: profileCubit,
                    openIdConfiguration: openIdConfiguration,
                    preAuthorizedCode: preAuthorizedCode,
                    issuer: issuer,
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
      cryptoHolderBinding: customOidc4vcProfile.cryptoHolderBinding,
      oidc4vciDraftType: oidc4vciDraftType,
      profileCubit: profileCubit,
      openIdConfiguration: openIdConfiguration,
      preAuthorizedCode: preAuthorizedCode,
      issuer: issuer,
    );
  }

  Future<void> startSIOPV2OIDC4VPProcess(Uri uri) async {
    final String? requestUri = uri.queryParameters['request_uri'];
    final String? request = uri.queryParameters['request'];

    /// check if request uri is provided or not
    if (requestUri != null || request != null) {
      late dynamic encodedData;

      if (request != null) {
        encodedData = request;
      } else if (requestUri != null) {
        encodedData = await fetchRequestUriPayload(
          url: requestUri,
          client: client,
        );
      }

      /// verifier side (oidc4vp) or (siopv2 oidc4vc) with request_uri
      /// afer verification process
      final Map<String, dynamic> response = decodePayload(
        jwtDecode: jwtDecode,
        token: encodedData as String,
      );

      final String newUrl = getUpdatedUrlForSIOPV2OIC4VP(
        uri: uri,
        response: response,
      );

      emit(
        state.copyWith(
          uri: Uri.parse(newUrl),
          qrScanStatus: QrScanStatus.loading,
        ),
      );
      log.i('uri - $newUrl');
    }

    final responseType = state.uri?.queryParameters['response_type'] ?? '';

    /// check required keys available or not
    final keys = <String>[];
    state.uri?.queryParameters.forEach((key, value) => keys.add(key));

    // if (keys.contains('claims')) {
    //   /// claims is old standard
    //   throw ResponseMessage(
    //     message: ResponseString.RESPONSE_STRING_thisRequestIsNotSupported,
    //   );
    // }

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
        (responseMode == 'post' ||
            responseMode == 'direct_post' ||
            responseMode == 'direct_post.jwt');

    /// check response mode value
    if (!correctResponeMode) {
      throw ResponseMessage(
        data: {
          'error': 'unsupported_response_type',
          'error_description': 'The response mode is not supported.',
        },
      );
    }

    final bool isSecurityHigh = profileCubit.state.model.profileSetting
        .selfSovereignIdentityOptions.customOidc4vcProfile.securityLevel;

    final registration = state.uri!.queryParameters['registration'];

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

    final redirectUri = state.uri!.queryParameters['redirect_uri'];
    final responseUri = state.uri!.queryParameters['response_uri'];
    final clientId = state.uri!.queryParameters['client_id'];
    final isClientIdUrl = isURL(clientId.toString());

    /// id_token only
    if (isIDTokenOnly(responseType)) {
      if (redirectUri == null && responseUri == null) {
        throw ResponseMessage(
          data: {
            'error': 'invalid_request',
            'error_description':
                'Only response_uri or redirect_uri is required.',
          },
        );
      }

      if (isSecurityHigh && !keys.contains('nonce')) {
        throw ResponseMessage(
          data: {
            'error': 'invalid_request',
            'error_description': 'The nonce is missing.',
          },
        );
      }
    }

    /// contain id_token but may or may not contain vp_token
    if (hasIDToken(responseType)) {
      final scope = state.uri!.queryParameters['scope'];
      if (scope == null || !scope.contains('openid')) {
        throw ResponseMessage(
          data: {
            'error': 'invalid_request',
            'error_description':
                'The openid scope is required in the scope list.',
          },
        );
      }
    }

    /// contain vp_token but may or may not contain id_token
    if (hasVPToken(responseType)) {
      if (!keys.contains('nonce')) {
        throw ResponseMessage(
          data: {
            'error': 'invalid_request',
            'error_description': 'The nonce is missing.',
          },
        );
      }

      if (responseMode == 'direct_post') {
        final bothPresent = redirectUri != null && responseUri != null;
        final bothAbsent = redirectUri == null && responseUri == null;

        if (bothAbsent) {
          throw ResponseMessage(
            data: {
              'error': 'invalid_request',
              'error_description':
                  'The response_uri and redirect_uri are missing.',
            },
          );
        }

        if (bothPresent) {
          throw ResponseMessage(
            data: {
              'error': 'invalid_request',
              'error_description':
                  'Only response_uri or redirect_uri is required.',
            },
          );
        }
      }

      if (isSecurityHigh &&
          responseUri != null &&
          isClientIdUrl &&
          !responseUri.contains(clientId.toString())) {
        throw ResponseMessage(
          data: {
            'error': 'invalid_request',
            'error_description': 'The client_id must be equal to response_uri.',
          },
        );
      }
    }

    /// contain vp_token or id_token
    if (hasIDTokenOrVPToken(responseType)) {
      if (isSecurityHigh &&
          redirectUri != null &&
          isClientIdUrl &&
          !redirectUri.contains(clientId.toString())) {
        throw ResponseMessage(
          data: {
            'error': 'invalid_request',
            'error_description': 'The client_id must be equal to redirect_uri.',
          },
        );
      }
    }

    log.i('responseType - $responseType');
    if (isIDTokenOnly(responseType)) {
      /// verifier side (siopv2)
      emit(state.copyWith(qrScanStatus: QrScanStatus.siopV2));
    } else if (isVPTokenOnly(responseType) ||
        isIDTokenAndVPToken(responseType)) {
      /// responseType == 'vp_token' => verifier side (oidc4vp)
      ///
      /// responseType == 'id_token vp_token' => verifier side (oidc4vp)
      /// or (oidc4vp and siopv2)

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

      final url = credentialModel.pendingInfo!.url;

      final customOidc4vcProfile = profileCubit.state.model.profileSetting
          .selfSovereignIdentityOptions.customOidc4vcProfile;

      final (
        _,
        OpenIdConfiguration? openIdConfiguration,
        OpenIdConfiguration? authorizationServerConfiguration,
        _,
        String? issuer,
        _,
      ) = await getIssuanceData(
        url: url,
        client: client,
        oidc4vc: oidc4vc,
        oidc4vciDraftType: customOidc4vcProfile.oidc4vciDraft,
      );

      if (openIdConfiguration != null) {
        await handleErrorForOID4VCI(
          url: url,
          openIdConfiguration: openIdConfiguration,
          authorizationServerConfiguration: authorizationServerConfiguration,
        );
      }

      await getAndAddDefferedCredential(
        credentialModel: credentialModel,
        credentialsCubit: credentialsCubit,
        issuer: issuer,
        oidc4vc: oidc4vc,
        jwtDecode: jwtDecode,
        blockchainType: walletCubit.state.currentAccount!.blockchainType,
        oidc4vciDraftType: customOidc4vcProfile.oidc4vciDraft,
      );
    } catch (e) {
      emitError(e);
    }
  }

  Future<bool> isVCPresentable({
    required VCFormatType vcFormatType,
    required PresentationDefinition? presentationDefinition,
    required Map<String, dynamic>? clientMetaData,
  }) async {
    if (presentationDefinition != null &&
        presentationDefinition.inputDescriptors.isNotEmpty) {
      final newPresentationDefinition =
          applySubmissionRequirements(presentationDefinition);

      final credentialList = credentialsCubit.state.credentials;
      for (var index = 0;
          index < newPresentationDefinition.inputDescriptors.length;
          index++) {
        final filteredCredentialList = getCredentialsFromPresentationDefinition(
          presentationDefinition: newPresentationDefinition,
          credentialList: List.from(credentialList),
          inputDescriptorIndex: index,
          clientMetaData: clientMetaData,
          vcFormatType: vcFormatType,
        );
        if (filteredCredentialList.isEmpty) {
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
    required OpenIdConfiguration openIdConfiguration,
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
          openIdConfiguration: openIdConfiguration,
        ),
      ),
    );
  }

  Future<void> launchOIDC4VPAndSIOPV2Flow(List<String> keys) async {
    if (!keys.contains('presentation_definition') &&
        !keys.contains('presentation_definition_uri')) {
      throw ResponseMessage(
        data: {
          'error': 'invalid_request',
          'error_description':
              'The presentation_definition or presentation_definition_uri is '
                  'required, only one but one is required.',
        },
      );
    }

    final Map<String, dynamic>? presentationDefinitionData =
        await getPresentationDefinition(
      client: client,
      uri: state.uri!,
    );

    if (presentationDefinitionData == null) {
      throw ResponseMessage(
        data: {
          'error': 'invalid_request',
          'error_description': 'Presentation definition is invalid',
        },
      );
    }

    final PresentationDefinition presentationDefinition =
        PresentationDefinition.fromJson(presentationDefinitionData);

    if (presentationDefinition.inputDescriptors.isEmpty) {
      throw ResponseMessage(
        data: {
          'error': 'invalid_request',
          'error_description':
              'The input_descriptors is required in the presentation_definition'
                  ' object',
        },
      );
    }

    if (presentationDefinition.inputDescriptors.isEmpty) {
      throw ResponseMessage(
        data: {
          'error': 'invalid_request',
          'error_description':
              'The input_descriptors is required in the presentation_definition'
                  ' object',
        },
      );
    }

    Map<String, dynamic>? clientMetaData;

    if (presentationDefinition.format == null) {
      clientMetaData = await getClientMetada(
        client: client,
        uri: state.uri!,
      );

      if (clientMetaData != null) {
        if (!clientMetaData.containsKey('vp_formats')) {
          throw ResponseMessage(
            data: {
              'error': 'invalid_request',
              'error_description': 'Format is missing.',
            },
          );
        }
      }
    }

    for (final descriptor in presentationDefinition.inputDescriptors) {
      if (descriptor.constraints == null) {
        throw ResponseMessage(
          data: {
            'error': 'invalid_request',
            'error_description': 'Presentation definition is invalid',
          },
        );
      }
    }

    final CredentialManifest credentialManifest = CredentialManifest(
      'id',
      IssuedBy('', ''),
      null,
      presentationDefinition,
    );

    final isPresentable = await isVCPresentable(
      presentationDefinition: presentationDefinition,
      clientMetaData: clientMetaData,
      vcFormatType: profileCubit.state.model.profileSetting
          .selfSovereignIdentityOptions.customOidc4vcProfile.vcFormatType,
    );

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
      data: const {},
      jwt: null,
      format: profileCubit
          .state
          .model
          .profileSetting
          .selfSovereignIdentityOptions
          .customOidc4vcProfile
          .vcFormatType
          .vcValue,
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

    late dynamic encodedData;

    if (request != null) {
      encodedData = request;
    } else if (requestUri != null) {
      encodedData = await fetchRequestUriPayload(
        url: requestUri,
        client: client,
      );
    }

    final customOidc4vcProfile = profileCubit.state.model.profileSetting
        .selfSovereignIdentityOptions.customOidc4vcProfile;

    final isSecurityEnabled = customOidc4vcProfile.securityLevel;

    if (isSecurityEnabled) {
      final Map<String, dynamic> payload =
          jwtDecode.parseJwt(encodedData as String);

      final String clientId = payload['client_id'].toString();

      //check Signature
      try {
        /// client_id_scheme = did, you need tio use the universal resolver
        ///
        /// client_id_scheme = redirect_uri
        /// (default case if no client_id_scheme)c you need to use the jwks
        ///
        /// client_id_scheme =  x509_san_dns, you need the key from the
        /// certificate
        ///
        /// client_id_scheme = verifier_attestation, the key will be in a
        /// jwt inside teh header
        ///
        /// if client_id starts with "did:" lets consider it is
        /// client_id_scheme n= did, universal resolver
        ///
        /// if client_id starts with http, lets consider it is
        /// client_id_scheme = redirect_uri, fetch jwks

        Map<String, dynamic>? publicKeyJwk;

        final clientIdScheme = payload['client_id_scheme'];

        if (clientIdScheme != null) {
          final Map<String, dynamic> header =
              decodeHeader(jwtDecode: jwtDecode, token: encodedData);

          if (clientIdScheme == 'x509_san_dns') {
            publicKeyJwk = await checkX509(
              clientId: clientId,
              encodedData: encodedData,
              header: header,
            );
          } else if (clientIdScheme == 'verifier_attestation') {
            publicKeyJwk = await checkVerifierAttestation(
              clientId: clientId,
              header: header,
              jwtDecode: jwtDecode,
            );
          }

          final VerificationType isVerified = await verifyEncodedData(
            issuer: clientId,
            jwtDecode: jwtDecode,
            jwt: encodedData,
            publicKeyJwk: publicKeyJwk,
          );

          if (isVerified != VerificationType.verified) {
            return emitError(
              ResponseMessage(
                message: ResponseString.RESPONSE_STRING_invalidRequest,
              ),
            );
          }
        }

        emit(state.acceptHost());
      } catch (e) {
        emitError(
          ResponseMessage(
            message: ResponseString.RESPONSE_STRING_invalidRequest,
          ),
        );
      }
    } else {
      emit(state.acceptHost());
    }
  }

  /// complete SIOPV2 Flow
  Future<void> completeSiopV2Flow() async {
    try {
      emit(state.loading());
      final redirectUri = state.uri!.queryParameters['redirect_uri'];
      final responseUri = state.uri!.queryParameters['response_uri'];

      final clientId = state.uri!.queryParameters['client_id'] ?? '';

      final nonce = state.uri?.queryParameters['nonce'];
      final stateValue = state.uri?.queryParameters['state'];

      // final bool? isEBSIV3 =
      //     await isEBSIV3ForVerifier(client: client, uri: state.uri!);

      final didKeyType = profileCubit.state.model.profileSetting
          .selfSovereignIdentityOptions.customOidc4vcProfile.defaultDid;

      final privateKey = await fetchPrivateKey(
        profileCubit: profileCubit,
        didKeyType: didKeyType,
      );

      final (did, kid) = await fetchDidAndKid(
        privateKey: privateKey,
        profileCubit: profileCubit,
        didKeyType: didKeyType,
      );

      final customOidc4vcProfile = profileCubit.state.model.profileSetting
          .selfSovereignIdentityOptions.customOidc4vcProfile;

      final Response<dynamic> response = await oidc4vc.siopv2Flow(
        clientId: clientId,
        privateKey: privateKey,
        did: did,
        kid: kid,
        redirectUri: redirectUri ?? responseUri!,
        nonce: nonce,
        stateValue: stateValue,
        clientType: customOidc4vcProfile.clientType,
        proofHeaderType: customOidc4vcProfile.proofHeader,
        dio: client.dio,
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
          await authorizedFlowStart(uri);
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
      final (
        clientId,
        clientSecret,
        authorization,
        oAuthClientAttestation,
        oAuthClientAttestationPop
      ) = await getClientDetails(
        profileCubit: profileCubit,
        isEBSIV3: isEBSIV3,
        issuer: issuer,
      );

      final customOidc4vcProfile = profileCubit.state.model.profileSetting
          .selfSovereignIdentityOptions.customOidc4vcProfile;

      if (preAuthorizedCode != null) {
        await addCredentialsInLoop(
          selectedCredentials: selectedCredentials,
          isEBSIV3: isEBSIV3,
          userPin: userPin,
          preAuthorizedCode: preAuthorizedCode,
          issuer: issuer,
          codeForAuthorisedFlow: null,
          codeVerifier: null,
          authorization: authorization,
          clientId: clientId ?? '',
          clientSecret: clientSecret,
          oAuthClientAttestation: oAuthClientAttestation,
          oAuthClientAttestationPop: oAuthClientAttestationPop,
        );
      } else {
        emit(state.loading());
        final scope = customOidc4vcProfile.scope;

        await getAuthorizationUriForIssuer(
          scannedResponse: state.uri.toString(),
          oidc4vc: oidc4vc,
          isEBSIV3: isEBSIV3,
          didKitProvider: didKitProvider,
          selectedCredentials: selectedCredentials,
          credentialOfferJson: credentialOfferJson,
          issuer: issuer,
          scope: scope,
          clientId: clientId,
          clientSecret: clientSecret,
          clientAuthentication: customOidc4vcProfile.clientAuthentication,
          oidc4vciDraftType: customOidc4vcProfile.oidc4vciDraft,
          vcFormatType: customOidc4vcProfile.vcFormatType,
          oAuthClientAttestation: oAuthClientAttestation,
          oAuthClientAttestationPop: oAuthClientAttestationPop,
          secureAuthorizedFlow: customOidc4vcProfile.pushAuthorizationRequest,
          client: client,
        );
        goBack();
      }
    } catch (e) {
      emitError(e);
    }
  }

  String? savedNonce;
  String? savedAccessToken;
  List<dynamic>? savedAuthorizationDetails;
  Completer<bool>? completer;

  Future<void> addCredentialsInLoop({
    required List<dynamic> selectedCredentials,
    required bool isEBSIV3,
    required String? userPin,
    required String? preAuthorizedCode,
    required String issuer,
    required String? codeForAuthorisedFlow,
    required String? codeVerifier,
    required String? authorization,
    required String? clientId,
    required String? clientSecret,
    String? oAuthClientAttestation,
    String? oAuthClientAttestationPop,
  }) async {
    try {
      for (int i = 0; i < selectedCredentials.length; i++) {
        emit(state.loading());

        final customOidc4vcProfile = profileCubit.state.model.profileSetting
            .selfSovereignIdentityOptions.customOidc4vcProfile;

        if (preAuthorizedCode != null ||
            (codeForAuthorisedFlow != null && codeVerifier != null)) {
          /// codeForAuthorisedFlow != null
          /// this is second phase flow for authorization_code
          /// first phase is need for the authentication
          ///
          /// preAuthorizedCode != null
          /// this is full phase flow for preAuthorizedCode

          /// get openid configuration
          final openIdConfiguration = await oidc4vc.getOpenIdConfig(
            baseUrl: issuer,
            isAuthorizationServer: false,
            dio: client.dio,
          );

          if (savedAccessToken == null) {
            /// get token response
            final (
              Map<String, dynamic>? tokenResponse,
              String? accessToken,
              String? cnonce,
              List<dynamic>? authorizationDetails,
            ) = await oidc4vc.getTokenResponse(
              preAuthorizedCode: preAuthorizedCode,
              issuer: issuer,
              clientId: clientId,
              clientSecret: clientSecret,
              userPin: userPin,
              code: codeForAuthorisedFlow,
              codeVerifier: codeVerifier,
              authorization: authorization,
              oidc4vciDraftType: customOidc4vcProfile.oidc4vciDraft,
              redirectUri: Parameters.oidc4vcUniversalLink,
              openIdConfiguration: openIdConfiguration,
              oAuthClientAttestation: oAuthClientAttestation,
              oAuthClientAttestationPop: oAuthClientAttestationPop,
              dio: client.dio,
            );

            savedAccessToken = accessToken;
            savedNonce = cnonce;
            savedAuthorizationDetails = authorizationDetails;

            if (profileCubit.state.model.isDeveloperMode) {
              completer = Completer<bool>();

              final formattedData =
                  getFormattedTokenResponse(tokenData: tokenResponse);
              emit(
                state.copyWith(
                  qrScanStatus: QrScanStatus.pauseForDialog,
                  dialogData: formattedData,
                ),
              );

              final value = await completer!.future;

              if (value) {
                completer = null;
              } else {
                completer = null;
                resetNonceAndAccessTokenAndAuthorizationDetails();
                goBack();
                return;
              }
            }
          }

          if (savedAccessToken == null) {
            throw ResponseMessage(
              data: {
                'error': 'invalid_request',
                'error_description': 'Access token is not provided.',
              },
            );
          }

          /// get credentials
          final (
            List<dynamic> encodedCredentialOrFutureTokens,
            String? deferredCredentialEndpoint,
            String format,
          ) = await getCredential(
            isEBSIV3: isEBSIV3,
            credential: selectedCredentials[i],
            issuer: issuer,
            cryptoHolderBinding: customOidc4vcProfile.cryptoHolderBinding,
            oidc4vciDraftType: customOidc4vcProfile.oidc4vciDraft,
            didKeyType: customOidc4vcProfile.defaultDid,
            clientId: clientId,
            profileCubit: profileCubit,
            accessToken: savedAccessToken!,
            nonce: savedNonce,
            authorizationDetails: savedAuthorizationDetails,
            openIdConfiguration: openIdConfiguration,
          );

          final lastElement = encodedCredentialOrFutureTokens.last;

          /// update nonce value
          if (lastElement is Map<String, dynamic>) {
            if (lastElement.containsKey('c_nonce')) {
              savedNonce = lastElement['c_nonce'].toString();
            }
          }

          if (profileCubit.state.model.isDeveloperMode) {
            completer = Completer<bool>();

            final formattedData = getFormattedCredentialResponse(
              credentialData: encodedCredentialOrFutureTokens,
            );
            emit(
              state.copyWith(
                qrScanStatus: QrScanStatus.pauseForDialog,
                dialogData: formattedData,
              ),
            );

            final value = await completer!.future;

            if (value) {
              completer = null;
            } else {
              completer = null;
              resetNonceAndAccessTokenAndAuthorizationDetails();
              goBack();
              return;
            }
          }

          /// add credentials
          await addCredentialData(
            scannedResponse: state.uri.toString(),
            accessToken: savedAccessToken!,
            credentialsCubit: credentialsCubit,
            secureStorageProvider: getSecureStorage,
            credential: selectedCredentials[i],
            isLastCall: i + 1 == selectedCredentials.length,
            issuer: issuer,
            jwtDecode: jwtDecode,
            blockchainType: walletCubit.state.currentAccount!.blockchainType,
            deferredCredentialEndpoint: deferredCredentialEndpoint,
            encodedCredentialOrFutureTokens: encodedCredentialOrFutureTokens,
            format: format,
            openIdConfiguration: openIdConfiguration,
          );
        } else {
          throw ResponseMessage(
            data: {
              'error': 'invalid_format',
              'error_description': 'Some issue with pre-authorization or '
                  'authorization flow parameters.',
            },
          );
        }
      }

      resetNonceAndAccessTokenAndAuthorizationDetails();
      goBack();
    } catch (e) {
      resetNonceAndAccessTokenAndAuthorizationDetails();
      emitError(e);
    }
  }

  void resetNonceAndAccessTokenAndAuthorizationDetails() {
    savedAccessToken = null;
    savedNonce = null;
    savedAuthorizationDetails = null;
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

  Future<void> authorizedFlowStart(Uri uri) async {
    emit(
      state.copyWith(
        uri: uri,
        qrScanStatus: QrScanStatus.authorizationFlow,
      ),
    );
  }

  Future<void> authorizedFlowCompletion({
    required Map<String, dynamic> statePayload,
    required String codeForAuthorisedFlow,
  }) async {
    try {
      final containsAllRequiredKey = statePayload.containsKey('credentials') &&
          statePayload.containsKey('codeVerifier') &&
          statePayload.containsKey('issuer') &&
          statePayload.containsKey('isEBSIV3');

      if (!containsAllRequiredKey) {
        throw ResponseMessage(
          data: {
            'error': 'invalid_request',
            'error_description': 'The state value is incorrect.',
          },
        );
      }

      final selectedCredentials = statePayload['credentials'] as List<dynamic>;
      final String codeVerifier = statePayload['codeVerifier'].toString();
      final String issuer = statePayload['issuer'].toString();
      final bool isEBSIV3 = statePayload['isEBSIV3'] as bool;
      final String? authorization = statePayload['authorization'] as String?;
      final String? clientId = statePayload['client_id'] as String?;
      final String? clientSecret = statePayload['client_secret'] as String?;
      final String? oAuthClientAttestation =
          statePayload['oAuthClientAttestation'] as String?;
      final String? oAuthClientAttestationPop =
          statePayload['oAuthClientAttestationPop'] as String?;

      await addCredentialsInLoop(
        selectedCredentials: selectedCredentials,
        userPin: null,
        issuer: issuer,
        preAuthorizedCode: null,
        isEBSIV3: isEBSIV3,
        codeForAuthorisedFlow: codeForAuthorisedFlow,
        codeVerifier: codeVerifier,
        authorization: authorization,
        clientId: clientId ?? '',
        clientSecret: clientSecret,
        oAuthClientAttestation: oAuthClientAttestation,
        oAuthClientAttestationPop: oAuthClientAttestationPop,
      );
    } catch (e) {
      emitError(e);
    }
  }
}
