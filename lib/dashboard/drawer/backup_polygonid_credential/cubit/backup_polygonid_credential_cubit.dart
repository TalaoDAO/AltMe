import 'dart:convert';
import 'dart:typed_data';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';

import 'package:cryptocurrency_keys/cryptocurrency_keys.dart';
import 'package:equatable/equatable.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:polygonid/polygonid.dart';
import 'package:secure_storage/secure_storage.dart';

part 'backup_polygonid_credential_cubit.g.dart';
part 'backup_polygonid_credential_state.dart';

class BackupPolygonIdCredentialCubit
    extends Cubit<BackupPolygonIdCredentialState> {
  BackupPolygonIdCredentialCubit({
    required this.secureStorageProvider,
    required this.cryptoKeys,
    required this.walletCubit,
    required this.fileSaver,
    required this.polygonId,
  }) : super(const BackupPolygonIdCredentialState());

  final SecureStorageProvider secureStorageProvider;
  final CryptocurrencyKeys cryptoKeys;
  final WalletCubit walletCubit;
  final FileSaver fileSaver;
  final PolygonId polygonId;

  Future<void> downloaEncryptedFile() async {
    emit(state.loading());
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final mnemonicList = await getssiMnemonicsInList(secureStorageProvider);
    final isPermissionStatusGranted = await getStoragePermission();

    try {
      if (!isPermissionStatusGranted) {
        throw ResponseMessage(
          ResponseString.STORAGE_PERMISSION_DENIED_MESSAGE,
        );
      }

      final dateTime = getDateTimeWithoutSpace();
      final fileName = 'altme-polygonid-credential-$dateTime';

      //filter polygon id

      final polygonCredential = List.of(walletCubit.state.credentials)
          .where(
            (CredentialModel element) => element.id.startsWith(
              'https://self-hosted-platform.polygonid.me/v1/did:polygonid:polygon:',
            ),
          )
          .toList();

      if (polygonCredential.isEmpty) {
        throw ResponseMessage(
          ResponseString.RESPONSE_STRING_backupPolygonIdCredentialEmptyError,
        );
      }

      final date = UiDate.formatDate(DateTime.now());
      final message = {
        'date': date,
        'credentials': polygonCredential,
      };

      final encrypted =
          await cryptoKeys.encrypt(jsonEncode(message), mnemonicList.join(' '));
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
