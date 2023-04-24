import 'dart:convert';
import 'dart:io';

import 'package:altme/app/app.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/activity/activity.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:cryptocurrency_keys/cryptocurrency_keys.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:polygonid/polygonid.dart';
import 'package:secure_storage/secure_storage.dart';

part 'restore_credential_cubit.g.dart';
part 'restore_credential_state.dart';

class RestoreCredentialCubit extends Cubit<RestoreCredentialState> {
  RestoreCredentialCubit({
    required this.walletCubit,
    required this.credentialsCubit,
    required this.cryptoKeys,
    required this.secureStorageProvider,
    required this.polygonId,
  }) : super(const RestoreCredentialState());

  final WalletCubit walletCubit;
  final CredentialsCubit credentialsCubit;
  final CryptocurrencyKeys cryptoKeys;
  final SecureStorageProvider secureStorageProvider;
  final PolygonId polygonId;

  void setFilePath({String? filePath}) {
    emit(state.copyWith(backupFilePath: filePath));
  }

  Future<void> recoverWallet({required bool isPolygonIdCredentials}) async {
    if (state.backupFilePath == null) return;
    await Future<void>.delayed(const Duration(milliseconds: 500));
    emit(state.loading());

    try {
      final String? recoveryMnemonic = await secureStorageProvider
          .get(SecureStorageKeys.recoverCredentialMnemonics);

      if (recoveryMnemonic == null) {
        throw ResponseMessage(
          ResponseString.RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
        );
      }

      final file = File(state.backupFilePath!);
      final text = await file.readAsString();

      late List<CredentialModel> credentialList;

      if (isPolygonIdCredentials) {
        final privateIdentityEntity = await polygonId.restoreIdentity(
          mnemonic: recoveryMnemonic,
          encryptedDb: text,
        );

        final List<ClaimEntity> claims = await polygonId.restoreClaims(
          privateIdentityEntity: privateIdentityEntity,
        );

        final credentials = claims.map(
          (ClaimEntity claimEntity) {
            final jsonCredential = claimEntity.info;
            final credentialPreview = Credential.fromJson(jsonCredential);

            final credentialModel = CredentialModel(
              id: claimEntity.id,
              image: 'image',
              data: jsonCredential,
              display: Display.emptyDisplay()..toJson(),
              shareLink: '',
              credentialPreview: credentialPreview,
              expirationDate: claimEntity.expiration,
              activities: [Activity(acquisitionAt: DateTime.now())],
            );
            return credentialModel;
          },
        );
        credentialList = credentials.toList();
      } else {
        final json = jsonDecode(text) as Map<String, dynamic>;
        if (!json.containsKey('cipherText') ||
            !json.containsKey('authenticationTag') ||
            json['cipherText'] is! String ||
            json['authenticationTag'] is! String) {
          throw ResponseMessage(
            ResponseString
                .RESPONSE_STRING_RECOVERY_CREDENTIAL_JSON_FORMAT_ERROR_MESSAGE,
          );
        }
        final encryption = Encryption(
          cipherText: json['cipherText'] as String,
          authenticationTag: json['authenticationTag'] as String,
        );
        final decryptedText =
            await cryptoKeys.decrypt(recoveryMnemonic, encryption);
        final decryptedJson = jsonDecode(decryptedText) as Map<String, dynamic>;
        if (!decryptedJson.containsKey('date') ||
            !decryptedJson.containsKey('credentials') ||
            decryptedJson['date'] is! String) {
          throw ResponseMessage(
            ResponseString
                .RESPONSE_STRING_RECOVERY_CREDENTIAL_JSON_FORMAT_ERROR_MESSAGE,
          );
        }
        final List<dynamic> credentialJson =
            decryptedJson['credentials'] as List<dynamic>;
        final credentials = credentialJson.map(
          (dynamic credential) =>
              CredentialModel.fromJson(credential as Map<String, dynamic>),
        );

        credentialList = credentials.toList();
      }

      await credentialsCubit.recoverWallet(
        credentials: credentialList,
        isPolygonIdCredentials: isPolygonIdCredentials,
      );
      await credentialsCubit.loadAllCredentials();
      emit(state.success(recoveredCredentialLength: credentialList.length));
    } catch (e) {
      if (e is MessageHandler) {
        emit(state.error(messageHandler: e));
      } else if (e.toString().startsWith('Auth message')) {
        emit(
          state.error(
            messageHandler: ResponseMessage(
              ResponseString
                  .RESPONSE_STRING_RECOVERY_CREDENTIAL_AUTH_ERROR_MESSAGE,
            ),
          ),
        );
      } else {
        emit(
          state.error(
            messageHandler: ResponseMessage(
              ResponseString
                  .RESPONSE_STRING_RECOVERY_CREDENTIAL_DEFAULT_ERROR_MESSAGE,
            ),
          ),
        );
      }
    }
  }
}
