import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/credentials/cubit/credentials_cubit.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/activity/activity.dart';
import 'package:altme/wallet/wallet.dart';

import 'package:bloc/bloc.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:did_kit/did_kit.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
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
  }) : super(const ScanState());

  final DioClient client;
  final CredentialsCubit credentialsCubit;
  final DIDKitProvider didKitProvider;
  final SecureStorageProvider secureStorageProvider;
  final ProfileCubit profileCubit;
  final WalletCubit walletCubit;
  final OIDC4VC oidc4vc;
  final JWTDecode jwtDecode;

  Future<void> credentialOfferOrPresent({
    required Uri uri,
    required CredentialModel credentialModel,
    required String keyId,
    required List<CredentialModel>? credentialsToBePresented,
    required Issuer issuer,
    required QRCodeScanCubit qrCodeScanCubit,
  }) async {
    emit(state.loading());
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final log = getLogger('ScanCubit - credentialOffer');

    try {
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

      if (isSIOPV2OROIDC4VPUrl(uri)) {
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
        final didKeyType = profileCubit.state.model.profileSetting
            .selfSovereignIdentityOptions.customOidc4vcProfile.defaultDid;

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

        final dynamic jsonCredential =
            credential is String ? jsonDecode(credential) : credential;

        if (credentialModel.jwt == null) {
          /// not verifying credential for did:ebsi and did:web issuer
          log.i('verifying Credential');

          final vcStr = jsonEncode(jsonCredential);
          final optStr = jsonEncode({'proofPurpose': 'assertionMethod'});

          await Future<void>.delayed(const Duration(milliseconds: 500));
          final verification =
              await didKitProvider.verifyCredential(vcStr, optStr);

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

        final List<Activity> activities =
            List<Activity>.of(credentialModel.activities)
              ..add(Activity(acquisitionAt: DateTime.now()));

        CredentialManifest? credentialManifest;

        await credentialsCubit.insertCredential(
          blockchainType: walletCubit.state.currentAccount!.blockchainType,
          credential: CredentialModel.copyWithData(
            oldCredentialModel: credentialModel,
            newData: jsonCredential as Map<String, dynamic>,
            activities: activities,
            credentialManifest: credentialManifest,
          ),
          qrCodeScanCubit: qrCodeScanCubit,
        );

        if (credentialsToBePresented != null) {
          await presentationActivity(
            credentialModels: credentialsToBePresented,
            issuer: issuer,
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
    await Future<void>.delayed(const Duration(milliseconds: 500));
    try {
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
    await Future<void>.delayed(const Duration(milliseconds: 500));
    try {
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
        data: FormData.fromMap(<String, dynamic>{
          'presentation': presentation,
        }),
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
    final log =
        getLogger('ScanCubit - presentCredentialToOIDC4VPAndSIOPV2Request');
    emit(state.loading());
    await Future<void>.delayed(const Duration(milliseconds: 500));

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

      final String vpToken = await createVpToken(
        credentialsToBePresented: credentialsToBePresented,
        did: did,
        kid: kid,
        oidc4vc: oidc4vc,
        presentationDefinition: presentationDefinition,
        privateKey: privateKey,
        uri: uri,
        clientMetaData: clientMetaData,
        profileSetting: qrCodeScanCubit.profileCubit.state.model.profileSetting,
      );

      final presentationSubmission = await getPresentationSubmission(
        credentialsToBePresented: credentialsToBePresented,
        presentationDefinition: presentationDefinition,
        clientMetaData: clientMetaData,
        profileSetting: qrCodeScanCubit.profileCubit.state.model.profileSetting,
      );

      Map<String, dynamic> body;

      final String? responseMode = uri.queryParameters['response_mode'];

      if (responseMode == 'direct_post.jwt') {
        final iat = (DateTime.now().millisecondsSinceEpoch / 1000).round();

        final clientId = uri.queryParameters['client_id'] ?? '';

        final customOidc4vcProfile = profileCubit.state.model.profileSetting
            .selfSovereignIdentityOptions.customOidc4vcProfile;

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
          did: '', // just added as it is required field
          mediaType: MediaType.basic, // just added as it is required field
          clientType:
              ClientType.p256JWKThumprint, // just added as it is required field
          proofHeaderType: customOidc4vcProfile.proofHeader,
          clientId: '', // just added as it is required field
        );

        final jwtProofOfPossession = profileCubit.oidc4vc.generateToken(
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

      await Future<void>.delayed(const Duration(seconds: 2));
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

  Future<Map<String, dynamic>> getPresentationSubmission({
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

    final vcFormatType = profileSetting
        .selfSovereignIdentityOptions.customOidc4vcProfile.vcFormatType;

    final inputDescriptors = <Map<String, dynamic>>[];

    String? vcFormat;
    String? vpFormat;

    if (presentationDefinition.format != null) {
      final ldpVc = presentationDefinition.format?.ldpVc != null;
      final jwtVc = presentationDefinition.format?.jwtVc != null;
      final jwtVcJson = presentationDefinition.format?.jwtVcJson != null;

      if (ldpVc) {
        vcFormat = 'ldp_vc';
      } else if (jwtVc) {
        vcFormat = 'jwt_vc';
      } else if (jwtVcJson) {
        vcFormat = 'jwt_vc_json';
      }

      final ldpVp = presentationDefinition.format?.ldpVp != null;
      final jwtVp = presentationDefinition.format?.jwtVp != null;
      final jwtVpJson = presentationDefinition.format?.jwtVpJson != null;
      final vcSdJwt = presentationDefinition.format?.vcSdJwt != null;

      if (ldpVp) {
        vpFormat = 'ldp_vp';
      } else if (jwtVp) {
        vpFormat = 'jwt_vp';
      } else if (jwtVpJson) {
        vpFormat = 'jwt_vp_json';
      } else if (vcSdJwt) {
        vpFormat = 'vc+sd-jwt';
      }
    } else {
      if (clientMetaData == null) {
        vcFormat = vcFormatType.vcValue;
        vpFormat = vcFormatType.vpValue;
      } else {
        final vpFormats = clientMetaData['vp_formats'] as Map<String, dynamic>;

        if (vpFormats.containsKey('ldp_vc')) {
          vcFormat = 'ldp_vc';
        } else if (vpFormats.containsKey('jwt_vc')) {
          vcFormat = 'jwt_vc';
        } else if (vpFormats.containsKey('jwt_vc_json')) {
          vcFormat = 'jwt_vc_json';
        }

        if (vpFormats.containsKey('ldp_vp')) {
          vpFormat = 'ldp_vp';
        } else if (vpFormats.containsKey('jwt_vp')) {
          vpFormat = 'jwt_vp';
        } else if (vpFormats.containsKey('jwt_vp_json')) {
          vpFormat = 'jwt_vp_json';
        } else if (vpFormats.containsKey('vc+sd-jwt')) {
          vpFormat = 'vc+sd-jwt';
        }
      }
    }

    for (int i = 0; i < credentialsToBePresented.length; i++) {
      for (final InputDescriptor inputDescriptor
          in presentationDefinition.inputDescriptors) {
        final filterList = inputDescriptor.constraints?.fields ?? <Field>[];

        final credential = getCredentialsFromFilterList(
          filterList: filterList,
          credentialList: [credentialsToBePresented[i]],
        );

        Map<String, dynamic>? pathNested;

        if (vcFormatType != VCFormatType.vcSdJWT) {
          pathNested = {
            'id': inputDescriptor.id,
            'format': vcFormat,
          };
        }

        if (credential.isNotEmpty) {
          final Map<String, dynamic> descriptor = {
            'id': inputDescriptor.id,
            'format': vpFormat,
            'path': r'$',
          };

          if (vcFormatType != VCFormatType.vcSdJWT && pathNested != null) {
            if (credentialsToBePresented.length == 1) {
              if (vpFormat == 'ldp_vp') {
                pathNested['path'] = r'$.verifiableCredential';
              } else if (vpFormat == 'vc+sd-jwt') {
                pathNested['path'] = r'$';
              } else {
                pathNested['path'] = r'$.vp.verifiableCredential[0]';
              }
            } else {
              if (vpFormat == 'ldp_vp') {
                pathNested['path'] =
                    // ignore: prefer_interpolation_to_compose_strings
                    r'$.verifiableCredential[' + i.toString() + ']';
              } else if (vpFormat == 'vc+sd-jwt') {
                pathNested['path'] = r'$';
              } else {
                pathNested['path'] =
                    // ignore: prefer_interpolation_to_compose_strings
                    r'$.vp.verifiableCredential[' + i.toString() + ']';
              }
            }
            pathNested['format'] = vcFormat ?? vcFormatType.vcValue;
            descriptor['path_nested'] = pathNested;
          }

          inputDescriptors.add(descriptor);
        }
      }
    }

    presentationSubmission['descriptor_map'] = inputDescriptors;

    return presentationSubmission;
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

  Future<String> createVpToken({
    required List<CredentialModel> credentialsToBePresented,
    required PresentationDefinition presentationDefinition,
    required OIDC4VC oidc4vc,
    required String privateKey,
    required String did,
    required String kid,
    required Uri uri,
    required Map<String, dynamic>? clientMetaData,
    required ProfileSetting profileSetting,
  }) async {
    final nonce = uri.queryParameters['nonce'] ?? '';
    final clientId = uri.queryParameters['client_id'] ?? '';

    final customOidc4vcProfile =
        profileSetting.selfSovereignIdentityOptions.customOidc4vcProfile;

    final vcFormatType = customOidc4vcProfile.vcFormatType;

    final (presentLdpVc, presentJwtVc, presentJwtVcJson, presentVcSdJwt) =
        getPresentVCDetails(
      clientMetaData: clientMetaData,
      presentationDefinition: presentationDefinition,
      vcFormatType: vcFormatType,
      credentialsToBePresented: credentialsToBePresented,
    );

    if (presentLdpVc) {
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
          'verifiableCredential': credentialsToBePresented.length == 1
              ? credentialsToBePresented.first.data
              : credentialsToBePresented.map((c) => c.data).toList(),
        }),
        options,
        privateKey,
      );
      return vpToken;
    } else if (presentJwtVc || presentJwtVcJson) {
      final credentialList = getStringCredentialsForToken(
        credentialsToBePresented: credentialsToBePresented,
        profileCubit: profileCubit,
      );

      final vpToken = await oidc4vc.extractVpToken(
        clientId: clientId,
        credentialsToBePresented: credentialList,
        did: did,
        kid: kid,
        privateKey: privateKey,
        nonce: nonce,
        proofHeaderType: customOidc4vcProfile.proofHeader,
      );

      return vpToken;
    } else if (presentVcSdJwt) {
      final credentialList = getStringCredentialsForToken(
        credentialsToBePresented: credentialsToBePresented,
        profileCubit: profileCubit,
      );

      final vpToken = credentialList.first;
      // considering only one

      return vpToken;
    } else {
      throw ResponseMessage(
        data: {
          'error': 'invalid_format',
          'error_description':
              'Please present ldp_vc, jwt_vc, jwt_vc_json or vc+sd-jwt.',
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
      profileCubit: profileCubit,
    );

    final nonce = uri.queryParameters['nonce'] ?? '';
    final clientId = uri.queryParameters['client_id'] ?? '';

    final customOidc4vcProfile = profileCubit.state.model.profileSetting
        .selfSovereignIdentityOptions.customOidc4vcProfile;

    final idToken = await oidc4vc.extractIdToken(
      clientId: clientId,
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
  }) async {
    final log = getLogger('ScanCubit');
    log.i('adding presentation Activity');
    for (final credentialModel in credentialModels) {
      final Activity activity = Activity(
        presentation: Presentation(
          issuer: issuer,
          presentedAt: DateTime.now(),
        ),
      );
      credentialModel.activities.add(activity);

      log.i('presentation activity added to the credential');
      await credentialsCubit.updateCredential(
        credential: credentialModel,
        showMessage: false,
      );
    }
  }
}
