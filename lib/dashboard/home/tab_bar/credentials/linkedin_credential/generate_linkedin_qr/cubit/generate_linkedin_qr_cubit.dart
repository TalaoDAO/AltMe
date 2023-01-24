import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/home/home.dart';
import 'package:altme/did/did.dart';
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
    required this.didCubit,
  }) : super(const GenerateLinkedInQrState());

  final DIDKitProvider didKitProvider;
  final SecureStorageProvider secureStorageProvider;
  final FileSaver fileSaver;
  final DIDCubit didCubit;

  Future<void> generatePresentationForLinkedInCard({
    required String linkedInUrl,
    required CredentialModel credentialModel,
  }) async {
    final log = getLogger(
      'GenerateLinkedInQrCubit - generatePresentationForLinkedInCard',
    );
    try {
      emit(state.loading());

      final presentationId = 'urn:uuid:${const Uuid().v4()}';

      final key = await secureStorageProvider.get(SecureStorageKeys.ssiKey);

      final presentation = await didKitProvider.issuePresentation(
        jsonEncode({
          '@context': ['https://www.w3.org/2018/credentials/v1'],
          'type': ['VerifiablePresentation'],
          'id': presentationId,
          'holder': didCubit.state.did,
          'verifiableCredential': credentialModel.data,
        }),
        jsonEncode({
          'verificationMethod': didCubit.state.verificationMethod,
          'proofPurpose': 'assertionMethod',
          'challenge': credentialModel.challenge,
          'domain': linkedInUrl,
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
                  .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
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
        throw ResponseMessage(ResponseString.STORAGE_PERMISSION_DENIED_MESSAGE);
      }
      final dateTime = getDateTimeWithoutSpace();
      final fileName = 'linkedin-banner-$dateTime';

      final filePath =
          await fileSaver.saveAs(fileName, capturedImage, 'png', MimeType.PNG);

      if (filePath.isEmpty) {
        emit(state.copyWith(status: AppStatus.idle));
      } else {
        emit(
          state.copyWith(
            status: AppStatus.success,
            messageHandler: ResponseMessage(
              ResponseString.RESPONSE_STRING_linkedInBannerSuccessfullyExported,
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
              ResponseString
                  .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
            ),
          ),
        );
      }
    }
  }
}
