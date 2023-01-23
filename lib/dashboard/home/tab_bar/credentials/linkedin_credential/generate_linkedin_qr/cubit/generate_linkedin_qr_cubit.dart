import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:did_kit/did_kit.dart';
import 'package:equatable/equatable.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:secure_storage/secure_storage.dart';
import 'package:uuid/uuid.dart';

part 'generate_linkedin_qr_cubit.g.dart';
part 'generate_linkedin_qr_state.dart';

class GenerateLinkedInQrCubit extends Cubit<GenerateLinkedInQrState> {
  GenerateLinkedInQrCubit({
    required this.didKitProvider,
    required this.secureStorageProvider,
    required this.fileSaver,
  }) : super(const GenerateLinkedInQrState());

  final DIDKitProvider didKitProvider;
  final SecureStorageProvider secureStorageProvider;
  final FileSaver fileSaver;

  Future<void> generatePresentationForLinkedInCard({
    required String liinkedUrl,
  }) async {
    final log = getLogger(
        'GenerateLinkedInQrCubit - generatePresentationForLinkedInCard');
    try {
      //TODO(bibas): fetch real data
      emit(state.loading());

      final did = (await secureStorageProvider.get(SecureStorageKeys.did))!;

      final presentationId = 'urn:uuid:${const Uuid().v4()}';

      final key = await secureStorageProvider.get(SecureStorageKeys.ssiKey);

      final verificationMethod =
          await secureStorageProvider.get(SecureStorageKeys.verificationMethod);

      final presentation = await didKitProvider.issuePresentation(
        jsonEncode({
          '@context': ['https://www.w3.org/2018/credentials/v1'],
          'type': ['VerifiablePresentation'],
          'id': presentationId,
          'holder': did,
          //'verifiableCredential': item.data,
        }),
        jsonEncode({
          'verificationMethod': verificationMethod,
          'proofPurpose': 'assertionMethod',
          //'challenge': credentialModel.challenge,
          //'domain': credentialModel.domain,
        }),
        key!,
      );

      emit(state.copyWith(status: AppStatus.idle, qrValue: presentation));
    } catch (e) {
      log.e('something went wrong - $e');
      if (e is ResponseMessage) {
        emit(state.error(messageHandler: e));
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

  Future<void> saveScreenshot(Uint8List capturedImage) async {
    emit(state.loading());
    final isPermissionStatusGranted = await getStoragePermission();

    try {
      if (!isPermissionStatusGranted) {
        // TODO(bibash): change string
        throw ResponseMessage(
          ResponseString
              .RESPONSE_STRING_BACKUP_CREDENTIAL_PERMISSION_DENIED_MESSAGE,
        );
      }
      final date = UiDate.formatDate(DateTime.now());
      final fileName = 'linkedin-banner-$date';

      final filePath =
          await fileSaver.saveAs(fileName, capturedImage, 'png', MimeType.PNG);

      emit(
        state.copyWith(
          status: AppStatus.success,
          messageHandler: ResponseMessage(
            ResponseString.RESPONSE_STRING_BACKUP_CREDENTIAL_SUCCESS_MESSAGE,
          ),
        ),
      );
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
