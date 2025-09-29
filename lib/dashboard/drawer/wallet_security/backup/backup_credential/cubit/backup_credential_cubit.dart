import 'dart:convert';
import 'dart:typed_data';

import 'package:altme/activity_log/activity_log.dart';
import 'package:altme/app/app.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/profile/cubit/profile_cubit.dart';

import 'package:cryptocurrency_keys/cryptocurrency_keys.dart';
import 'package:equatable/equatable.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:secure_storage/secure_storage.dart';

part 'backup_credential_cubit.g.dart';
part 'backup_credential_state.dart';

class BackupCredentialCubit extends Cubit<BackupCredentialState> {
  BackupCredentialCubit({
    required this.secureStorageProvider,
    required this.cryptoKeys,
    required this.credentialsCubit,
    required this.fileSaver,
    required this.activityLogManager,
    required this.profileCubit,
  }) : super(const BackupCredentialState());

  final SecureStorageProvider secureStorageProvider;
  final CryptocurrencyKeys cryptoKeys;
  final CredentialsCubit credentialsCubit;
  final FileSaver fileSaver;
  final ActivityLogManager activityLogManager;
  final ProfileCubit profileCubit;

  Future<void> encryptAndDownloadFile() async {
    emit(state.loading());
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final isPermissionStatusGranted = await getStoragePermission();

    try {
      if (!isPermissionStatusGranted) {
        throw ResponseMessage(
          message: ResponseString.STORAGE_PERMISSION_DENIED_MESSAGE,
        );
      }

      final dateTime = getDateTimeWithoutSpace();
      final fileName = 'altme-data-$dateTime';

      final credentialModels = credentialsCubit.state.credentials;

      final date = UiDate.formatDate(DateTime.now());
      final message = {'date': date, 'credentials': credentialModels};

      final profileModel = profileCubit.state.model;

      message['profile'] = profileModel.profileType.profileId;

      if (profileModel.profileType == ProfileType.custom ||
          profileModel.profileType == ProfileType.enterprise) {
        final profileSetting = profileModel.profileSetting.toJson();
        message['profileSetting'] = profileSetting;
      }

      if (profileModel.profileType == ProfileType.enterprise) {
        final email = await profileCubit.secureStorageProvider.get(
          SecureStorageKeys.enterpriseEmail,
        );

        final password = await profileCubit.secureStorageProvider.get(
          SecureStorageKeys.enterprisePassword,
        );

        final walletProvider = await profileCubit.secureStorageProvider.get(
          SecureStorageKeys.enterpriseWalletProvider,
        );

        final enterprise = {
          'email': email,
          'password': password,
          'walletProvider': walletProvider,
        };

        message['enterprise'] = enterprise;
      }

      final mnemonic = await secureStorageProvider.get(
        SecureStorageKeys.ssiMnemonic,
      );

      final encrypted = await cryptoKeys.encrypt(
        jsonEncode(message),
        mnemonic!,
      );
      final encryptedString = jsonEncode(encrypted);

      final fileBytes = Uint8List.fromList(utf8.encode(encryptedString));

      final filePath = await fileSaver.saveAs(
        name: fileName,
        bytes: fileBytes,
        ext: 'txt',
        mimeType: MimeType.text,
      );

      if (filePath != null && filePath.isEmpty) {
        emit(state.copyWith(status: AppStatus.idle));
      } else {
        await activityLogManager.saveLog(LogData(type: LogType.backupData));
        emit(
          state.copyWith(
            status: AppStatus.success,
            filePath: filePath,
            messageHandler: ResponseMessage(
              message: ResponseString
                  .RESPONSE_STRING_BACKUP_CREDENTIAL_SUCCESS_MESSAGE,
            ),
          ),
        );
      }
    } catch (e) {
      if (e is MessageHandler) {
        emit(state.error(messageHandler: e));
      } else {
        emit(
          state.error(
            messageHandler: ResponseMessage(
              message: ResponseString.RESPONSE_STRING_BACKUP_CREDENTIAL_ERROR,
            ),
          ),
        );
      }
    }
  }
}
