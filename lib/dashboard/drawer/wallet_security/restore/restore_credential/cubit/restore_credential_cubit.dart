import 'dart:convert';
import 'dart:io';

import 'package:altme/activity_log/activity_log.dart';
import 'package:altme/app/app.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';
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
    required this.activityLogManager,
    required this.profileCubit,
  }) : super(const RestoreCredentialState());

  final WalletCubit walletCubit;
  final CredentialsCubit credentialsCubit;
  final CryptocurrencyKeys cryptoKeys;
  final SecureStorageProvider secureStorageProvider;
  final PolygonId polygonId;
  final ActivityLogManager activityLogManager;
  final ProfileCubit profileCubit;

  void setFilePath({String? filePath}) {
    emit(state.copyWith(backupFilePath: filePath));
  }

  Future<void> recoverWallet({
    required bool isFromOnBoarding,
  }) async {
    if (state.backupFilePath == null) return;
    await Future<void>.delayed(const Duration(milliseconds: 500));
    emit(state.loading());

    late String stringForBackup;

    if (Parameters.importAndRestoreAtOnboarding) {
      final String? recoveryMnemonic = await secureStorageProvider
          .get(SecureStorageKeys.recoverCredentialMnemonics);

      if (recoveryMnemonic == null) {
        throw ResponseMessage(
          message: ResponseString
              .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
        );
      }
      stringForBackup = recoveryMnemonic;
    } else {
      final String? ssiMnemonic =
          await secureStorageProvider.get(SecureStorageKeys.ssiMnemonic);

      if (ssiMnemonic == null) {
        throw ResponseMessage(
          message: ResponseString
              .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
        );
      }
      stringForBackup = ssiMnemonic;
    }

    try {
      final file = File(state.backupFilePath!);
      final text = await file.readAsString();

      late List<CredentialModel> credentialList;

      final json = jsonDecode(text) as Map<String, dynamic>;
      if (!json.containsKey('cipherText') ||
          !json.containsKey('authenticationTag') ||
          json['cipherText'] is! String ||
          json['authenticationTag'] is! String) {
        throw ResponseMessage(
          message: ResponseString
              .RESPONSE_STRING_RECOVERY_CREDENTIAL_JSON_FORMAT_ERROR_MESSAGE,
        );
      }
      final encryption = Encryption(
        cipherText: json['cipherText'] as String,
        authenticationTag: json['authenticationTag'] as String,
      );
      final decryptedText =
          await cryptoKeys.decrypt(stringForBackup, encryption);
      final decryptedJson = jsonDecode(decryptedText) as Map<String, dynamic>;
      if (!decryptedJson.containsKey('date') ||
          !decryptedJson.containsKey('credentials') ||
          decryptedJson['date'] is! String) {
        throw ResponseMessage(
          message: ResponseString
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

      await credentialsCubit.recoverWallet(credentials: credentialList);

      final profile = decryptedJson['profile'];

      if (profile != null) {
        final profileType = ProfileType.values
            .firstWhereOrNull((ele) => ele.profileId == profile);

        if (profileType == null) {
          throw ResponseMessage(
            message: ResponseString.RESPONSE_STRING_AN_UNKNOWN_ERROR_HAPPENED,
          );
        }

        if (profileType == ProfileType.custom ||
            profileType == ProfileType.enterprise) {
          final profileSettingJson = decryptedJson['profileSetting'];

          if (profileSettingJson != null) {
            final profileSetting = ProfileSetting.fromJson(
              profileSettingJson as Map<String, dynamic>,
            );
            await profileCubit.setProfileSetting(
              profileSetting: profileSetting,
              profileType: profileType,
            );

            if (profileType == ProfileType.custom) {
              await secureStorageProvider.set(
                SecureStorageKeys.customProfileSettings,
                jsonEncode(profileSettingJson),
              );
            }
          }
        } else {
          await profileCubit.setProfile(profileType);
        }

        if (profileType == ProfileType.enterprise) {
          final enterprise = decryptedJson['enterprise'];
          if (enterprise != null) {
            final email = enterprise['email'];
            final password = enterprise['password'];
            final walletProvider = enterprise['walletProvider'];

            if (email != null) {
              await profileCubit.secureStorageProvider
                  .set(SecureStorageKeys.enterpriseEmail, email.toString());
            }

            if (password != null) {
              await profileCubit.secureStorageProvider.set(
                SecureStorageKeys.enterprisePassword,
                password.toString(),
              );
            }

            if (walletProvider != null) {
              await profileCubit.secureStorageProvider.set(
                SecureStorageKeys.enterpriseWalletProvider,
                walletProvider.toString(),
              );
            }
          }
        }
      }

      /// restore profile if it is enterprise account

      if (walletCubit.state.currentAccount != null) {
        await credentialsCubit.loadAllCredentials(
          blockchainType: walletCubit.state.currentAccount!.blockchainType,
        );
      }

      await activityLogManager.saveLog(LogData(type: LogType.restoreWallet));

      if (isFromOnBoarding) {
        emit(
          state.copyWith(
            status: AppStatus.restoreWallet,
            recoveredCredentialLength: credentialList.length,
          ),
        );
      } else {
        emit(state.success(recoveredCredentialLength: credentialList.length));
      }
    } catch (e) {
      if (e is MessageHandler) {
        emit(state.error(messageHandler: e));
      } else if (e.toString().startsWith('Auth message')) {
        emit(
          state.error(
            messageHandler: ResponseMessage(
              message: ResponseString
                  .RESPONSE_STRING_RECOVERY_CREDENTIAL_AUTH_ERROR_MESSAGE,
            ),
          ),
        );
      } else {
        emit(
          state.error(
            messageHandler: ResponseMessage(
              message: ResponseString
                  .RESPONSE_STRING_RECOVERY_CREDENTIAL_DEFAULT_ERROR_MESSAGE,
            ),
          ),
        );
      }
    }
  }
}
