import 'dart:async';
import 'dart:convert';

import 'package:altme/ai/widget/ai_request_analysis_button.dart';
import 'package:altme/app/app.dart';
import 'package:altme/connection_bridge/connection_bridge.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/present/pick/credential_manifest/helpers/apply_submission_requirements.dart';
import 'package:altme/deep_link/deep_link.dart';
import 'package:altme/enterprise/cubit/enterprise_cubit.dart';
import 'package:altme/oidc4vc/helper_function/get_issuance_data.dart';
import 'package:altme/oidc4vc/oidc4vc.dart';
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
import 'package:json_path/json_path.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:secure_storage/secure_storage.dart';
part 'qr_code_scan_cubit.g.dart';
part 'qr_code_scan_state.dart';

class QRCodeScanCubit extends Cubit<QRCodeScanState> {
  QRCodeScanCubit({
    required this.client,
    required this.scanCubit,
    required this.profileCubit,
    required this.credentialsCubit,
    required this.queryByExampleCubit,
    required this.deepLinkCubit,
    required this.jwtDecode,
    required this.beacon,
    required this.walletConnectCubit,
    required this.secureStorageProvider,
    required this.didKitProvider,
    required this.oidc4vc,
    required this.walletCubit,
    required this.enterpriseCubit,
  }) : super(const QRCodeScanState());

  final DioClient client;
  final ScanCubit scanCubit;
  final ProfileCubit profileCubit;
  final CredentialsCubit credentialsCubit;
  final QueryByExampleCubit queryByExampleCubit;
  final DeepLinkCubit deepLinkCubit;
  final JWTDecode jwtDecode;
  final Beacon beacon;
  final WalletConnectCubit walletConnectCubit;
  final SecureStorageProvider secureStorageProvider;
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

  Future<void> process({
    required String? scannedResponse,
    required QRCodeScanCubit qrCodeScanCubit,
  }) async {
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
      } else if (scannedResponse
          .startsWith('${Parameters.universalLink}?uri=')) {
        final url = Uri.decodeFull(
          scannedResponse.substring('${Parameters.universalLink}?uri='.length),
        );
        await verify(uri: Uri.parse(url));
      } else if (scannedResponse.startsWith('configuration://?')) {
        /// enterprise
        final uri = Uri.parse(scannedResponse);
        emit(state.copyWith(qrScanStatus: QrScanStatus.goBack));
        await enterpriseCubit.requestTheConfiguration(
          uri: uri,
          qrCodeScanCubit: qrCodeScanCubit,
        );
      } else {
        final uri = Uri.parse(scannedResponse);
        await verify(uri: uri);
      }
    } on FormatException {
      log.i('Format Exception');
      emitError(
        error: ResponseMessage(
          message: ResponseString.RESPONSE_STRING_THIS_QR_CODE_IS_NOT_SUPPORTED,
        ),
        callToAction: AiRequestAnalysisButton(
          link: scannedResponse.toString(),
        ),
      );
    } catch (e, s) {
      log.e('Error -$e, stack: $s');
      emitError(
        error: e,
        callToAction: AiRequestAnalysisButton(
          link: scannedResponse.toString(),
        ),
      );
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
          error: ResponseMessage(
            message: ResponseString
                .RESPONSE_STRING_THIS_URL_DOSE_NOT_CONTAIN_A_VALID_MESSAGE,
          ),
          callToAction: AiRequestAnalysisButton(
            link: deepLinkUrl,
          ),
        );
      }
    }
  }

  void emitError({
    required dynamic error,
    Widget? callToAction,
  }) {
    final messageHandler = getMessageHandler(error);

    emit(
      state.error(
        message: StateMessage.error(
          messageHandler: messageHandler,
          showDialog: true,
          callToAction: profileCubit.state.model.isDeveloperMode &&
                  Parameters.isAIServiceEnabled
              ? callToAction
              : null,
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

      if (isSiopV2OrOidc4VpUrl(uri)) {
        /// verfier case

        final String? requestUri = state.uri?.queryParameters['request_uri'];
        final String? request = state.uri?.queryParameters['request'];

        /// check if request uri is provided or not
        if (requestUri != null || request != null) {
          /// verifier side (oidc4vp) or (siopv2 oidc4vc) with request_uri
          /// verify the encoded data first
          await verifyJWTBeforeLaunchingOIDC4VPANDSIOPV2Flow();
          return;
        } else {
          emit(state.acceptHost());
        }
      } else {
        emit(state.acceptHost());
      }
    } catch (e) {
      log.e(e);
      emitError(error: e);
    }
  }

  Future<void> acceptOidc4vci({
    required Oidc4vcParameters oidc4vcParameters,
    required Issuer approvedIssuer,
    required QRCodeScanCubit qrCodeScanCubit,
  }) async {
    emit(state.loading());
    final log = getLogger('QRCodeScanCubit - accept');

    late final dynamic data;

    final customOidc4vcProfile = profileCubit.state.model.profileSetting
        .selfSovereignIdentityOptions.customOidc4vcProfile;

    try {
      if (oidc4vcParameters.oidc4vcType != null) {
        /// issuer side (oidc4VCI)

        await startOIDC4VCCredentialIssuance(
          qrCodeScanCubit: qrCodeScanCubit,
          oidc4vcParameters: oidc4vcParameters,
        );
        return;
      }

      if (isSiopV2OrOidc4VpUrl(oidc4vcParameters.initialUri)) {
        await startSIOPV2OIDC4VPProcess(oidc4vcParameters.initialUri);
        return;
      }

      /// did credential addition and presentation
      final dynamic response =
          await client.get(oidc4vcParameters.initialUri.toString());
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
          formatsSupported: customOidc4vcProfile.formatsSupported ?? [],
        );

        if (!isPresentable) {
          emit(
            state.copyWith(
              qrScanStatus: QrScanStatus.idle,
              message: const StateMessage.info(
                stringMessage: 'The credential requested has not been found',
                showDialog: true,
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
                uri: oidc4vcParameters.initialUri,
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
                formatsSupported: customOidc4vcProfile.formatsSupported ?? [],
              );

              if (!isPresentable) {
                emit(
                  state.copyWith(
                    qrScanStatus: QrScanStatus.idle,
                    message: const StateMessage.info(
                      stringMessage:
                          'The credential requested has not been found',
                      showDialog: true,
                    ),
                  ),
                );
                return;
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
                  uri: oidc4vcParameters.initialUri,
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
                      uri: oidc4vcParameters.initialUri,
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
            }
          } else {
            emit(
              state.copyWith(
                qrScanStatus: QrScanStatus.success,
                route: QueryByExamplePresentPage.route(
                  uri: oidc4vcParameters.initialUri,
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
                uri: oidc4vcParameters.initialUri,
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
      emitError(
        error: e,
        callToAction: AiRequestAnalysisButton(
          link: oidc4vcParameters.initialUri.toString(),
        ),
      );
    }
  }

  Future<void> accept({
    required Issuer approvedIssuer,
    required QRCodeScanCubit qrCodeScanCubit,
    required dynamic credentialOfferJson,
    required OpenIdConfiguration? openIdConfiguration,
    required String? issuer,
    required String? preAuthorizedCode,
    required Uri uri,
    OIDC4VCType? oidcType,
  }) async {
    emit(state.loading());
    final log = getLogger('QRCodeScanCubit - accept');

    late final dynamic data;

    final customOidc4vcProfile = profileCubit.state.model.profileSetting
        .selfSovereignIdentityOptions.customOidc4vcProfile;

    try {
      if (isSiopV2OrOidc4VpUrl(uri)) {
        await startSIOPV2OIDC4VPProcess(uri);
        return;
      }

      /// did credential addition and presentation
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

        final isPresentable = await isVCPresentable(
          presentationDefinition: presentationDefinition,
          clientMetaData: null,
          formatsSupported: customOidc4vcProfile.formatsSupported ?? [],
        );

        if (!isPresentable) {
          emit(
            state.copyWith(
              qrScanStatus: QrScanStatus.idle,
              message: const StateMessage.info(
                stringMessage: 'The credential requested has not been found',
                showDialog: true,
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
                uri: uri,
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
                formatsSupported: customOidc4vcProfile.formatsSupported ?? [],
              );

              if (!isPresentable) {
                emit(
                  state.copyWith(
                    qrScanStatus: QrScanStatus.idle,
                    message: const StateMessage.info(
                      stringMessage:
                          'The credential requested has not been found',
                      showDialog: true,
                    ),
                  ),
                );
                return;
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
            }
          } else {
            emit(
              state.copyWith(
                qrScanStatus: QrScanStatus.success,
                route: QueryByExamplePresentPage.route(
                  uri: uri,
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
                uri: uri,
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
      emitError(
        error: e,
        callToAction: AiRequestAnalysisButton(link: uri.toString()),
      );
    }
  }

  Future<void> startOIDC4VCCredentialIssuance({
    required Oidc4vcParameters oidc4vcParameters,
    required QRCodeScanCubit qrCodeScanCubit,
  }) async {
    emit(
      state.copyWith(
        uri: Uri.parse(oidc4vcParameters.initialUri.toString()),
        qrScanStatus: QrScanStatus.loading,
      ),
    );

    final customOidc4vcProfile = profileCubit.state.model.profileSetting
        .selfSovereignIdentityOptions.customOidc4vcProfile;

    if (oidc4vcParameters.userPinRequired) {
      emit(
        state.copyWith(
          qrScanStatus: QrScanStatus.success,
          route: UserPinPage.route(
            txCode: oidc4vcParameters.txCode,
            onCancel: () {
              goBack();
            },
            onProceed: (String pinCode) async {
              String? userPin;
              String? txCodeData;

              if (oidc4vcParameters.txCode != null) {
                txCodeData = pinCode;
              } else {
                userPin = pinCode;
              }
              await initiateOIDC4VCCredentialIssuance(
                credentialsCubit: credentialsCubit,
                didKitProvider: didKitProvider,
                qrCodeScanCubit: qrCodeScanCubit,
                secureStorageProvider: getSecureStorage,
                dioClient: client,
                userPin: userPin,
                txCode: txCodeData,
                cryptoHolderBinding: customOidc4vcProfile.cryptoHolderBinding,
                profileCubit: profileCubit,
                oidc4vcParameters: oidc4vcParameters,
              );
            },
          ),
        ),
      );
      return;
    }

    await initiateOIDC4VCCredentialIssuance(
      credentialsCubit: credentialsCubit,
      didKitProvider: didKitProvider,
      qrCodeScanCubit: qrCodeScanCubit,
      secureStorageProvider: getSecureStorage,
      dioClient: client,
      userPin: null,
      txCode: null,
      cryptoHolderBinding: customOidc4vcProfile.cryptoHolderBinding,
      profileCubit: profileCubit,
      oidc4vcParameters: oidc4vcParameters,
    );
  }

  Future<void> startSIOPV2OIDC4VPProcess(Uri oldUri) async {
    final String? requestUri = oldUri.queryParameters['request_uri'];
    final String? request = oldUri.queryParameters['request'];
    final String? clientId = oldUri.queryParameters['client_id'];

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
        uri: oldUri,
        response: response,
        clientId: clientId.toString(),
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
      final error = {
        'error': 'invalid_request',
        'error_description': 'The response_type is missing.',
      };
      unawaited(scanCubit.sendErrorToServer(uri: state.uri!, data: error));
      throw ResponseMessage(data: error);
    } else if (!keys.contains('client_id')) {
      final error = {
        'error': 'invalid_request',
        'error_description': 'The client_id is missing.',
      };
      unawaited(scanCubit.sendErrorToServer(uri: state.uri!, data: error));
      throw ResponseMessage(data: error);
    }

    final String? responseMode = state.uri!.queryParameters['response_mode'];
    final bool correctResponeMode = responseMode != null &&
        (responseMode == 'post' ||
            responseMode == 'direct_post' ||
            responseMode == 'direct_post.jwt');

    /// check response mode value
    if (!correctResponeMode) {
      final error = {
        'error': 'unsupported_response_type',
        'error_description': 'The response mode is not supported.',
      };
      unawaited(scanCubit.sendErrorToServer(uri: state.uri!, data: error));
      throw ResponseMessage(data: error);
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
          final error = {
            'error': 'unsupported_response_type',
            'error_description': 'The subject syntax type is not supported.',
          };
          unawaited(scanCubit.sendErrorToServer(uri: state.uri!, data: error));
          throw ResponseMessage(data: error);
        }
      }
    }

    final redirectUri = state.uri!.queryParameters['redirect_uri'];
    final responseUri = state.uri!.queryParameters['response_uri'];

    final isClientIdUrl = isURL(clientId.toString());

    /// id_token only
    if (isIDTokenOnly(responseType)) {
      if (redirectUri == null && responseUri == null) {
        final error = {
          'error': 'invalid_request',
          'error_description': 'Only response_uri or redirect_uri is required.',
        };
        unawaited(scanCubit.sendErrorToServer(uri: state.uri!, data: error));
        throw ResponseMessage(data: error);
      }

      if (isSecurityHigh && !keys.contains('nonce')) {
        final error = {
          'error': 'invalid_request',
          'error_description': 'The nonce is missing.',
        };
        unawaited(scanCubit.sendErrorToServer(uri: state.uri!, data: error));
        throw ResponseMessage(data: error);
      }
    }

    /// contain id_token but may or may not contain vp_token
    if (hasIDToken(responseType)) {
      final scope = state.uri!.queryParameters['scope'];
      if (scope == null || !scope.contains('openid')) {
        final error = {
          'error': 'invalid_request',
          'error_description':
              'The openid scope is required in the scope list.',
        };
        unawaited(scanCubit.sendErrorToServer(uri: state.uri!, data: error));
        throw ResponseMessage(data: error);
      }
    }

    /// contain vp_token but may or may not contain id_token
    if (hasVPToken(responseType)) {
      if (!keys.contains('nonce')) {
        final error = {
          'error': 'invalid_request',
          'error_description': 'The nonce is missing.',
        };
        unawaited(scanCubit.sendErrorToServer(uri: state.uri!, data: error));
        throw ResponseMessage(data: error);
      }

      if (responseMode == 'direct_post') {
        final bothPresent = redirectUri != null && responseUri != null;
        final bothAbsent = redirectUri == null && responseUri == null;

        if (bothAbsent) {
          final error = {
            'error': 'invalid_request',
            'error_description':
                'The response_uri and redirect_uri are missing.',
          };
          unawaited(scanCubit.sendErrorToServer(uri: state.uri!, data: error));
          throw ResponseMessage(data: error);
        }

        if (bothPresent) {
          final error = {
            'error': 'invalid_request',
            'error_description':
                'Only response_uri or redirect_uri is required.',
          };
          unawaited(scanCubit.sendErrorToServer(uri: state.uri!, data: error));
          throw ResponseMessage(data: error);
        }
      }

      if (isSecurityHigh &&
          responseUri != null &&
          isClientIdUrl &&
          !responseUri.contains(clientId.toString())) {
        final error = {
          'error': 'invalid_request',
          'error_description': 'The client_id must be equal to response_uri.',
        };
        unawaited(scanCubit.sendErrorToServer(uri: state.uri!, data: error));
        throw ResponseMessage(data: error);
      }
    }

    /// contain vp_token or id_token
    if (hasIDTokenOrVPToken(responseType)) {
      if (isSecurityHigh &&
          redirectUri != null &&
          isClientIdUrl &&
          !redirectUri.contains(clientId.toString())) {
        final error = {
          'error': 'invalid_request',
          'error_description': 'The client_id must be equal to redirect_uri.',
        };
        unawaited(scanCubit.sendErrorToServer(uri: state.uri!, data: error));
        throw ResponseMessage(data: error);
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

      await launchOIDC4VPAndSIOPV2Flow(
        keys: keys,
        uri: state.uri!,
      );
    } else {
      final error = {
        'error': 'invalid_request',
        'error_description':
            'The response type supported is id_token, or vp_token or both.',
      };
      unawaited(scanCubit.sendErrorToServer(uri: state.uri!, data: error));
      throw ResponseMessage(data: error);
    }
  }

  Future<void> startOIDC4VCDeferedCredentialIssuance({
    required CredentialModel credentialModel,
    required QRCodeScanCubit qrCodeScanCubit,
  }) async {
    try {
      emit(state.loading());

      final url = credentialModel.pendingInfo!.url;

      final customOidc4vcProfile = profileCubit.state.model.profileSetting
          .selfSovereignIdentityOptions.customOidc4vcProfile;

      final oidc4vcParameters = await getIssuanceData(
        url: url,
        client: client,
        oidc4vc: oidc4vc,
        oidc4vciDraftType: customOidc4vcProfile.oidc4vciDraft,
        useOAuthAuthorizationServerLink:
            useOauthServerAuthEndPoint(profileCubit.state.model),
      );

      await handleErrorForOID4VCI(
        oidc4vcParameters: oidc4vcParameters,
        didKeyType: profileCubit.state.model.profileSetting
            .selfSovereignIdentityOptions.customOidc4vcProfile.defaultDid,
        clientType: profileCubit.state.model.profileSetting
            .selfSovereignIdentityOptions.customOidc4vcProfile.clientType,
      );

      await getAndAddDefferedCredential(
        credentialModel: credentialModel,
        credentialsCubit: credentialsCubit,
        issuer: oidc4vcParameters.issuer,
        oidc4vc: oidc4vc,
        jwtDecode: jwtDecode,
        blockchainType: walletCubit.state.currentAccount?.blockchainType,
        oidc4vciDraftType: customOidc4vcProfile.oidc4vciDraft,
        qrCodeScanCubit: qrCodeScanCubit,
        profileCubit: profileCubit,
      );
    } catch (e) {
      emitError(error: e);
    }
  }

  Future<bool> isVCPresentable({
    required List<VCFormatType> formatsSupported,
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
          formatsSupported: formatsSupported,
          profileType: profileCubit.state.model.profileType,
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
    required String? txCode,
    required Oidc4vcParameters oidc4vcParameters,
  }) {
    emit(
      state.copyWith(
        qrScanStatus: QrScanStatus.success,
        route: Oidc4vcCredentialPickPage.route(
          credentials: credentials,
          userPin: userPin,
          txCode: txCode,
          oidc4vcParameters: oidc4vcParameters,
        ),
      ),
    );
  }

  //Completer<bool>? missingCredentialCompleter;

  Future<void> launchOIDC4VPAndSIOPV2Flow({
    required List<String> keys,
    required Uri uri,
  }) async {
    if (!keys.contains('presentation_definition') &&
        !keys.contains('presentation_definition_uri')) {
      final error = {
        'error': 'invalid_request',
        'error_description':
            'The presentation_definition or presentation_definition_uri is '
                'required, only one but one is required.',
      };
      unawaited(scanCubit.sendErrorToServer(uri: uri, data: error));
      throw ResponseMessage(data: error);
    }

    final Map<String, dynamic>? presentationDefinitionData =
        await getPresentationDefinition(client: client, uri: uri);

    if (presentationDefinitionData == null) {
      final error = {
        'error': 'invalid_request',
        'error_description': 'Presentation definition is invalid',
      };
      unawaited(scanCubit.sendErrorToServer(uri: uri, data: error));
      throw ResponseMessage(data: error);
    }

    final PresentationDefinition presentationDefinition =
        PresentationDefinition.fromJson(presentationDefinitionData);

    if (presentationDefinition.inputDescriptors.isEmpty) {
      final error = {
        'error': 'invalid_request',
        'error_description':
            'The input_descriptors is required in the presentation_definition'
                ' object',
      };
      unawaited(scanCubit.sendErrorToServer(uri: uri, data: error));
      throw ResponseMessage(data: error);
    }

    if (presentationDefinition.inputDescriptors.isEmpty) {
      final error = {
        'error': 'invalid_request',
        'error_description':
            'The input_descriptors is required in the presentation_definition'
                ' object',
      };
      unawaited(scanCubit.sendErrorToServer(uri: uri, data: error));
      throw ResponseMessage(data: error);
    }

    Map<String, dynamic>? clientMetaData;

    if (presentationDefinition.format == null) {
      clientMetaData = await getClientMetada(client: client, uri: uri);

      if (clientMetaData != null) {
        if (!clientMetaData.containsKey('vp_formats')) {
          final error = {
            'error': 'invalid_request',
            'error_description': 'Format is missing.',
          };
          unawaited(scanCubit.sendErrorToServer(uri: uri, data: error));
          throw ResponseMessage(data: error);
        }
      }
    }

    for (final descriptor in presentationDefinition.inputDescriptors) {
      if (descriptor.constraints == null) {
        final error = {
          'error': 'invalid_request',
          'error_description': 'Presentation definition is invalid',
        };
        unawaited(scanCubit.sendErrorToServer(uri: uri, data: error));
        throw ResponseMessage(data: error);
      }
    }

    final CredentialManifest credentialManifest = CredentialManifest(
      'id',
      IssuedBy('', ''),
      null,
      presentationDefinition,
    );

    final CredentialModel credentialPreview = CredentialModel(
      id: 'id',
      image: 'image',
      credentialPreview: Credential.dummy(),
      shareLink: 'shareLink',
      data: const {},
      jwt: null,
      credentialManifest: credentialManifest,
      profileLinkedId: profileCubit.state.model.profileType.getVCId,
    );

    final host = await getHost(uri: uri, client: client);

    emit(
      state.copyWith(
        qrScanStatus: QrScanStatus.success,
        route: CredentialManifestOfferPickPage.route(
          uri: uri,
          credential: credentialPreview,
          issuer: Issuer.emptyIssuer(host),
          inputDescriptorIndex: 0,
          credentialsToBePresented: [],
        ),
      ),
    );
  }

  /// verify jwt
  Future<void> verifyJWTBeforeLaunchingOIDC4VPANDSIOPV2Flow() async {
    final String? requestUri = state.uri?.queryParameters['request_uri'];
    final String? request = state.uri?.queryParameters['request'];
    late dynamic encodedData;
    if (request != null) {
      encodedData = request;
    } else if (requestUri != null) {
      encodedData =
          await fetchRequestUriPayload(url: requestUri, client: client);
    }
    final customOidc4vcProfile = profileCubit.state.model.profileSetting
        .selfSovereignIdentityOptions.customOidc4vcProfile;
    final isSecurityEnabled = customOidc4vcProfile.securityLevel;
    if (isSecurityEnabled) {
      final Map<String, dynamic> payload =
          jwtDecode.parseJwt(encodedData as String);
      var clientId = payload['client_id'].toString();
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

        var clientIdScheme = payload['client_id_scheme'];

        /// With OIDC4VP Draft 22 and above the client_id_scheme is removed
        /// from the authorization request but the value is added to the
        /// client_id to be the new client_id value
        ///
        /// in the client_id Authorization Request parameter and other places
        /// where the Client Identifier is used, the Client Identifier Schemes
        /// are prefixed to the usual Client Identifier, separated by a :
        /// (colon) character: <client_id_scheme>:<orig_client_id>

        if (clientIdScheme == null) {
          final draft22AndAbove = profileCubit
              .state
              .model
              .profileSetting
              .selfSovereignIdentityOptions
              .customOidc4vcProfile
              .oidc4vpDraft
              .draft22AndAbove;

          if (draft22AndAbove) {
            final parts = clientId.split(':');
            if (parts.length == 2) {
              clientIdScheme = parts[0];
              clientId = parts[1];
            } else {
              final error = {
                'error': 'invalid_request',
                'error_description': 'Invalid client_id',
              };
              unawaited(
                scanCubit.sendErrorToServer(uri: state.uri!, data: error),
              );
              throw ResponseMessage(data: error);
            }
          }
        }

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
          } else if (clientIdScheme == 'redirect_uri') {
            /// no need to verify
            return emit(state.acceptHost());
          } else if (clientIdScheme == 'did') {
            /// bypass
          } else {
            /// if client_id_scheme is not in the list -> did, redirect_uri,
            /// verifier_attestation, x509_san_dns
            final error = {
              'error': 'invalid_request',
              'error_description': 'Invalid client_id_scheme',
            };
            unawaited(
              scanCubit.sendErrorToServer(uri: state.uri!, data: error),
            );
            throw ResponseMessage(data: error);
          }

          final VerificationType isVerified = await verifyEncodedData(
            issuer: clientId,
            jwtDecode: jwtDecode,
            jwt: encodedData,
            publicKeyJwk: publicKeyJwk,
            useOAuthAuthorizationServerLink:
                useOauthServerAuthEndPoint(profileCubit.state.model),
          );

          if (isVerified != VerificationType.verified) {
            return emitError(
              error: ResponseMessage(
                message: ResponseString.RESPONSE_STRING_invalidRequest,
              ),
              callToAction: AiRequestAnalysisButton(
                link: state.uri.toString(),
              ),
            );
          }
        }

        emit(state.acceptHost());
      } catch (e) {
        rethrow;
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

      final customOidc4vcProfile = profileCubit.state.model.profileSetting
          .selfSovereignIdentityOptions.customOidc4vcProfile;

      final clientId = getClientIdForPresentation(
        state.uri!.queryParameters['client_id'],
      );

      final nonce = state.uri?.queryParameters['nonce'];
      final stateValue = state.uri?.queryParameters['state'];

      // final bool? isEBSI =
      //     await isEBSIForVerifier(client: client, uri: state.uri!);

      final didKeyType = customOidc4vcProfile.defaultDid;

      final privateKey = await fetchPrivateKey(
        profileCubit: profileCubit,
        didKeyType: didKeyType,
      );

      final (did, kid) = await fetchDidAndKid(
        privateKey: privateKey,
        profileCubit: profileCubit,
        didKeyType: didKeyType,
      );

      final Map<String, dynamic> responseData =
          await oidc4vc.getDataForSiopV2Flow(
        clientId: clientId.toString(),
        privateKey: privateKey,
        did: did,
        kid: kid,
        redirectUri: redirectUri ?? responseUri!,
        nonce: nonce,
        stateValue: stateValue,
        clientType: customOidc4vcProfile.clientType,
        proofHeader: customOidc4vcProfile.proofHeader,
      );

      if (profileCubit.state.model.isDeveloperMode) {
        final value = await showDataBeforeSending(
          title: 'RESPONSE REQUEST',
          data: responseData,
        );
        if (value) {
          completer = null;
        } else {
          completer = null;
          resetNonceAndAccessTokenAndAuthorizationDetails();
          goBack();
          return;
        }
      }

      final Response<dynamic> response = await oidc4vc.siopv2Flow(
        redirectUri: redirectUri ?? responseUri!,
        dio: client.dio,
        responseData: responseData,
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
        if (uri.toString().startsWith(Parameters.redirectUri)) {
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
      emitError(error: e);
    }
  }

  Future<void> processSelectedCredentials({
    required List<dynamic> selectedCredentials,
    required String? userPin,
    required String? txCode,
    required Oidc4vcParameters oidc4vcParameters,
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
        isEBSI: oidc4vcParameters.oidc4vcType == OIDC4VCType.EBSI,
        issuer: oidc4vcParameters.issuer,
      );

      final customOidc4vcProfile = profileCubit.state.model.profileSetting
          .selfSovereignIdentityOptions.customOidc4vcProfile;

      final publicKeyForDPop = generateP256KeyForDPop();

      if (oidc4vcParameters.preAuthorizedCode != null) {
        await addCredentialsInLoop(
          selectedCredentials: selectedCredentials,
          userPin: userPin,
          txCode: txCode,
          codeForAuthorisedFlow: null,
          codeVerifier: null,
          authorization: authorization,
          clientId: clientId,
          clientSecret: clientSecret,
          oAuthClientAttestation: oAuthClientAttestation,
          oAuthClientAttestationPop: oAuthClientAttestationPop,
          publicKeyForDPop: publicKeyForDPop,
          oidc4vcParameters: oidc4vcParameters,
        );
      } else {
        emit(state.loading());
        final scope = customOidc4vcProfile.scope;

        final authorizationUri = await getAuthorizationUriForIssuer(
          oidc4vcParameters: oidc4vcParameters,
          didKitProvider: didKitProvider,
          selectedCredentials: selectedCredentials,
          scope: scope,
          clientId: clientId,
          clientSecret: clientSecret,
          clientAuthentication: customOidc4vcProfile.clientAuthentication,
          formatsSupported: customOidc4vcProfile.formatsSupported ?? [],
          oAuthClientAttestation: oAuthClientAttestation,
          oAuthClientAttestationPop: oAuthClientAttestationPop,
          secureAuthorizedFlow: customOidc4vcProfile.pushAuthorizationRequest,
          client: client,
          profileType: profileCubit.state.model.profileType,
          walletIssuer: Parameters.walletIssuer,
          useOAuthAuthorizationServerLink:
              useOauthServerAuthEndPoint(profileCubit.state.model),
          profileCubit: profileCubit,
          publicKeyForDPop: publicKeyForDPop,
          qrCodeScanCubit: this,
        );

        if (authorizationUri == null) return;

        await LaunchUrl.launchUri(authorizationUri);
        goBack();
      }
    } catch (e) {
      emitError(error: e);
    }
  }

  String? savedNonce;
  String? savedAccessToken;
  List<dynamic>? savedAuthorizationDetails;
  Completer<bool>? completer;

  Future<void> addCredentialsInLoop({
    required Oidc4vcParameters oidc4vcParameters,
    required List<dynamic> selectedCredentials,
    required String? userPin,
    required String? txCode,
    required String? codeForAuthorisedFlow,
    required String? codeVerifier,
    required String? authorization,
    required String? clientId,
    required String? clientSecret,
    required String publicKeyForDPop,
    String? oAuthClientAttestation,
    String? oAuthClientAttestationPop,
  }) async {
    try {
      for (int i = 0; i < selectedCredentials.length; i++) {
        emit(state.loading());

        final customOidc4vcProfile = profileCubit.state.model.profileSetting
            .selfSovereignIdentityOptions.customOidc4vcProfile;

        if (oidc4vcParameters.preAuthorizedCode != null ||
            (codeForAuthorisedFlow != null && codeVerifier != null)) {
          /// codeForAuthorisedFlow != null
          /// this is second phase flow for authorization_code
          /// first phase is need for the authentication
          ///
          /// preAuthorizedCode != null
          /// this is full phase flow for preAuthorizedCode

          /// get openid configuration
          Map<String, dynamic>? tokenData;
          if (savedAccessToken == null) {
            /// get tokendata
            tokenData = oidc4vc.buildTokenData(
              preAuthorizedCode: oidc4vcParameters.preAuthorizedCode,
              userPin: userPin,
              code: codeForAuthorisedFlow,
              codeVerifier: codeVerifier,
              clientId: clientId,
              txCode: txCode,
              clientSecret: clientSecret,
              authorization: authorization,
              redirectUri: Parameters.redirectUri,
              oAuthClientAttestation: oAuthClientAttestation,
              oAuthClientAttestationPop: oAuthClientAttestationPop,
            );

            if (profileCubit.state.model.isDeveloperMode) {
              final value = await showDataBeforeSending(
                title: 'TOKEN REQUEST',
                data: tokenData,
              );
              if (value) {
                completer = null;
              } else {
                completer = null;
                resetNonceAndAccessTokenAndAuthorizationDetails();
                goBack();
                return;
              }
            }

            String? dPop;

            if (customOidc4vcProfile.dpopSupport) {
              dPop = await getDPopJwt(
                url: oidc4vcParameters.tokenEndpoint,
                accessToken: savedAccessToken,
                nonce: savedNonce,
                publicKey: publicKeyForDPop,
              );
            }

            /// get token response
            final (
              Map<String, dynamic>? tokenResponse,
              String? accessToken,
              String? cnonce,
              List<dynamic>? authorizationDetails,
            ) = await oidc4vc.getTokenResponse(
              authorization: authorization,
              tokenEndPoint: oidc4vcParameters.tokenEndpoint,
              oAuthClientAttestation: oAuthClientAttestation,
              oAuthClientAttestationPop: oAuthClientAttestationPop,
              dio: client.dio,
              tokenData: tokenData,
              dPop: dPop,
              issuer: oidc4vcParameters.issuer,
            );
            savedAccessToken = accessToken;
            savedNonce = cnonce;
            savedAuthorizationDetails = authorizationDetails;

            if (profileCubit.state.model.isDeveloperMode) {
              final formattedData =
                  getFormattedTokenResponse(tokenData: tokenResponse);

              final value = await showDataAfterReceiving(formattedData);

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

          if (oidc4vcParameters.oidc4vciDraftType.getNonce) {
            final nonce = await oidc4vc.getNonceReponse(
              dio: client.dio,
              nonceEndpoint: oidc4vcParameters.nonceEndpoint,
            );

            if (nonce == null) {
              throw ResponseMessage(
                data: {
                  'error': 'invalid_request',
                  'error_description': 'c_nonce is not avaiable.',
                },
              );
            }

            savedNonce = nonce;
          }

          /// get credentials
          (List<dynamic>?, String?, String?)? result;
          try {
            result = await getCredential(
              credential: selectedCredentials[i],
              cryptoHolderBinding: customOidc4vcProfile.cryptoHolderBinding,
              didKeyType: customOidc4vcProfile.defaultDid,
              clientId: tokenData?['client_id'] != null ? clientId : null,
              profileCubit: profileCubit,
              accessToken: savedAccessToken!,
              cnonce: savedNonce,
              authorizationDetails: savedAuthorizationDetails,
              qrCodeScanCubit: this,
              publicKeyForDPop: publicKeyForDPop,
              oidc4vcParameters: oidc4vcParameters,
            );
          } catch (e) {
            if (count == 1) {
              count = 0;
              rethrow;
            }

            if (e is DioException &&
                e.response != null &&
                e.response!.data is Map<String, dynamic> &&
                (e.response!.data as Map<String, dynamic>)
                    .containsKey('c_nonce')) {
              count++;

              final nonce = e.response!.data['c_nonce'].toString();
              savedNonce = nonce;
              result = await getCredential(
                credential: selectedCredentials[i],
                cryptoHolderBinding: customOidc4vcProfile.cryptoHolderBinding,
                didKeyType: customOidc4vcProfile.defaultDid,
                clientId: tokenData?['client_id'] != null ? clientId : null,
                profileCubit: profileCubit,
                accessToken: savedAccessToken!,
                cnonce: nonce,
                authorizationDetails: savedAuthorizationDetails,
                qrCodeScanCubit: this,
                publicKeyForDPop: publicKeyForDPop,
                oidc4vcParameters: oidc4vcParameters,
              );
              count = 0;
            } else {
              count = 0;
              rethrow;
            }
          }

          if (result == null) {
            return emit(state.copyWith(qrScanStatus: QrScanStatus.idle));
          }

          final (
            encodedCredentialOrFutureTokens,
            deferredCredentialEndpoint,
            format
          ) = result;

          final lastElement = encodedCredentialOrFutureTokens!.last;

          /// update nonce value
          if (lastElement is Map<String, dynamic>) {
            if (lastElement.containsKey('c_nonce')) {
              savedNonce = lastElement['c_nonce'].toString();
            }
          }

          if (profileCubit.state.model.isDeveloperMode) {
            final formattedData = getFormattedCredentialResponse(
              credentialData: encodedCredentialOrFutureTokens,
            );

            final value = await showDataAfterReceiving(formattedData);

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
            issuer: oidc4vcParameters.issuer,
            jwtDecode: jwtDecode,
            deferredCredentialEndpoint: deferredCredentialEndpoint,
            encodedCredentialOrFutureTokens: encodedCredentialOrFutureTokens,
            format: format!,
            qrCodeScanCubit: this,
            openIdConfiguration: oidc4vcParameters.issuerOpenIdConfiguration,
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
      emitError(error: e);
    }
  }

  Future<bool> showDataBeforeSending({
    String? title,
    Map<String, dynamic>? data,
    String? fullData,
  }) async {
    completer = Completer<bool>();

    var formattedData = '';

    if (fullData != null) {
      formattedData = fullData;
    } else {
      formattedData = '''
<b>$title :</b> 
${const JsonEncoder.withIndent('  ').convert(data)}
''';

      /// jwt
      final jwtMappedIterable = JsonPath(r'$..jwt').read(data);

      if (jwtMappedIterable.isNotEmpty) {
        final jwtValue = jwtMappedIterable.first.value;

        if (jwtValue != null) {
          final jwt = jwtValue.toString();

          try {
            final header = jwtDecode.parseJwtHeader(jwt);
            final payload = jwtDecode.parseJwt(jwt);

            final jwtData = '''
<b>HEADER :</b>
${const JsonEncoder.withIndent('  ').convert(header)}\n
<b>PAYLOAD :</b>
${const JsonEncoder.withIndent('  ').convert(payload)}
''';
            formattedData = '$formattedData\n$jwtData';
          } catch (e) {
            //
          }
        }
      }

      /// id_token
      final idTokenMappedIterable = JsonPath(r'$..id_token').read(data);

      if (idTokenMappedIterable.isNotEmpty) {
        final jwtValue = idTokenMappedIterable.first.value;

        if (jwtValue != null) {
          final jwt = jwtValue.toString();

          try {
            final header = jwtDecode.parseJwtHeader(jwt);
            final payload = jwtDecode.parseJwt(jwt);

            final jwtData = '''
<b>HEADER :</b> 
${const JsonEncoder.withIndent('  ').convert(header)}\n
<b>PAYLOAD :</b> 
${const JsonEncoder.withIndent('  ').convert(payload)}
''';
            formattedData = '$formattedData\n$jwtData';
          } catch (e) {
            //
          }
        }
      }
    }

    emit(
      state.copyWith(
        qrScanStatus: QrScanStatus.pauseForDisplay,
        dialogData: formattedData,
      ),
    );

    final value = await completer!.future;

    return value;
  }

  Future<bool> showDataAfterReceiving(String formattedData) async {
    completer = Completer<bool>();

    emit(
      state.copyWith(
        qrScanStatus: QrScanStatus.pauseForDialog,
        dialogData: formattedData,
      ),
    );

    final value = await completer!.future;

    return value;
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
    required QRCodeScanCubit qrCodeScanCubit,
  }) async {
    try {
      final containsAllRequiredKey = statePayload.containsKey('challenge');
      if (!containsAllRequiredKey) {
        throw ResponseMessage(
          data: {
            'error': 'invalid_request',
            'error_description': 'The state value is incorrect.',
          },
        );
      }

      if (profileCubit.state.model.isDeveloperMode) {
        final formattedData = '''
<b>AUTHORIZATION RESPONSE:</b>
${state.uri}
''';

        final value = await qrCodeScanCubit.showDataBeforeSending(
          fullData: formattedData,
        );

        if (value) {
          qrCodeScanCubit.completer = null;
        } else {
          qrCodeScanCubit.completer = null;
          qrCodeScanCubit.resetNonceAndAccessTokenAndAuthorizationDetails();
          qrCodeScanCubit.goBack();
          return;
        }
      }
      final oidc4VCIState =
          profileCubit.getOidc4VCIState(statePayload['challenge'] as String);
      final String oidc4vciDraft = oidc4VCIState!.oidc4vciDraft;

      final OIDC4VCIDraftType? oidc4vciDraftType = OIDC4VCIDraftType.values
          .firstWhereOrNull((ele) => ele.numbering == oidc4vciDraft);

      if (oidc4vciDraftType == null) {
        throw Exception();
      }
      final issuerOpenIdConfiguration = await oidc4vc.getIssuerMetaData(
        baseUrl: oidc4VCIState.issuer,
        dio: client.dio,
      );

      await addCredentialsInLoop(
        selectedCredentials: oidc4VCIState.selectedCredentials,
        userPin: null,
        txCode: null,
        codeForAuthorisedFlow: codeForAuthorisedFlow,
        codeVerifier: oidc4VCIState.codeVerifier,
        authorization: oidc4VCIState.authorization,
        clientId: oidc4VCIState.clientId,
        clientSecret: oidc4VCIState.clientSecret,
        oAuthClientAttestation: oidc4VCIState.oAuthClientAttestation,
        oAuthClientAttestationPop: oidc4VCIState.oAuthClientAttestationPop,
        publicKeyForDPop: oidc4VCIState.publicKeyForDPo,
        oidc4vcParameters: Oidc4vcParameters(
          oidc4vciDraftType: oidc4vciDraftType,
          useOAuthAuthorizationServerLink: false,
          initialUri: Uri(),
          userPinRequired: false,
          issuerState: null,
          issuer: oidc4VCIState.issuer,
          oidc4vcType: oidc4VCIState.isEBSI ? OIDC4VCType.EBSI : null,
          tokenEndpoint: oidc4VCIState.tokenEndpoint,
          issuerOpenIdConfiguration: issuerOpenIdConfiguration,
        ),
      );
      await profileCubit.deleteOidc4VCIState(oidc4VCIState.challenge);
    } catch (e) {
      emitError(error: e);
    }
  }
}
