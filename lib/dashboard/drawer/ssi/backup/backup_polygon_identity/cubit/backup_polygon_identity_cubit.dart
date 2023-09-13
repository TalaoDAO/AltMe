import 'dart:convert';
import 'dart:typed_data';

import 'package:altme/app/app.dart';
import 'package:altme/polygon_id/polygon_id.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';

import 'package:cryptocurrency_keys/cryptocurrency_keys.dart';
import 'package:equatable/equatable.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:secure_storage/secure_storage.dart';

part 'backup_polygon_identity_cubit.g.dart';
part 'backup_polygon_identity_state.dart';

class BackupPolygonIdIdentityCubit extends Cubit<BackupPolygonIdIdentityState> {
  BackupPolygonIdIdentityCubit({
    required this.secureStorageProvider,
    required this.cryptoKeys,
    required this.walletCubit,
    required this.fileSaver,
    required this.polygonIdCubit,
  }) : super(const BackupPolygonIdIdentityState());

  final SecureStorageProvider secureStorageProvider;
  final CryptocurrencyKeys cryptoKeys;
  final WalletCubit walletCubit;
  final FileSaver fileSaver;
  final PolygonIdCubit polygonIdCubit;

  Future<void> saveEncryptedFile() async {
    emit(state.loading());
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final mnemonic =
        await secureStorageProvider.get(SecureStorageKeys.ssiMnemonic);
    final isPermissionStatusGranted = await getStoragePermission();

    try {
      if (!isPermissionStatusGranted) {
        throw ResponseMessage(
          ResponseString.STORAGE_PERMISSION_DENIED_MESSAGE,
        );
      }

      final dateTime = getDateTimeWithoutSpace();
      final fileName = 'altme-polygonid-identity-$dateTime';

      await polygonIdCubit.initialise();

      String network = Parameters.POLYGON_MAIN_NETWORK;

      if (polygonIdCubit.state.currentNetwork ==
          PolygonIdNetwork.PolygonMainnet) {
        network = Parameters.POLYGON_MAIN_NETWORK;
      } else {
        network = Parameters.POLYGON_TEST_NETWORK;
      }

      final polygonCredentials = await polygonIdCubit.polygonId.backupIdentity(
        mnemonic: mnemonic!,
        network: network,
      );

      if (polygonCredentials == null) {
        throw ResponseMessage(
          ResponseString.RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
        );
      }

      final String encryptedString = polygonCredentials;

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
