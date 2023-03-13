import 'dart:convert';
import 'dart:typed_data';

import 'package:altme/app/app.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';

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
    required this.walletCubit,
    required this.fileSaver,
  }) : super(const BackupCredentialState());

  final SecureStorageProvider secureStorageProvider;
  final CryptocurrencyKeys cryptoKeys;
  final WalletCubit walletCubit;
  final FileSaver fileSaver;

  String? mnemonics;

  Future<List<String>> loadMnemonic() async {
    final mnemonicList = await getssiMnemonicsInList(secureStorageProvider);
    mnemonics = mnemonicList.join(' ');
    return mnemonicList;
  }

  Future<void> encryptAndDownloadFile() async {
    emit(state.loading());
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final isPermissionStatusGranted = await getStoragePermission();

    try {
      if (!isPermissionStatusGranted) {
        throw ResponseMessage(
          ResponseString.STORAGE_PERMISSION_DENIED_MESSAGE,
        );
      }

      final dateTime = getDateTimeWithoutSpace();
      final fileName = 'altme-credential-$dateTime';

      final date = UiDate.formatDate(DateTime.now());
      final message = {
        'date': date,
        'credentials': walletCubit.state.credentials,
      };

      final encrypted =
          await cryptoKeys.encrypt(jsonEncode(message), mnemonics!);
      final fileBytes = Uint8List.fromList(utf8.encode(jsonEncode(encrypted)));
      final filePath =
          await fileSaver.saveAs(fileName, fileBytes, 'txt', MimeType.TEXT);

      if (filePath.isEmpty) {
        emit(state.copyWith(status: AppStatus.idle));
      } else {
        emit(
          state.copyWith(
            status: AppStatus.success,
            filePath: filePath,
            messageHandler: ResponseMessage(
              ResponseString.RESPONSE_STRING_BACKUP_CREDENTIAL_SUCCESS_MESSAGE,
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
              ResponseString.RESPONSE_STRING_BACKUP_CREDENTIAL_ERROR,
            ),
          ),
        );
      }
    }
  }
}
