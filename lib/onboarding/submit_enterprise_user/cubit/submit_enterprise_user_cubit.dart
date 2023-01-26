import 'dart:convert';
import 'dart:io';

import 'package:altme/app/app.dart';
import 'package:altme/did/did.dart';
import 'package:bloc/bloc.dart';
import 'package:did_kit/did_kit.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:json_path/json_path.dart';

import 'package:secure_storage/secure_storage.dart';

part 'submit_enterprise_user_cubit.g.dart';

part 'submit_enterprise_user_state.dart';

class SubmitEnterpriseUserCubit extends Cubit<SubmitEnterpriseUserState> {
  SubmitEnterpriseUserCubit({
    required this.didCubit,
    required this.secureStorageProvider,
    required this.didKitProvider,
  }) : super(const SubmitEnterpriseUserState());

  final DIDCubit didCubit;
  final DIDKitProvider didKitProvider;
  final SecureStorageProvider secureStorageProvider;

  void setRSAFile(PlatformFile? rsaFile) {
    emit(state.success(rsaFile: rsaFile));
  }

  Future<void> verify(String did) async {
    emit(state.loading());
    final log = getLogger('SubmitEnterpriseUserCubit - verify');
    try {
      if (did.isEmpty) {
        throw ResponseMessage(
          ResponseString.RESPONSE_STRING_PLEASE_ENTER_YOUR_DID_KEY,
        );
      }
      if (state.rsaFile == null) {
        throw ResponseMessage(
          ResponseString.RESPONSE_STRING_PLEASE_IMPORT_YOUR_RSA_KEY,
        );
      }
      final resolvedDID = await didKitProvider.resolveDID(did, '{}');
      final resolvedDIDJson = jsonDecode(resolvedDID) as Map<String, dynamic>;

      final error = resolvedDIDJson['didResolutionMetadata']['error']
          as Map<String, dynamic>?;
      if (error == null) {
        //read RSA json file
        if (state.rsaFile!.path == null) {
          throw ResponseMessage(
            ResponseString.RESPONSE_STRING_PLEASE_IMPORT_YOUR_RSA_KEY,
          );
        }
        if (did.trim().isEmpty) {
          throw ResponseMessage(
            ResponseString.RESPONSE_STRING_PLEASE_ENTER_YOUR_DID_KEY,
          );
        }
        final rsaJsonFile = File(state.rsaFile!.path!);
        final rsaJsonString = await rsaJsonFile.readAsString();
        final rsaKey = jsonDecode(rsaJsonString) as Map<String, dynamic>;
        final isValidRSAKey = checkPublicRSAKey(rsaKey, resolvedDIDJson);
        if (isValidRSAKey) {
          await secureStorageProvider.set(
            SecureStorageKeys.rsaKeyJson,
            rsaJsonString,
          );
          await secureStorageProvider.set(
            SecureStorageKeys.ssiKey,
            rsaJsonString,
          );
          final verificationMethod = rsaKey['kid'] as String;
          await didCubit.set(
            did: did,
            didMethod: AltMeStrings.enterpriseDIDMethod,
            didMethodName: AltMeStrings.enterpriseDIDMethodName,
            verificationMethod: verificationMethod,
          );

          emit(
            state.success(
              messageHandler: ResponseMessage(
                ResponseString
                    .RESPONSE_STRING_DID_KEY_AND_RSA_KEY_VERIFIED_SUCCESSFULLY,
              ),
            ),
          );
        } else {
          throw ResponseMessage(
            ResponseString.RESPONSE_STRING_RSA_NOT_MATCHED_WITH_DID_KEY,
          );
        }
      } else {
        throw ResponseMessage(
          ResponseString.RESPONSE_STRING_DID_KEY_NOT_RESOLVED,
        );
      }
      emit(state.success());
    } catch (e, s) {
      log.e('error in verifying RSA key :$e}, s: $s', e, s);
      if (e is MessageHandler) {
        emit(state.error(messageHandler: e));
      } else {
        emit(
          state.error(
            messageHandler: ResponseMessage(
              ResponseString.RESPONSE_STRING_AN_UNKNOWN_ERROR_HAPPENED,
            ),
          ),
        );
      }
    }
  }

  bool checkPublicRSAKey(
    Map<String, dynamic> rsaKey,
    Map<String, dynamic> resolvedDID,
  ) {
    try {
      final publicKeyJwks = JsonPath(r'$..publicKeyJwk');
      final publicKeyJwksList = publicKeyJwks
          .read(resolvedDID)
          .where((element) => element.value['kty'] == 'RSA')
          .toList();
      final privateRSAKeyAssertionMethod =
          resolvedDID['didDocument']['assertionMethod'] as List<dynamic>?;
      //               as List<dynamic>
      for (var i = 0; i < publicKeyJwksList.length; i++) {
        final privateRSAKey = publicKeyJwksList[i].value['n'] as String;
        if (privateRSAKey == rsaKey['n'] &&
            (privateRSAKeyAssertionMethod?.contains(rsaKey['kid']) ?? false)) {
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
