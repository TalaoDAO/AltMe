import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/credentials/cubit/credentials_cubit.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/activity/activity.dart';
import 'package:altme/did/did.dart';

import 'package:bloc/bloc.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:did_kit/did_kit.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:oidc4vc/oidc4vc.dart';

import 'package:secure_storage/secure_storage.dart';
import 'package:uuid/uuid.dart';

part 'scan_cubit.g.dart';
part 'scan_state.dart';

/// VC = Verifibale Credential : signed and issued by issuer
/// VP = Verifiable Presentation = VC + wallet signature
/// VP is what you trasnfer to Verifier in the Presentation Request prootocol

/// the issuer signs and sends a VC to the wallet
///the wallet stores the VC
/// If needed the wallet builds a VP with the VC and sends it to a Verifier

/// In LinkedIn case the VP is embedded in the QR code, not sent to the verifier

class ScanCubit extends Cubit<ScanState> {
  ScanCubit({
    required this.client,
    required this.credentialsCubit,
    required this.didKitProvider,
    required this.secureStorageProvider,
    required this.profileCubit,
    required this.didCubit,
    required this.oidc4vc,
  }) : super(const ScanState());

  final DioClient client;
  final CredentialsCubit credentialsCubit;
  final DIDKitProvider didKitProvider;
  final SecureStorageProvider secureStorageProvider;
  final ProfileCubit profileCubit;
  final DIDCubit didCubit;
  final OIDC4VC oidc4vc;

  Future<void> credentialOfferOrPresent({
    required Uri uri,
    required CredentialModel credentialModel,
    required String keyId,
    required List<CredentialModel>? credentialsToBePresented,
    required Issuer issuer,
  }) async {
    emit(state.loading());
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final log = getLogger('ScanCubit - credentialOffer');

    try {
      if (uri.toString().startsWith('openid')) {
        final bool isEBSIV3 =
            await isEBSIV3ForVerifier(client: client, uri: uri);

        final int indexValue = getIndexValue(isEBSIV3: isEBSIV3);

        final mnemonic =
            await getSecureStorage.get(SecureStorageKeys.ssiMnemonic);
        final privateKey = await oidc4vc.privateKeyFromMnemonic(
          mnemonic: mnemonic!,
          indexValue: indexValue,
        );

        final (did, kid) = await getDidAndKid(
          isEBSIV3: isEBSIV3,
          privateKey: privateKey,
          didKitProvider: didKitProvider,
        );

        final responseType = uri.queryParameters['response_type'] ?? '';
        final stateValue = uri.queryParameters['state'];

        if (uri.toString().startsWith('openid://') ||
            uri.toString().startsWith('openid-vc://?') ||
            uri.toString().startsWith('openid-hedera://?')) {
          if (responseType == 'id_token') {
            /// verifier side (siopv2) with request uri as value
            throw Exception();
          } else if (responseType == 'vp_token') {
            /// verifier side (oidc4vp) with request uri as value

            await presentCredentialToOID4VPRequest(
              uri: uri,
              issuer: issuer,
              credentialsToBePresented: credentialsToBePresented,
              presentationDefinition:
                  credentialModel.credentialManifest!.presentationDefinition!,
              oidc4vc: oidc4vc,
              did: did,
              kid: kid,
              privateKey: privateKey,
              indexValue: indexValue,
              stateValue: stateValue,
            );
            return;
          } else if (responseType == 'id_token vp_token') {
            /// verifier side (oidc4vp and siopv2) with request uri as value

            await presentCredentialToOIDC4VPAndSIOPV2RequestForOthers(
              uri: uri,
              issuer: issuer,
              credentialsToBePresented: credentialsToBePresented,
              presentationDefinition:
                  credentialModel.credentialManifest!.presentationDefinition!,
              oidc4vc: oidc4vc,
              did: did,
              kid: kid,
              privateKey: privateKey,
              indexValue: indexValue,
              stateValue: stateValue,
            );

            return;
          } else {
            throw Exception();
          }
        }
      } else {
        final did = (await secureStorageProvider.get(SecureStorageKeys.did))!;

        /// If credential manifest exist we follow instructions to present
        /// credential
        /// If credential manifest doesn't exist we add DIDAuth to the post
        /// If id was in preview we send it in the post
        ///  https://github.com/TalaoDAO/wallet-interaction/blob/main/README.md#credential-offer-protocol
        ///
        final key = (await secureStorageProvider.get(keyId))!;
        final verificationMethod = await secureStorageProvider
            .get(SecureStorageKeys.verificationMethod);

        List<String> presentations = <String>[];
        if (credentialsToBePresented == null) {
          final options = <String, dynamic>{
            'verificationMethod': verificationMethod,
            'proofPurpose': 'authentication',
            'challenge': credentialModel.challenge ?? '',
            'domain': credentialModel.domain ?? '',
          };

          final presentation = await didKitProvider.didAuth(
            did,
            jsonEncode(options),
            key,
          );

          presentations = List.of(presentations)..add(presentation);
        } else {
          for (final item in credentialsToBePresented) {
            final presentationId = 'urn:uuid:${const Uuid().v4()}';

            final presentation = await didKitProvider.issuePresentation(
              jsonEncode({
                '@context': ['https://www.w3.org/2018/credentials/v1'],
                'type': ['VerifiablePresentation'],
                'id': presentationId,
                'holder': did,
                'verifiableCredential': item.data,
              }),
              jsonEncode({
                'verificationMethod': verificationMethod,
                'proofPurpose': 'assertionMethod',
                'challenge': credentialModel.challenge,
                'domain': credentialModel.domain,
              }),
              key,
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
                  ResponseString
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
          credential: CredentialModel.copyWithData(
            oldCredentialModel: credentialModel,
            newData: jsonCredential as Map<String, dynamic>,
            activities: activities,
            credentialManifest: credentialManifest,
          ),
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
      if (e is ResponseMessage) {
        emit(state.error(messageHandler: e));
      } else if (e is NetworkException) {
        log.e('NetworkException - $e');
        if (e.message == NetworkError.NETWORK_ERROR_PRECONDITION_FAILED) {
          emit(
            state.copyWith(
              status: ScanStatus.error,
              message: StateMessage.error(
                messageHandler: e.data != null
                    ? null
                    : ResponseMessage(
                        ResponseString.RESPONSE_STRING_userNotFitErrorMessage,
                      ),
                stringMessage: e.data?.toString(),
                showDialog: true,
              ),
            ),
          );
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

  Future<void> verifiablePresentationRequest({
    required String url,
    required String keyId,
    required List<CredentialModel> credentialsToBePresented,
    required String challenge,
    required String domain,
    required Issuer issuer,
  }) async {
    final log = getLogger('ScanCubit - verifiablePresentationRequest');

    emit(state.loading());
    await Future<void>.delayed(const Duration(milliseconds: 500));
    try {
      final key = (await secureStorageProvider.get(keyId))!;
      final did = await secureStorageProvider.get(SecureStorageKeys.did);
      final verificationMethod =
          await secureStorageProvider.get(SecureStorageKeys.verificationMethod);

      final presentationId = 'urn:uuid:${const Uuid().v4()}';
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
        jsonEncode({
          'verificationMethod': verificationMethod,
          'proofPurpose': 'authentication',
          'challenge': challenge,
          'domain': domain,
        }),
        key,
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
                    ResponseString
                        .RESPONSE_STRING_SUCCESSFULLY_PRESENTED_YOUR_CREDENTIAL,
                  ),
          ),
        ),
      );
    } catch (e) {
      if (e is MessageHandler) {
        emit(
          state.error(messageHandler: e),
        );
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

  Future<void> getDIDAuthCHAPI({
    required Uri uri,
    required String keyId,
    required dynamic Function(String) done,
    required String challenge,
    required String domain,
  }) async {
    final log = getLogger('ScanCubit - getDIDAuthCHAPI');

    emit(state.loading());
    await Future<void>.delayed(const Duration(milliseconds: 500));
    try {
      final key = (await secureStorageProvider.get(keyId))!;
      final did = await secureStorageProvider.get(SecureStorageKeys.did);
      final verificationMethod =
          await secureStorageProvider.get(SecureStorageKeys.verificationMethod);

      if (did != null) {
        final presentation = await didKitProvider.didAuth(
          did,
          jsonEncode({
            'verificationMethod': verificationMethod,
            'proofPurpose': 'authentication',
            'challenge': challenge,
            'domain': domain,
          }),
          key,
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
                  ResponseString
                      .RESPONSE_STRING_SUCCESSFULLY_PRESENTED_YOUR_CREDENTIAL,
                ),
              ),
            ),
          );
        } else {
          throw ResponseMessage(
            ResponseString.RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
          );
        }
      } else {
        throw Exception('DID is not set. It is required to present DIDAuth');
      }
    } catch (e, s) {
      log.e('something went wrong', error: e, stackTrace: s);
      if (e is MessageHandler) {
        emit(
          state.error(messageHandler: e),
        );
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

  Future<dynamic> presentCredentialToOID4VPRequest({
    required List<CredentialModel>? credentialsToBePresented,
    required PresentationDefinition presentationDefinition,
    required Issuer issuer,
    required OIDC4VC oidc4vc,
    required String privateKey,
    required String did,
    required String kid,
    required Uri uri,
    required int indexValue,
    required String? stateValue,
  }) async {
    final log = getLogger('ScanCubit - presentCredentialToOID4VPRequest');
    emit(state.loading());
    await Future<void>.delayed(const Duration(milliseconds: 500));

    try {
      final String? redirectUri = getRedirectUri(uri);
      if (redirectUri == null) throw Exception();

      final String vpToken = await createVpToken(
        credentialsToBePresented: credentialsToBePresented!,
        did: did,
        kid: kid,
        oidc4vc: oidc4vc,
        presentationDefinition: presentationDefinition,
        privateKey: privateKey,
        uri: uri,
        indexValue: indexValue,
      );

      final presentationSubmissionString = getPresentationSubmission(
        presentationDefinition,
      );

      final responseData = <String, dynamic>{
        'vp_token': vpToken,
        'presentation_submission': presentationSubmissionString,
      };

      if (stateValue != null) {
        responseData['state'] = stateValue;
      }

      final formData = FormData.fromMap(responseData);

      final result = await client.post(
        redirectUri,
        data: formData,
        headers: <String, dynamic>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );

      if (result['status_code'] == 200) {
        await presentationActivity(
          credentialModels: credentialsToBePresented,
          issuer: issuer,
        );
        emit(
          state.copyWith(
            status: ScanStatus.success,
            message: StateMessage.success(
              messageHandler: ResponseMessage(
                ResponseString
                    .RESPONSE_STRING_SUCCESSFULLY_PRESENTED_YOUR_CREDENTIAL,
              ),
            ),
          ),
        );
      } else {
        throw ResponseMessage(
          ResponseString.RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
        );
      }
    } catch (e, s) {
      log.e('something went wrong', error: e, stackTrace: s);
      if (e is MessageHandler) {
        emit(
          state.error(messageHandler: e),
        );
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
      return;
    }
  }

  Future<dynamic> presentCredentialToOIDC4VPAndSIOPV2RequestForOthers({
    required List<CredentialModel>? credentialsToBePresented,
    required PresentationDefinition presentationDefinition,
    required Issuer issuer,
    required OIDC4VC oidc4vc,
    required String privateKey,
    required String did,
    required String kid,
    required Uri uri,
    required int indexValue,
    required String? stateValue,
  }) async {
    final log =
        getLogger('ScanCubit - presentCredentialToOIDC4VPAndSIOPV2Request');
    emit(state.loading());
    await Future<void>.delayed(const Duration(milliseconds: 500));

    try {
      final String? redirectUri = getRedirectUri(uri);
      if (redirectUri == null) throw Exception();

      final String idToken = await createIdToken(
        credentialsToBePresented: credentialsToBePresented!,
        did: did,
        kid: kid,
        oidc4vc: oidc4vc,
        privateKey: privateKey,
        uri: uri,
        indexValue: indexValue,
      );

      final String vpToken = await createVpToken(
        credentialsToBePresented: credentialsToBePresented,
        did: did,
        kid: kid,
        oidc4vc: oidc4vc,
        presentationDefinition: presentationDefinition,
        privateKey: privateKey,
        uri: uri,
        indexValue: indexValue,
      );

      final presentationSubmissionString = getPresentationSubmission(
        presentationDefinition,
      );

      final responseData = <String, dynamic>{
        'id_token': idToken,
        'vp_token': vpToken,
        'presentation_submission': presentationSubmissionString,
      };

      if (stateValue != null) {
        responseData['state'] = stateValue;
      }

      final formData = FormData.fromMap(responseData);

      final result = await client.post(
        redirectUri,
        data: formData,
        headers: <String, dynamic>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );

      if (result['status_code'] == 200) {
        await presentationActivity(
          credentialModels: credentialsToBePresented,
          issuer: issuer,
        );
        emit(
          state.copyWith(
            status: ScanStatus.success,
            message: StateMessage.success(
              messageHandler: ResponseMessage(
                ResponseString
                    .RESPONSE_STRING_SUCCESSFULLY_PRESENTED_YOUR_CREDENTIAL,
              ),
            ),
          ),
        );
      } else {
        throw ResponseMessage(
          ResponseString.RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
        );
      }
    } catch (e, s) {
      log.e('something went wrong', error: e, stackTrace: s);
      if (e is MessageHandler) {
        emit(
          state.error(messageHandler: e),
        );
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
      return;
    }
  }

  String getPresentationSubmission(
    PresentationDefinition presentationDefinition,
  ) {
    final uuid1 = const Uuid().v4();

    final Map<String, dynamic> presentationSubmission = {
      'id': uuid1,
      'definition_id': presentationDefinition.id,
    };

    final inputDescriptors = <Map<String, dynamic>>[];

    final presentLdpVc = presentationDefinition.format?.ldpVc != null;
    final presentJwtVc = presentationDefinition.format?.jwtVc != null;

    String? format;

    if (presentLdpVc) {
      format = 'ldp_vc';
    } else if (presentJwtVc) {
      format = 'jwt_vc';
    } else {
      throw Exception();
    }

    if (presentationDefinition.inputDescriptors.length == 1) {
      inputDescriptors.add({
        'id': presentationDefinition.inputDescriptors[0].id,
        'format': format,
        'path': r'$.verifiableCredential',
      });
    } else {
      for (int i = 0; i < presentationDefinition.inputDescriptors.length; i++) {
        inputDescriptors.add({
          'id': presentationDefinition.inputDescriptors[i].id,
          'format': format,
          // ignore: prefer_interpolation_to_compose_strings
          'path': r'$.verifiableCredential[' + i.toString() + ']',
        });
      }
    }

    presentationSubmission['descriptor_map'] = inputDescriptors;

    final presentationSubmissionString = jsonEncode(presentationSubmission);

    return presentationSubmissionString;
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
    required int indexValue,
  }) async {
    final nonce = uri.queryParameters['nonce'] ?? '';
    final clientId = uri.queryParameters['client_id'] ?? '';

    /// ldp_vc
    final presentLdpVc = presentationDefinition.format?.ldpVc != null;

    /// jwt_vc
    final presentJwtVc = presentationDefinition.format?.jwtVc != null;

    if (presentLdpVc) {
      final ssiKey = await secureStorageProvider.get(SecureStorageKeys.ssiKey);
      final did = await secureStorageProvider.get(SecureStorageKeys.did);
      final options = jsonEncode({
        'verificationMethod': await secureStorageProvider
            .get(SecureStorageKeys.verificationMethod),
        'proofPurpose': 'authentication',
        'challenge': nonce,
        'domain': clientId,
      });
      final presentationId = 'urn:uuid:${const Uuid().v4()}';
      final vpToken = await didKitProvider.issuePresentation(
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
        ssiKey!,
      );
      return vpToken;
    } else if (presentJwtVc) {
      final credentialList =
          credentialsToBePresented.map((e) => jsonEncode(e.toJson())).toList();

      final vpToken = await oidc4vc.extractVpToken(
        clientId: clientId,
        credentialsToBePresented: credentialList,
        did: did,
        kid: kid,
        privateKey: privateKey,
        indexValue: indexValue,
        nonce: nonce,
      );

      return vpToken;
    } else {
      throw Exception();
    }
  }

  Future<String> createIdToken({
    required List<CredentialModel> credentialsToBePresented,
    required OIDC4VC oidc4vc,
    required String privateKey,
    required String did,
    required String kid,
    required Uri uri,
    required int indexValue,
  }) async {
    final credentialList =
        credentialsToBePresented.map((e) => jsonEncode(e.toJson())).toList();

    final nonce = uri.queryParameters['nonce'] ?? '';
    final clientId = uri.queryParameters['client_id'] ?? '';

    final idToken = await oidc4vc.extractIdToken(
      clientId: clientId,
      credentialsToBePresented: credentialList,
      did: did,
      kid: kid,
      privateKey: privateKey,
      nonce: nonce,
      indexValue: indexValue,
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
