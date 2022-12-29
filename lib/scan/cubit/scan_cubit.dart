import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/activity/activity.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:bloc/bloc.dart';
import 'package:did_kit/did_kit.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:jose/jose.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:secure_storage/secure_storage.dart';
import 'package:uuid/uuid.dart';

part 'scan_cubit.g.dart';
part 'scan_state.dart';

class ScanCubit extends Cubit<ScanState> {
  ScanCubit({
    required this.client,
    required this.walletCubit,
    required this.didKitProvider,
    required this.secureStorageProvider,
  }) : super(const ScanState());

  final DioClient client;
  final WalletCubit walletCubit;
  final DIDKitProvider didKitProvider;
  final SecureStorageProvider secureStorageProvider;

  Future<void> credentialOffer({
    required Uri uri,
    required CredentialModel credentialModel,
    required String keyId,
    List<CredentialModel>? credentialsToBePresented,
    required Issuer issuer,
  }) async {
    emit(state.loading());
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final log = getLogger('ScanCubit - credentialOffer');
    try {
      final did = (await secureStorageProvider.get(SecureStorageKeys.did))!;

      /// If credential manifest exist we follow instructions to present
      /// credential
      /// If credential manifest doesn't exist we add DIDAuth to the post
      /// If id was in preview we send it in the post
      ///  https://github.com/TalaoDAO/wallet-interaction/blob/main/README.md#credential-offer-protocol
      ///
      final key = (await secureStorageProvider.get(keyId))!;
      final verificationMethod =
          await secureStorageProvider.get(SecureStorageKeys.verificationMethod);

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

      if (!isEbsiIssuer(credentialModel)) {
        /// not verifying credential for did:ebsi issuer
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
            jsonVerification['warnings'],
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
          log.w('failed to verify credential', jsonVerification['errors']);
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

      await walletCubit.insertCredential(
        credential: CredentialModel.copyWithData(
          oldCredentialModel: credentialModel,
          newData: jsonCredential as Map<String, dynamic>,
          activities: activities,
        ),
      );

      if (credentialsToBePresented != null) {
        await presentationActivity(
          credentialModels: credentialsToBePresented,
          issuer: issuer,
        );
      }

      emit(state.copyWith(status: ScanStatus.success));
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

      await client.post(url, data: formData);

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
    required void Function(String) done,
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
    } catch (e) {
      log.e('something went wrong', e);
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

  Future<dynamic> presentCredentialToSiopV2Request({
    required CredentialModel credential,
    required SIOPV2Param sIOPV2Param,
    required Issuer issuer,
  }) async {
    final log = getLogger('ScanCubit - presentCredentialToSiopV2Request');
    emit(state.loading());
    await Future<void>.delayed(const Duration(milliseconds: 500));
    try {
      final vpToken = await createVpToken(
        credential: credential,
        challenge: sIOPV2Param.nonce!,
      );
      final idToken = await createIdToken(nonce: sIOPV2Param.nonce!);
      // prepare the post request
      // Content-Type: application/x-www-form-urlencoded
      // data =
      // id_token=encoded_jwt&vp_token=verifiable_presentation

      // There is a stackoverflow question about How to post
      // x-www-form-urlencoded in Flutter

      // execute the request
      // Request is sent to redirect_uri.

      final dynamic result = await client.post(
        sIOPV2Param.redirect_uri!,
        data: FormData.fromMap(<String, dynamic>{
          'vp_token': vpToken,
          'id_token': idToken,
        }),
        headers: <String, dynamic>{
          'Content-Type': 'application/x-www-form-urlencoded'
        },
      );

      if (result == 'Congrats ! Everything is ok') {
        await presentationActivity(
          credentialModels: [credential],
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
    } catch (e) {
      log.e('something went wrong', e);
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

  Future<void> askPermissionDIDAuthCHAPI({
    required String keyId,
    String? challenge,
    String? domain,
    required Uri uri,
    required void Function(String) done,
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
    required String challenge,
    required CredentialModel credential,
  }) async {
    final ssiKey = await secureStorageProvider.get(SecureStorageKeys.ssiKey);
    final did = await secureStorageProvider.get(SecureStorageKeys.did);
    final options = jsonEncode({
      'verificationMethod':
          await secureStorageProvider.get(SecureStorageKeys.verificationMethod),
      'proofPurpose': 'authentication',
      'challenge': challenge
    });
    final presentationId = 'urn:uuid:${const Uuid().v4()}';
    final vpToken = await didKitProvider.issuePresentation(
      jsonEncode({
        '@context': ['https://www.w3.org/2018/credentials/v1'],
        'type': ['VerifiablePresentation'],
        'id': presentationId,
        'holder': did,
        'verifiableCredential': credential.data,
      }),
      options,
      ssiKey!,
    );
    return vpToken;
  }

  Future<String> createIdToken({required String nonce}) async {
    final log = getLogger('ScanCubit - createIdToken');
    final ssiKey = await secureStorageProvider.get(SecureStorageKeys.ssiKey);
    final did = await secureStorageProvider.get(SecureStorageKeys.did);

    final timeStamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final dynamic claims = JsonWebTokenClaims.fromJson(<String, dynamic>{
      'exp': timeStamp + 600,
      'iat': timeStamp,
      'i_am_siop': true,
      'sub': did,
      'nonce': nonce,
    });

    // create a builder, decoding the JWT in a JWS, so using a
    // JsonWebSignatureBuilder
    final builder = JsonWebSignatureBuilder();

    // set the content
    builder.jsonContent = claims.toJson();

    // add a key to sign, can only add one for JWT
    builder.addRecipient(
      JsonWebKey.fromJson(jsonDecode(ssiKey!) as Map<String, dynamic>),
      algorithm: 'RS256',
    );

    // build the jws
    final jws = builder.build();

    // output the compact serialization
    log.i('jwt compact serialization: ${jws.toCompactSerialization()}');

    return jws.toCompactSerialization();
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
      await walletCubit.updateCredential(
        credential: credentialModel,
        showMessage: false,
      );
    }
  }
}
