import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/ebsi/verify_encoded_data.dart';
import 'package:did_kit/did_kit.dart';
import 'package:ebsi/ebsi.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:secure_storage/secure_storage.dart';

part 'credential_details_cubit.g.dart';

part 'credential_details_state.dart';

class CredentialDetailsCubit extends Cubit<CredentialDetailsState> {
  CredentialDetailsCubit({
    required this.didKitProvider,
    required this.secureStorageProvider,
    required this.client,
  }) : super(const CredentialDetailsState());

  final DIDKitProvider didKitProvider;
  final SecureStorageProvider secureStorageProvider;
  final DioClient client;

  void changeTabStatus(CredentialDetailTabStatus credentialDetailTabStatus) {
    emit(state.copyWith(credentialDetailTabStatus: credentialDetailTabStatus));
  }

  Future<void> verifyCredential(CredentialModel item) async {
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
        return;
      }
    }

    if (isEbsiIssuer(item)) {
      final issuerDid = item.data['issuer']! as String;
      //const issuerDid = 'did:ebsi:zeFCExU2XAAshYkPCpjuahA';

      final VerificationType isVerified = await verifyEncodedData(
        issuerDid,
        client,
        secureStorageProvider,
        item.jwt!,
      );

      late CredentialStatus credentialStatus;

      switch (isVerified) {
        case VerificationType.verified:
          credentialStatus = CredentialStatus.active;
          break;
        case VerificationType.notVerified:
          credentialStatus = CredentialStatus.pending;
          break;
        case VerificationType.unKnown:
          credentialStatus = CredentialStatus.unknown;
          break;
      }

      emit(
        state.copyWith(
          credentialStatus: credentialStatus,
          status: AppStatus.idle,
        ),
      );
    } else {
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
}
