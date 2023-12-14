import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/oidc4vc/verify_encoded_data.dart';
import 'package:altme/polygon_id/polygon_id.dart';
import 'package:did_kit/did_kit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:oidc4vc/oidc4vc.dart';
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
    required this.profileCubit,
    required this.polygonIdCubit,
  }) : super(const CredentialDetailsState());

  final DIDKitProvider didKitProvider;
  final SecureStorageProvider secureStorageProvider;
  final DioClient client;
  final JWTDecode jwtDecode;
  final ProfileCubit profileCubit;
  final PolygonIdCubit polygonIdCubit;

  void changeTabStatus(CredentialDetailTabStatus credentialDetailTabStatus) {
    emit(state.copyWith(credentialDetailTabStatus: credentialDetailTabStatus));
  }

  Future<void> verifyCredential(CredentialModel item) async {
    emit(state.copyWith(status: AppStatus.loading));
    await Future<void>.delayed(const Duration(milliseconds: 500));

    if (item.credentialPreview.credentialSubjectModel.credentialSubjectType ==
        CredentialSubjectType.walletCredential) {
      emit(
        state.copyWith(
          credentialStatus: CredentialStatus.active,
          status: AppStatus.idle,
        ),
      );
      return;
    }

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

    if (item.jwt != null) {
      /// issuer did
      final issuerDid = item.issuer;

      late final String issuerKid;
      late final String encodedData;
      if (item.jwt == null) {
        issuerKid = item.data['proof']['verificationMethod'] as String;
      } else {
        encodedData = item.jwt!;

        final Map<String, dynamic> header =
            decodeHeader(jwtDecode: jwtDecode, token: encodedData);
        issuerKid = header['kid'].toString();
      }

      final VerificationType isVerified = await verifyEncodedData(
        issuerDid,
        issuerKid,
        encodedData,
      );

      late CredentialStatus credentialStatus;

      switch (isVerified) {
        case VerificationType.verified:
          credentialStatus = CredentialStatus.active;
        case VerificationType.notVerified:
          credentialStatus = CredentialStatus.notVerified;
        case VerificationType.unKnown:
          credentialStatus = CredentialStatus.suspended;
      }

      emit(
        state.copyWith(
          credentialStatus: credentialStatus,
          status: AppStatus.idle,
        ),
      );
    } else if (item.isPolygonssuer) {
      final mnemonic =
          await secureStorageProvider.get(SecureStorageKeys.ssiMnemonic);
      await polygonIdCubit.initialise();

      String network = Parameters.POLYGON_MAIN_NETWORK;

      if (item.issuer.contains('polygon:main')) {
        network = Parameters.POLYGON_MAIN_NETWORK;
      } else {
        network = Parameters.POLYGON_TEST_NETWORK;
      }

      final List<ClaimEntity> claim =
          await polygonIdCubit.polygonId.getClaimById(
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
          case ClaimState.expired:
            credentialStatus = CredentialStatus.expired;
          case ClaimState.pending:
            credentialStatus = CredentialStatus.pending;
          case ClaimState.revoked:
            credentialStatus = CredentialStatus.revoked;
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
    if (item.data.isEmpty) {
      return emit(
        state.copyWith(
          credentialStatus: CredentialStatus.pending,
          status: AppStatus.idle,
        ),
      );
    }
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
