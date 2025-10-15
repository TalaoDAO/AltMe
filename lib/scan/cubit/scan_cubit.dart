import 'dart:convert';
import 'dart:typed_data';

import 'package:altme/activity_log/activity_log.dart';
import 'package:altme/app/app.dart';
import 'package:altme/credentials/cubit/credentials_cubit.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/activity/activity.dart';
import 'package:altme/oidc4vp_transaction/oidc4vp_signature.dart';
import 'package:altme/wallet/wallet.dart';

import 'package:bloc/bloc.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:did_kit/did_kit.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:oidc4vc/oidc4vc.dart';

import 'package:secure_storage/secure_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

part 'scan_cubit.g.dart';
part 'scan_state.dart';

/// VC = Verifibale Credential : signed and issued by issuer
/// VP = Verifiable Presentation = VC + wallet signature
/// VP is what you trasnfer to Verifier in the Presentation Request prootocol

/// the issuer signs and sends a VC to the wallet
///the wallet stores the VC
/// If needed the wallet builds a VP with the VC and sends it to a Verifier

class ScanCubit extends Cubit<ScanState> {
  ScanCubit({
    required this.client,
    required this.credentialsCubit,
    required this.didKitProvider,
    required this.secureStorageProvider,
    required this.profileCubit,
    required this.walletCubit,
    required this.oidc4vc,
    required this.jwtDecode,
    required this.activityLogManager,
  }) : super(const ScanState());

  final DioClient client;
  final CredentialsCubit credentialsCubit;
  final DIDKitProvider didKitProvider;
  final SecureStorageProvider secureStorageProvider;
  final ProfileCubit profileCubit;
  final WalletCubit walletCubit;
  final OIDC4VC oidc4vc;
  final JWTDecode jwtDecode;
  final ActivityLogManager activityLogManager;

  Future<void> credentialOfferOrPresent({
    required Uri uri,
    required CredentialModel credentialModel,
    required String keyId,
    required List<CredentialModel>? credentialsToBePresented,
    required Issuer issuer,
    required QRCodeScanCubit qrCodeScanCubit,
  }) async {
    emit(state.loading());
    final log = getLogger('ScanCubit - credentialOffer');

    try {
      final didKeyType = profileCubit
          .state
          .model
          .profileSetting
          .selfSovereignIdentityOptions
          .customOidc4vcProfile
          .defaultDid;

      final privateKey = await fetchPrivateKey(
        profileCubit: profileCubit,
        didKeyType: didKeyType,
      );

      final (did, kid) = await fetchDidAndKid(
        privateKey: privateKey,
        profileCubit: profileCubit,
        didKeyType: didKeyType,
      );

      if (isSiopV2OrOidc4VpUrl(uri)) {
        final responseType = uri.queryParameters['response_type'] ?? '';
        final stateValue = uri.queryParameters['state'];

        if (isIDTokenOnly(responseType)) {
          /// verifier side (siopv2) with request uri as value
          throw ResponseMessage(
            data: {
              'error': 'invalid_request',
              'error_description':
                  'The verifier side must not contain id_token only.',
            },
          );
        }

        if (hasVPToken(responseType)) {
          /// verifier side (oidc4vp) with request uri as value

          await presentCredentialToOIDC4VPAndSIOPV2Request(
            uri: uri,
            issuer: issuer,
            credentialsToBePresented: credentialsToBePresented!,
            presentationDefinition:
                credentialModel.credentialManifest!.presentationDefinition!,
            oidc4vc: oidc4vc,
            did: did,
            kid: kid,
            privateKey: privateKey,
            stateValue: stateValue,
            idTokenNeeded: hasIDToken(responseType),
            qrCodeScanCubit: qrCodeScanCubit,
          );
          return;
        } else {
          throw ResponseMessage(
            data: {
              'error': 'invalid_request',
              'error_description':
                  // ignore: lines_longer_than_80_chars
                  'The response type should contain id_token, vp_token or both.',
            },
          );
        }
      } else {
        /// If credential manifest exist we follow instructions to present
        /// credential
        /// If credential manifest doesn't exist we add DIDAuth to the post
        /// If id was in preview we send it in the post
        ///  https://github.com/TalaoDAO/wallet-interaction/blob/main/README.md#credential-offer-protocol
        ///
        final didKeyType = profileCubit
            .state
            .model
            .profileSetting
            .selfSovereignIdentityOptions
            .customOidc4vcProfile
            .defaultDid;

        final privateKey = await getPrivateKey(
          profileCubit: profileCubit,
          didKeyType: didKeyType,
        );

        final (did, kid) = await getDidAndKid(
          didKeyType: didKeyType,
          privateKey: privateKey,
          profileCubit: profileCubit,
        );

        List<String> presentations = <String>[];
        if (credentialsToBePresented == null) {
          final options = <String, dynamic>{
            'verificationMethod': kid,
            'proofPurpose': 'authentication',
            'challenge': credentialModel.challenge ?? '',
            'domain': credentialModel.domain ?? '',
          };

          final presentation = await didKitProvider.didAuth(
            did,
            jsonEncode(options),
            privateKey,
          );

          presentations = List.of(presentations)..add(presentation);
        } else {
          for (final item in credentialsToBePresented) {
            final presentationId = 'urn:uuid:${const Uuid().v4()}';

            /// proof is done with a creation date 20 seconds in the past to
            /// avoid proof check to fail because of time difference on server

            final options = jsonEncode({
              'verificationMethod': kid,
              'proofPurpose': 'assertionMethod',
              'challenge': credentialModel.challenge,
              'domain': credentialModel.domain,
              'created': DateTime.now()
                  .subtract(const Duration(seconds: 20))
                  .toUtc()
                  .toIso8601String(),
            });
            final presentation = await didKitProvider.issuePresentation(
              jsonEncode({
                '@context': ['https://www.w3.org/2018/credentials/v1'],
                'type': ['VerifiablePresentation'],
                'id': presentationId,
                'holder': did,
                'verifiableCredential': item.data,
              }),
              options,
              privateKey,
            );
            presentations = List.of(presentations)..add(presentation);
          }
        }

        log.i('presentations - $presentations');

        FormData data;
        if (credentialModel.receivedId == null) {
          data = FormData.fromMap(<String, dynamic>{
            'subject_id': did,
            'presentation': presentations.length > 1
                ? jsonEncode(presentations)
                : presentations,
          });
        } else {
          data = FormData.fromMap(<String, dynamic>{
            'id': credentialModel.receivedId,
            'subject_id': did,
            'presentation': presentations.length > 1
                ? jsonEncode(presentations)
                : presentations,
          });
        }

        final dynamic credential = await client.post(
          uri.toString(),
          data: data,
        );

        final dynamic jsonCredential = credential is String
            ? jsonDecode(credential)
            : credential;

        if (credentialModel.jwt == null) {
          /// not verifying credential for did:ebsi and did:web issuer
          log.i('verifying Credential');

          final vcStr = jsonEncode(jsonCredential);
          final optStr = jsonEncode({'proofPurpose': 'assertionMethod'});

          final verification = await didKitProvider.verifyCredential(
            vcStr,
            optStr,
          );

          log.i('[wallet/credential-offer/verify/vc] $vcStr');
          log.i('[wallet/credential-offer/verify/options] $optStr');
          log.i('[wallet/credential-offer/verify/result] $verification');

          final jsonVerification =
              jsonDecode(verification) as Map<String, dynamic>;

          if ((jsonVerification['warnings'] as List).isNotEmpty) {
            log.w(
              'credential verification return warnings',
              error: jsonVerification['warnings'],
            );

            emit(
              state.warning(
                messageHandler: ResponseMessage(
                  message: ResponseString
                      .RESPONSE_STRING_CREDENTIAL_VERIFICATION_RETURN_WARNING,
                ),
              ),
            );
          }

          if ((jsonVerification['errors'] as List).isNotEmpty) {
            log.w(
              'failed to verify credential',
              error: jsonVerification['errors'],
            );
            if (jsonVerification['errors'][0] != 'No applicable proof') {
              throw ResponseMessage(
                message:
                    ResponseString.RESPONSE_STRING_FAILED_TO_VERIFY_CREDENTIAL,
              );
            }
          }
        }

        final List<Activity> activities = List<Activity>.of(
          credentialModel.activities,
        )..add(Activity(acquisitionAt: DateTime.now()));

        CredentialManifest? credentialManifest;

        await credentialsCubit.insertCredential(
          credential: CredentialModel.copyWithData(
            oldCredentialModel: credentialModel,
            newData: jsonCredential as Map<String, dynamic>,
            activities: activities,
            credentialManifest: credentialManifest,
            profileType: qrCodeScanCubit.profileCubit.state.model.profileType,
          ),
          uri: uri,
        );

        if (credentialsToBePresented != null) {
          await presentationActivity(
            credentialModels: credentialsToBePresented,
            issuer: issuer,
            uri: uri,
          );
        }
        emit(state.copyWith(status: ScanStatus.success));
      }
    } catch (e) {
      log.e('something went wrong - $e');
      if (e is NetworkException &&
          e.message == NetworkError.NETWORK_ERROR_PRECONDITION_FAILED) {
        emitError(
          ResponseMessage(
            message: ResponseString.RESPONSE_STRING_userNotFitErrorMessage,
            data: e.data?.toString(),
          ),
        );
      } else {
        emitError(e);
      }
    }
  }

  Future<void> verifiablePresentationRequest({
    required String url,
    required List<CredentialModel> credentialsToBePresented,
    required String challenge,
    required String domain,
    required Issuer issuer,
  }) async {
    final log = getLogger('ScanCubit - verifiablePresentationRequest');

    emit(state.loading());
    try {
      final didKeyType = profileCubit
          .state
          .model
          .profileSetting
          .selfSovereignIdentityOptions
          .customOidc4vcProfile
          .defaultDid;

      final privateKey = await fetchPrivateKey(
        profileCubit: profileCubit,
        didKeyType: didKeyType,
      );

      final (did, kid) = await fetchDidAndKid(
        privateKey: privateKey,
        profileCubit: profileCubit,
        didKeyType: didKeyType,
      );

      final presentationId = 'urn:uuid:${const Uuid().v4()}';

      /// proof is done with a creation date 20 seconds in the past to avoid
      /// proof check to fail because of time difference on server
      final options = jsonEncode({
        'verificationMethod': kid,
        'proofPurpose': 'authentication',
        'challenge': challenge,
        'domain': domain,
        'created': DateTime.now()
            .subtract(const Duration(seconds: 20))
            .toUtc()
            .toIso8601String(),
      });

      final presentation = await didKitProvider.issuePresentation(
        jsonEncode({
          '@context': ['https://www.w3.org/2018/credentials/v1'],
          'type': ['VerifiablePresentation'],
          'id': presentationId,
          'holder': did,
          'verifiableCredential': credentialsToBePresented.length == 1
              ? credentialsToBePresented.first.data
              : credentialsToBePresented.map((c) => c.data).toList(),
        }),
        options,
        privateKey,
      );

      log.i('presentation $presentation');

      final FormData formData = FormData.fromMap(<String, dynamic>{
        'presentation': presentation,
      });

      final result = await client.post(url, data: formData);

      await presentationActivity(
        credentialModels: credentialsToBePresented,
        issuer: issuer,
        uri: Uri.parse(url),
      );

      String? responseMessage;
      if (result is String?) {
        responseMessage = result;
      }
      emit(
        state.copyWith(
          status: ScanStatus.success,
          message: StateMessage.success(
            stringMessage: responseMessage,
            messageHandler: responseMessage != null
                ? null
                : ResponseMessage(
                    message: ResponseString
                        .RESPONSE_STRING_SUCCESSFULLY_PRESENTED_YOUR_CREDENTIAL,
                  ),
          ),
        ),
      );
    } catch (e) {
      emitError(e);
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

  Future<void> getDIDAuthCHAPI({
    required Uri uri,
    required dynamic Function(String) done,
    required String challenge,
    required String domain,
  }) async {
    final log = getLogger('ScanCubit - getDIDAuthCHAPI');

    emit(state.loading());
    try {
      final didKeyType = profileCubit
          .state
          .model
          .profileSetting
          .selfSovereignIdentityOptions
          .customOidc4vcProfile
          .defaultDid;

      final privateKey = await fetchPrivateKey(
        profileCubit: profileCubit,
        didKeyType: didKeyType,
      );

      final (did, kid) = await fetchDidAndKid(
        privateKey: privateKey,
        profileCubit: profileCubit,
        didKeyType: didKeyType,
      );

      final presentation = await didKitProvider.didAuth(
        did,
        jsonEncode({
          'verificationMethod': kid,
          'proofPurpose': 'authentication',
          'challenge': challenge,
          'domain': domain,
        }),
        privateKey,
      );
      final dynamic credential = await client.post(
        uri.toString(),
        data: FormData.fromMap(<String, dynamic>{'presentation': presentation}),
      );
      if (credential == 'ok') {
        done(presentation);

        emit(
          state.copyWith(
            status: ScanStatus.success,
            message: StateMessage.success(
              messageHandler: ResponseMessage(
                message: ResponseString
                    .RESPONSE_STRING_SUCCESSFULLY_PRESENTED_YOUR_CREDENTIAL,
              ),
            ),
          ),
        );
      } else {
        throw ResponseMessage(
          message: ResponseString
              .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
        );
      }
    } catch (e, s) {
      log.e('something went wrong', error: e, stackTrace: s);
      emitError(e);
    }
  }

  Future<dynamic> presentCredentialToOIDC4VPAndSIOPV2Request({
    required List<CredentialModel> credentialsToBePresented,
    required PresentationDefinition presentationDefinition,
    required Issuer issuer,
    required OIDC4VC oidc4vc,
    required String privateKey,
    required String did,
    required String kid,
    required Uri uri,
    required String? stateValue,
    required bool idTokenNeeded,
    required QRCodeScanCubit qrCodeScanCubit,
  }) async {
    final log = getLogger(
      'ScanCubit - presentCredentialToOIDC4VPAndSIOPV2Request',
    );
    emit(state.loading());

    try {
      final String responseOrRedirectUri =
          uri.queryParameters['redirect_uri'] ??
          uri.queryParameters['response_uri']!;

      String? idToken;

      if (idTokenNeeded) {
        idToken = await createIdToken(
          credentialsToBePresented: credentialsToBePresented,
          did: did,
          kid: kid,
          oidc4vc: oidc4vc,
          privateKey: privateKey,
          uri: uri,
        );
      }

      Map<String, dynamic>? clientMetaData;

      if (presentationDefinition.format == null) {
        clientMetaData = await getClientMetada(client: client, uri: uri);
      }

      final (
        presentationSubmission,
        formatFromPresentationSubmission,
      ) = await getPresentationSubmission(
        credentialsToBePresented: credentialsToBePresented,
        presentationDefinition: presentationDefinition,
        clientMetaData: clientMetaData,
        profileSetting: profileCubit.state.model.profileSetting,
      );

      final vpToken = await createVpToken(
        credentialsToBePresented: credentialsToBePresented,
        did: did,
        kid: kid,
        oidc4vc: oidc4vc,
        presentationDefinition: presentationDefinition,
        privateKey: privateKey,
        uri: uri,
        clientMetaData: clientMetaData,
        profileSetting: profileCubit.state.model.profileSetting,
        formatFromPresentationSubmission: formatFromPresentationSubmission,
      );

      Map<String, dynamic> body;

      final String? responseMode = uri.queryParameters['response_mode'];

      if (responseMode == 'direct_post.jwt') {
        final iat = (DateTime.now().millisecondsSinceEpoch / 1000).round();

        final customOidc4vcProfile = profileCubit
            .state
            .model
            .profileSetting
            .selfSovereignIdentityOptions
            .customOidc4vcProfile;

        final clientId = uri.queryParameters['client_id'];

        final didKeyType = customOidc4vcProfile.defaultDid;

        final (did, _) = await getDidAndKid(
          didKeyType: didKeyType,
          privateKey: privateKey,
          profileCubit: profileCubit,
        );

        final responseData = {
          'iss': did,
          'aud': clientId,
          'exp': iat + 1000,
          'vp_token': vpToken,
          'presentation_submission': presentationSubmission,
        };

        if (idTokenNeeded && idToken != null) {
          responseData['id_token'] = idToken;
        }

        final tokenParameters = TokenParameters(
          privateKey: jsonDecode(privateKey) as Map<String, dynamic>,
          did: did, // just added as it is required field
          mediaType: MediaType.basic, // just added as it is required field
          clientType:
              ClientType.p256JWKThumprint, // just added as it is required field
          proofHeaderType: customOidc4vcProfile.proofHeader,
          clientId: '', // just added as it is required field
        );

        final jwtProofOfPossession = generateToken(
          payload: responseData,
          tokenParameters: tokenParameters,
        );

        body = {'response': jwtProofOfPossession};
      } else {
        final presentationSubmissionString = jsonEncode(presentationSubmission);

        ///it is required because of bad async handling with didKit presentation
        await Future<void>.delayed(const Duration(seconds: 1));
        final responseData = <String, dynamic>{
          'vp_token': vpToken,
          'presentation_submission': presentationSubmissionString,
        };

        if (idTokenNeeded && idToken != null) {
          responseData['id_token'] = idToken;
        }

        if (stateValue != null) {
          responseData['state'] = stateValue;
        }

        body = responseData;
      }

      if (profileCubit.state.model.isDeveloperMode) {
        final value = await qrCodeScanCubit.showDataBeforeSending(
          title: 'RESPONSE REQUEST',
          data: body,
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

      await Future<void>.delayed(const Duration(seconds: 1));
      final response = await client.dio.post<dynamic>(
        responseOrRedirectUri,
        data: body,
        options: Options(
          headers: <String, dynamic>{
            'Content-Type': 'application/x-www-form-urlencoded',
          },
          followRedirects: false,
          validateStatus: (status) {
            return status != null && status < 400;
          },
        ),
      );

      if (response.statusCode == 200) {
        await presentationActivity(
          credentialModels: credentialsToBePresented,
          issuer: issuer,
          uri: uri,
        );
        emit(
          state.copyWith(
            status: ScanStatus.success,
            message: StateMessage.success(
              messageHandler: ResponseMessage(
                message: ResponseString
                    .RESPONSE_STRING_SUCCESSFULLY_PRESENTED_YOUR_CREDENTIAL,
              ),
            ),
          ),
        );
        if (state.blockchainTransactionsSignatures != null) {
          final dotenv = DotEnv();
          final rpcUrl = await fetchRpcUrl(
            blockchainNetwork: EthereumNetwork.mainNet(),
            dotEnv: dotenv,
          );

          await Oidc4vpSignedTransaction(
            signedTransaction: state.blockchainTransactionsSignatures!,
          ).sendToken(rpcUrl);
        }
        final data = response.data;
        if (data is Map) {
          String url = '';
          if (data.containsKey('redirect_uri')) {
            url = data['redirect_uri'].toString();
          }
          if (url.isNotEmpty && data.containsKey('response_code')) {
            url = '$url?response_code=${data['response_code']}';
          }
          if (url.isNotEmpty) {
            await LaunchUrl.launch(
              url,
              launchMode: LaunchMode.externalApplication,
            );
          }
        }
      } else if (response.statusCode == 302) {
        await presentationActivity(
          credentialModels: credentialsToBePresented,
          issuer: issuer,
          uri: uri,
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
            emit(state.copyWith(status: ScanStatus.goBack));
            await qrCodeScanCubit.authorizedFlowStart(uri);
            return;
          }
        } else {
          throw ResponseMessage(
            message: ResponseString.RESPONSE_STRING_thisRequestIsNotSupported,
          );
        }
      } else {
        throw ResponseMessage(
          message: ResponseString
              .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
        );
      }
    } catch (e, s) {
      log.e('something went wrong - $e', error: e, stackTrace: s);
      emitError(e);
    }
  }

  Future<void> sendErrorToServer({
    required Uri uri,
    required Map<String, dynamic> data,
  }) async {
    final String responseOrRedirectUri =
        uri.queryParameters['redirect_uri'] ??
        uri.queryParameters['response_uri']!;

    await client.dio.post<dynamic>(
      responseOrRedirectUri,
      data: data,
      options: Options(
        headers: <String, dynamic>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      ),
    );
  }

  Future<(Map<String, dynamic>, VCFormatType)> getPresentationSubmission({
    required List<CredentialModel> credentialsToBePresented,
    required PresentationDefinition presentationDefinition,
    required Map<String, dynamic>? clientMetaData,
    required ProfileSetting profileSetting,
  }) async {
    final uuid1 = const Uuid().v4();

    final Map<String, dynamic> presentationSubmission = {
      'id': uuid1,
      'definition_id': presentationDefinition.id,
    };

    // final vcFormatType = profileSetting
    //     .selfSovereignIdentityOptions.customOidc4vcProfile.vcFormatType;

    final inputDescriptors = <Map<String, dynamic>>[];
    VCFormatType formatFromPresentationSubmission =
        int.parse(
              profileSetting
                  .selfSovereignIdentityOptions
                  .customOidc4vcProfile
                  .oidc4vciDraft
                  .numbering,
            ) <
            15
        ? VCFormatType.vcSdJWT
        : VCFormatType.dcSdJWT;
    for (int i = 0; i < credentialsToBePresented.length; i++) {
      for (final InputDescriptor inputDescriptor
          in presentationDefinition.inputDescriptors) {
        final filterList = inputDescriptor.constraints?.fields ?? <Field>[];

        final credential = getCredentialsFromFilterList(
          filterList: filterList,
          credentialList: [credentialsToBePresented[i]],
          profileType: profileCubit.state.model.profileType,
        );

        Map<String, dynamic>? pathNested;

        if (credential.isNotEmpty) {
          final format = getVcFormatType(credential[0].getFormat);
          final Map<String, dynamic> descriptor = {
            'id': inputDescriptor.id,
            'format': format.vpValue,
          };

          if (format == VCFormatType.vcSdJWT ||
              format == VCFormatType.dcSdJWT) {
            if (credentialsToBePresented.length == 1) {
              descriptor['path'] = r'$';
            } else {
              // ignore: prefer_interpolation_to_compose_strings
              descriptor['path'] = r'$[' + i.toString() + ']';
            }
          } else {
            descriptor['path'] = r'$';
            pathNested = {'id': inputDescriptor.id, 'format': format.vpValue};
            if (credentialsToBePresented.length == 1) {
              if (format == VCFormatType.ldpVc) {
                pathNested['path'] = r'$.verifiableCredential';
              } else {
                pathNested['path'] = r'$.vp.verifiableCredential[0]';
              }
            } else {
              if (format == VCFormatType.ldpVc) {
                pathNested['path'] =
                    // ignore: prefer_interpolation_to_compose_strings
                    r'$.verifiableCredential[' + i.toString() + ']';
              } else {
                pathNested['path'] =
                    // ignore: prefer_interpolation_to_compose_strings
                    r'$.vp.verifiableCredential[' + i.toString() + ']';
              }
            }
            pathNested['format'] = format.vcValue;
            descriptor['path_nested'] = pathNested;
          }

          inputDescriptors.add(descriptor);
          formatFromPresentationSubmission = format;
        }
      }
    }

    presentationSubmission['descriptor_map'] = inputDescriptors;

    return (presentationSubmission, formatFromPresentationSubmission);
  }

  Future<void> askPermissionDIDAuthCHAPI({
    required String keyId,
    String? challenge,
    String? domain,
    required Uri uri,
    required dynamic Function(String) done,
  }) async {
    emit(
      state.scanPermission(
        keyId: keyId,
        done: done,
        uri: uri,
        challenge: challenge,
        domain: domain,
      ),
    );
  }

  Future<dynamic> createVpToken({
    required List<CredentialModel> credentialsToBePresented,
    required PresentationDefinition presentationDefinition,
    required OIDC4VC oidc4vc,
    required String privateKey,
    required String did,
    required String kid,
    required Uri uri,
    required Map<String, dynamic>? clientMetaData,
    required ProfileSetting profileSetting,
    VCFormatType? formatFromPresentationSubmission,
  }) async {
    final nonce = uri.queryParameters['nonce'] ?? '';

    final customOidc4vcProfile = profileCubit
        .state
        .model
        .profileSetting
        .selfSovereignIdentityOptions
        .customOidc4vcProfile;

    final clientId = uri.queryParameters['client_id'];

    if (formatFromPresentationSubmission == VCFormatType.vcSdJWT ||
        formatFromPresentationSubmission == VCFormatType.dcSdJWT) {
      // check if response mode is direct_post.jwt or direct_post (default)
      // if direct_post.jwt we send a json else we send list of jwts
      final String? responseMode = uri.queryParameters['response_mode'];
      if (responseMode == 'direct_post.jwt') {
        final credentialJwtList = getCredentialMapForToken(
          credentialsToBePresented: credentialsToBePresented,
        );
        return credentialJwtList;
      }
      final credentialListJwt = getStringCredentialsForToken(
        credentialsToBePresented: credentialsToBePresented,
      );

      if (credentialListJwt.length == 1) {
        return credentialListJwt.first;
      } else {
        return jsonEncode(credentialListJwt);
      }
    } else if (formatFromPresentationSubmission == VCFormatType.jwtVc ||
        formatFromPresentationSubmission == VCFormatType.jwtVcJson ||
        formatFromPresentationSubmission == VCFormatType.jwtVcJsonLd) {
      final credentialList = getStringCredentialsForToken(
        credentialsToBePresented: credentialsToBePresented,
      );

      final vpToken = await oidc4vc.extractVpToken(
        clientId: clientId.toString(),
        credentialsToBePresented: credentialList,
        did: did,
        kid: kid,
        privateKey: privateKey,
        nonce: nonce,
        proofHeaderType: customOidc4vcProfile.proofHeader,
      );

      return vpToken;
    } else if (formatFromPresentationSubmission == VCFormatType.ldpVc) {
      /// proof is done with a creation date 20 seconds in the past to avoid
      /// proof check to fail because of time difference on server
      final options = jsonEncode({
        'verificationMethod': kid,
        'proofPurpose': 'authentication',
        'challenge': nonce,
        'domain': clientId,
        'created': DateTime.now()
            .subtract(const Duration(seconds: 20))
            .toUtc()
            .toIso8601String(),
      });

      final presentationId = 'urn:uuid:${const Uuid().v4()}';
      final vpToken = await didKitProvider.issuePresentation(
        jsonEncode({
          '@context': ['https://www.w3.org/2018/credentials/v1'],
          'type': ['VerifiablePresentation'],
          'holder': did,
          'id': presentationId,
          'verifiableCredential': credentialsToBePresented
              .map((c) => c.data)
              .toList(),
        }),
        options,
        privateKey,
      );
      return vpToken;
    } else {
      throw ResponseMessage(
        data: {
          'error': 'invalid_format',
          'error_description':
              // ignore: lines_longer_than_80_chars
              'Please present ldp_vc, jwt_vc, jwt_vc_json, dc+sd-jwt or vc+sd-jwt.',
        },
      );
    }
  }

  Future<String> createIdToken({
    required List<CredentialModel> credentialsToBePresented,
    required OIDC4VC oidc4vc,
    required String privateKey,
    required String did,
    required String kid,
    required Uri uri,
  }) async {
    final credentialList = getStringCredentialsForToken(
      credentialsToBePresented: credentialsToBePresented,
    );

    final customOidc4vcProfile = profileCubit
        .state
        .model
        .profileSetting
        .selfSovereignIdentityOptions
        .customOidc4vcProfile;

    final clientId = getClientIdForPresentation(
      uri.queryParameters['client_id'],
    );

    final nonce = uri.queryParameters['nonce'] ?? '';

    final idToken = await oidc4vc.extractIdToken(
      clientId: clientId.toString(),
      credentialsToBePresented: credentialList,
      did: did,
      kid: kid,
      privateKey: privateKey,
      nonce: nonce,
      clientType: customOidc4vcProfile.clientType,
      proofHeaderType: customOidc4vcProfile.proofHeader,
    );

    return idToken;
  }

  Future<void> presentationActivity({
    required List<CredentialModel> credentialModels,
    required Issuer issuer,
    required Uri uri,
  }) async {
    final log = getLogger('ScanCubit');
    log.i('adding presentation Activity');
    for (final credentialModel in credentialModels) {
      final now = DateTime.now();

      final Activity activity = Activity(
        presentation: Presentation(issuer: issuer, presentedAt: now),
      );
      credentialModel.activities.add(activity);

      final String responseOrRedirectUri =
          uri.queryParameters['redirect_uri'] ??
          uri.queryParameters['response_uri'] ??
          uri.origin;

      await activityLogManager.saveLog(
        LogData(
          type: LogType.presentVC,
          timestamp: now,
          vcInfo: VCInfo(
            id: credentialModel.id,
            name: credentialModel.getName,
            domain: Uri.parse(responseOrRedirectUri).origin,
          ),
        ),
      );

      log.i('presentation activity added to the credential');
      await credentialsCubit.updateCredential(
        credential: credentialModel,
        showMessage: false,
      );
    }
  }

  Future<void> addBlockchainSignedTransaction(
    List<Uint8List> signatures,
  ) async {
    emit(
      state.copyWith(
        blockchainTransactionsSignatures: signatures,
        status: ScanStatus.init,
      ),
    );
  }

  Future<void> addTransactionData(List<dynamic> transactionData) async {
    emit(
      state.copyWith(transactionData: transactionData, status: ScanStatus.init),
    );
  }
}
