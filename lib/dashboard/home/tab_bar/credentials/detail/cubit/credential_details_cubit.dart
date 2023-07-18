import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/ebsi/verify_encoded_data.dart';
import 'package:altme/polygon_id/polygon_id.dart';
import 'package:did_kit/did_kit.dart';
import 'package:ebsi/ebsi.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:polygonid/polygonid.dart';
import 'package:secure_storage/secure_storage.dart';

part 'credential_details_cubit.g.dart';

part 'credential_details_state.dart';

class CredentialDetailsCubit extends Cubit<CredentialDetailsState> {
  CredentialDetailsCubit({
    required this.didKitProvider,
    required this.secureStorageProvider,
    required this.client,
    required this.jwtDecode,
    required this.polygonId,
    required this.polygonIdCubit,
  }) : super(const CredentialDetailsState());

  final DIDKitProvider didKitProvider;
  final SecureStorageProvider secureStorageProvider;
  final DioClient client;
  final JWTDecode jwtDecode;
  final PolygonId polygonId;
  final PolygonIdCubit polygonIdCubit;

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

      final encodedData = item.jwt!;

      final Map<String, dynamic> header =
          decodeHeader(jwtDecode: jwtDecode, token: encodedData);

      final String issuerKid = jsonEncode(header['kid']);

      final VerificationType isVerified = await verifyEncodedData(
        issuerDid,
        issuerKid,
        item.jwt!,
      );

      late CredentialStatus credentialStatus;

      switch (isVerified) {
        case VerificationType.verified:
          credentialStatus = CredentialStatus.active;
          break;
        case VerificationType.notVerified:
        case VerificationType.unKnown:
          credentialStatus = CredentialStatus.suspended;
          break;
      }

      emit(
        state.copyWith(
          credentialStatus: credentialStatus,
          status: AppStatus.idle,
        ),
      );
    } else if (isPolygonssuer(item)) {
      final mnemonic =
          await secureStorageProvider.get(SecureStorageKeys.ssiMnemonic);
      await polygonIdCubit.initialise();

      String network = Parameters.POLYGON_MAIN_NETWORK;

      if (item.issuer.contains('polygon:main')) {
        network = Parameters.POLYGON_MAIN_NETWORK;
      } else {
        network = Parameters.POLYGON_TEST_NETWORK;
      }

      final List<ClaimEntity> claim = await polygonId.getClaimById(
        claimId: item.id,
        mnemonic: mnemonic!,
        network: network,
      );

      late CredentialStatus credentialStatus;

      if (claim.isEmpty) {
        credentialStatus = CredentialStatus.suspended;
      } else {
        switch (claim[0].state) {
          case ClaimState.active:
            credentialStatus = CredentialStatus.active;
            break;
          case ClaimState.expired:
            credentialStatus = CredentialStatus.suspended;
            break;
          case ClaimState.pending:
            credentialStatus = CredentialStatus.pending;
            break;
          case ClaimState.revoked:
            credentialStatus = CredentialStatus.suspended;
            break;
        }
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
