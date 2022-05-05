import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/credentials/credential.dart';
import 'package:altme/qr_code/qr_code.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:bloc/bloc.dart';
import 'package:did_kit/did_kit.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:jose/jose.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:logging/logging.dart';
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
  }) : super(ScanStateIdle());

  final DioClient client;
  final WalletCubit walletCubit;
  final DIDKitProvider didKitProvider;
  final SecureStorageProvider secureStorageProvider;

  void emitScanStatePreview({Map<String, dynamic>? preview}) {
    emit(ScanStatePreview(preview: preview));
  }

  Future<void> credentialOffer({
    required String url,
    required CredentialModel credentialModel,
    required String keyId,
  }) async {
    final log = Logger('altme-wallet/scan/credential-offer');
    emit(ScanStateLoading());
    try {
      final did = (await secureStorageProvider.get(SecureStorageKeys.did))!;

      final dynamic credential = await client.post(
        url,
        data: FormData.fromMap(<String, dynamic>{'subject_id': did}),
      );

      final dynamic jsonCredential =
          credential is String ? jsonDecode(credential) : credential;

      final vcStr = jsonEncode(jsonCredential);
      final optStr = jsonEncode({'proofPurpose': 'assertionMethod'});
      final verification = await didKitProvider.verifyCredential(vcStr, optStr);

      debugPrint('[wallet/credential-offer/verify/vc] $vcStr');
      debugPrint('[wallet/credential-offer/verify/options] $optStr');
      debugPrint('[wallet/credential-offer/verify/result] $verification');

      final jsonVerification = jsonDecode(verification) as Map<String, dynamic>;

      if ((jsonVerification['warnings'] as List).isNotEmpty) {
        log.warning(
          'credential verification return warnings',
          jsonVerification['warnings'],
        );

        emit(
          ScanStateMessage(
            message: StateMessage.warning(
              messageHandler: ResponseMessage(
                ResponseString
                    .RESPONSE_STRING_CREDENTIAL_VERIFICATION_RETURN_WARNING,
              ),
            ),
          ),
        );
      }

      if ((jsonVerification['errors'] as List).isNotEmpty) {
        log.severe('failed to verify credential', jsonVerification['errors']);
        if (jsonVerification['errors'][0] != 'No applicable proof') {
          emit(
            ScanStateMessage(
              message: StateMessage.error(
                messageHandler: ResponseMessage(
                  ResponseString.RESPONSE_STRING_FAILED_TO_VERIFY_CREDENTIAL,
                ),
              ),
            ),
          );
          return emit(ScanStateIdle());
        }
      }

      await walletCubit.insertCredential(
        CredentialModel.copyWithData(
          oldCredentialModel: credentialModel,
          newData: jsonCredential as Map<String, dynamic>,
        ),
      );

      emit(ScanStateSuccess());
    } catch (e) {
      log.severe('something went wrong', e);
      emit(
        ScanStateMessage(
          message: StateMessage.error(
            messageHandler: ResponseMessage(
              ResponseString
                  .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
            ),
          ),
        ),
      );
      emit(ScanStateIdle());
    }
  }

  Future<void> verifiablePresentationRequest({
    required String url,
    required String keyId,
    required List<CredentialModel> credentials,
    required String challenge,
    required String domain,
  }) async {
    final log = Logger('altme-wallet/scan/verifiable-presentation-request');

    emit(ScanStateLoading());
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
          'verifiableCredential': credentials.length == 1
              ? credentials.first.data
              : credentials.map((c) => c.data).toList(),
        }),
        jsonEncode({
          'verificationMethod': verificationMethod,
          'proofPurpose': 'authentication',
          'challenge': challenge,
          'domain': domain,
        }),
        key,
      );

      await client.post(
        url,
        data: FormData.fromMap(<String, dynamic>{'presentation': presentation}),
      );

      emit(
        ScanStateMessage(
          message: StateMessage.success(
            messageHandler: ResponseMessage(
              ResponseString
                  .RESPONSE_STRING_SUCCESSFULLY_PRESENTED_YOUR_CREDENTIAL,
            ),
          ),
        ),
      );

      emit(ScanStateSuccess());
    } catch (e) {
      log.severe('something went wrong', e);
      emit(
        ScanStateMessage(
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

  //
  Future<void> storeCHAPI({
    required Map<String, dynamic> data,
    required void Function(String) done,
  }) async {
    final log = Logger('altme-wallet/scan/chapi-store');

    emit(ScanStateLoading());
    try {
      late final dynamic type;

      if (data['type'] is List<dynamic>) {
        type = data['type'].first;
      } else {
        type = data['type'];
      }

      late final dynamic vc;

      switch (type) {
        case 'VerifiablePresentation':
          vc = data['verifiableCredential'];
          break;

        case 'VerifiableCredential':
          vc = data;
          break;

        default:
          throw UnimplementedError('Unsupported dataType: $type');
      }

      final vcStr = jsonEncode(vc);
      final optStr = jsonEncode({'proofPurpose': 'assertionMethod'});
      final verification = await didKitProvider.verifyCredential(vcStr, optStr);

      debugPrint('[wallet/chapi-store/verify/vc] $vcStr');
      debugPrint('[wallet/chapi-store/verify/options] $optStr');
      debugPrint('[wallet/chapi-store/verify/result] $verification');

      final jsonVerification = jsonDecode(verification) as Map<String, dynamic>;

      if ((jsonVerification['warnings'] as List).isNotEmpty) {
        log.warning(
          'credential verification return warnings',
          jsonVerification['warnings'],
        );
        emit(
          ScanStateMessage(
            message: StateMessage.warning(
              messageHandler: ResponseMessage(
                ResponseString
                    .RESPONSE_STRING_CREDENTIAL_VERIFICATION_RETURN_WARNING,
              ),
            ),
          ),
        );
      }

      if ((jsonVerification['errors'] as List).isNotEmpty) {
        log.severe('failed to verify credential', jsonVerification['errors']);

        // done(jsonEncode(jsonVerification['errors']));

        emit(
          ScanStateMessage(
            message: StateMessage.warning(
              messageHandler: ResponseMessage(
                ResponseString.RESPONSE_STRING_FAILED_TO_VERIFY_CREDENTIAL,
              ),
            ),
          ),
        );
      }
      await walletCubit.insertCredential(vc as CredentialModel);

      done(vcStr);

      // emit(ScanStateMessage(StateMessage.success(
      //     'A new credential has been successfully added!')));
    } catch (e) {
      log.severe('something went wrong', e);

      emit(
        ScanStateMessage(
          message: StateMessage.warning(
            messageHandler: ResponseMessage(
              ResponseString
                  .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
            ),
          ),
        ),
      );
    }

    emit(ScanStateSuccess());
  }

  Future<void> getDIDAuthCHAPI({
    required Uri uri,
    required String keyId,
    required void Function(String) done,
    required String challenge,
    required String domain,
  }) async {
    final log = Logger('altme-wallet/scan/chapi-get-didauth');

    emit(ScanStateLoading());
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
            ScanStateMessage(
              message: StateMessage.success(
                messageHandler: ResponseMessage(
                  ResponseString
                      .RESPONSE_STRING_SUCCESSFULLY_PRESENTED_YOUR_CREDENTIAL,
                ),
              ),
            ),
          );

          emit(ScanStateSuccess());
        } else {
          emit(
            ScanStateMessage(
              message: StateMessage.warning(
                messageHandler: ResponseMessage(
                  ResponseString
                      .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
                ),
              ),
            ),
          );
        }
      } else {
        throw Exception('DID is not set. It is required to present DIDAuth');
      }
    } catch (e) {
      log.severe('something went wrong', e);
      emit(
        ScanStateMessage(
          message: StateMessage.warning(
            messageHandler: ResponseMessage(
              ResponseString
                  .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
            ),
          ),
        ),
      );
    }
  }

  Future<dynamic> presentCredentialToSiopV2Request({
    required CredentialModel credential,
    required SIOPV2Param sIOPV2Param,
  }) async {
    final log =
        Logger('altme-wallet/scan/present-credential-to-siop-v2-request');
    emit(ScanStateLoading());
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

      client.changeHeaders(
        <String, dynamic>{'Content-Type': 'application/x-www-form-urlencoded'},
      );
      final dynamic result = await client.post(
        sIOPV2Param.redirect_uri!,
        data: FormData.fromMap(<String, dynamic>{
          'vp_token': vpToken,
          'id_token': idToken,
        }),
      );

      client.changeHeaders(
        <String, dynamic>{'Content-Type': 'application/json; charset=UTF-8'},
      );

      if (result == 'Congrats ! Everything is ok') {
        emit(
          ScanStateMessage(
            message: StateMessage.success(
              messageHandler: ResponseMessage(
                ResponseString
                    .RESPONSE_STRING_SUCCESSFULLY_PRESENTED_YOUR_CREDENTIAL,
              ),
            ),
          ),
        );
      } else {
        emit(
          ScanStateMessage(
            message: StateMessage.warning(
              messageHandler: ResponseMessage(
                ResponseString
                    .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
              ),
            ),
          ),
        );
      }
    } catch (e) {
      log.severe('something went wrong', e);
      emit(
        ScanStateMessage(
          message: StateMessage.warning(
            messageHandler: ResponseMessage(
              ResponseString
                  .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
            ),
          ),
        ),
      );
      return;
    }
  }

  //
  Future<void> getQueryByExampleCHAPI({
    required String keyId,
    required List<CredentialModel> credentials,
    required String? challenge,
    required String? domain,
    required void Function(String) done,
    required Uri uri,
  }) async {
    final log = Logger('altme-wallet/scan/chapi-get-querybyexample');
    emit(ScanStateLoading());

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
          'verifiableCredential': credentials.length == 1
              ? credentials.first.toJson()
              : credentials.map((c) => c.toJson()).toList(),
        }),
        jsonEncode({
          'verificationMethod': verificationMethod,
          'proofPurpose': 'authentication',
          'challenge': challenge,
          'domain': domain,
        }),
        key,
      );

      done(presentation);

      emit(
        ScanStateMessage(
          message: StateMessage.success(
            messageHandler: ResponseMessage(
              ResponseString
                  .RESPONSE_STRING_SUCCESSFULLY_PRESENTED_YOUR_CREDENTIAL,
            ),
          ),
        ),
      );
    } catch (e) {
      log.severe('something went wrong', e);

      emit(
        ScanStateMessage(
          message: StateMessage.warning(
            messageHandler: ResponseMessage(
              ResponseString
                  .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
            ),
          ),
        ),
      );
    }

    emit(ScanStateSuccess());
  }

  //
  Future<void> storeQueryByExampleCHAPI({
    required Map<String, dynamic> data,
    required Uri uri,
  }) async {
    emit(ScanStateStoreQueryByExample(data: data, uri: uri));
  }

  Future<void> askPermissionDIDAuthCHAPI({
    required String keyId,
    String? challenge,
    String? domain,
    required Uri uri,
    required void Function(String) done,
  }) async {
    emit(
      ScanStateAskPermissionDIDAuth(
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
    final key = await secureStorageProvider.get(SecureStorageKeys.key);
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
      key!,
    );
    return vpToken;
  }

  Future<String> createIdToken({required String nonce}) async {
    final key = await secureStorageProvider.get(SecureStorageKeys.key);
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
      JsonWebKey.fromJson(jsonDecode(key!) as Map<String, dynamic>),
      algorithm: 'RS256',
    );

    // build the jws
    final jws = builder.build();

    // output the compact serialization
    debugPrint('jwt compact serialization: ${jws.toCompactSerialization()}');

    return jws.toCompactSerialization();
  }
}
