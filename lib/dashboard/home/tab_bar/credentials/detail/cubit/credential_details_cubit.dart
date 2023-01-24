import 'dart:convert';
import 'dart:typed_data';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:did_kit/did_kit.dart';
import 'package:equatable/equatable.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'credential_details_cubit.g.dart';

part 'credential_details_state.dart';

class CredentialDetailsCubit extends Cubit<CredentialDetailsState> {
  CredentialDetailsCubit({
    required this.walletCubit,
    required this.didKitProvider,
    required this.fileSaver,
  }) : super(const CredentialDetailsState());

  final WalletCubit walletCubit;
  final DIDKitProvider didKitProvider;
  final FileSaver fileSaver;

  void changeTabStatus(CredentialDetailTabStatus credentialDetailTabStatus) {
    emit(state.copyWith(credentialDetailTabStatus: credentialDetailTabStatus));
  }

  Future<void> verifyCredential(CredentialModel item) async {
    if (isEbsiIssuer(item)) return;

    emit(state.copyWith(status: AppStatus.loading));
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (item.expirationDate != null) {
      final DateTime dateTimeExpirationDate =
          DateTime.parse(item.expirationDate!);
      if (!dateTimeExpirationDate.isAfter(DateTime.now())) {
        emit(
          state.copyWith(
            credentialStatus: CredentialStatus.suspended,
            status: AppStatus.idle,
          ),
        );
      }
    }
    if (item.credentialPreview.credentialStatus.type != '') {
      final CredentialStatus credentialStatus =
          await item.checkRevocationStatus();
      if (credentialStatus == CredentialStatus.active) {
        await verifyProofOfPurpose(item);
      } else {
        emit(
          state.copyWith(
            credentialStatus: CredentialStatus.suspended,
            status: AppStatus.idle,
          ),
        );
      }
    } else {
      await verifyProofOfPurpose(item);
    }
  }

  Future<void> verifyProofOfPurpose(CredentialModel item) async {
    final vcStr = jsonEncode(item.data);
    final optStr = jsonEncode({'proofPurpose': 'assertionMethod'});
    final result = await didKitProvider.verifyCredential(vcStr, optStr);
    final jsonResult = jsonDecode(result) as Map<String, dynamic>;

    if ((jsonResult['warnings'] as List).isNotEmpty) {
      emit(
        state.copyWith(
          credentialStatus: CredentialStatus.active,
          status: AppStatus.idle,
        ),
      );
    } else if ((jsonResult['errors'] as List).isNotEmpty) {
      if (jsonResult['errors'][0] == 'No applicable proof') {
        emit(
          state.copyWith(
            credentialStatus: CredentialStatus.suspended,
            status: AppStatus.idle,
          ),
        );
      } else {
        emit(
          state.copyWith(
            credentialStatus: CredentialStatus.suspended,
            status: AppStatus.idle,
          ),
        );
      }
    } else {
      emit(
        state.copyWith(
          credentialStatus: CredentialStatus.active,
          status: AppStatus.idle,
        ),
      );
    }
  }

  Future<void> exportCredential(CredentialModel credentialModel) async {
    emit(state.loading());
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final isPermissionStatusGranted = await getStoragePermission();

    try {
      if (!isPermissionStatusGranted) {
        throw ResponseMessage(ResponseString.STORAGE_PERMISSION_DENIED_MESSAGE);
      }

      final String name = credentialModel
          .credentialPreview.credentialSubjectModel.credentialSubjectType.name
          .toLowerCase();

      final dateTime = DateTime.fromMicrosecondsSinceEpoch(
        DateTime.now().microsecondsSinceEpoch,
      ).toString().replaceAll(' ', '-');

      final fileName = '$name-altme-credential-$dateTime';

      final String data = jsonEncode(credentialModel.data);

      final fileBytes = Uint8List.fromList(utf8.encode(data));
      final filePath =
          await fileSaver.saveAs(fileName, fileBytes, 'txt', MimeType.TEXT);

      if (filePath.isEmpty) {
        emit(state.copyWith(status: AppStatus.idle));
      } else {
        emit(
          state.copyWith(
            status: AppStatus.success,
            message: StateMessage.success(
              messageHandler: ResponseMessage(
                ResponseString.RESPONSE_STRING_credentialSuccessfullyExported,
              ),
            ),
          ),
        );
      }
    } catch (e) {
      if (e is MessageHandler) {
        emit(state.error(message: StateMessage.error(messageHandler: e)));
      } else {
        emit(
          state.error(
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
  }
}
