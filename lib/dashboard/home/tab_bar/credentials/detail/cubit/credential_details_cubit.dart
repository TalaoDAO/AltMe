import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:did_kit/did_kit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';

part 'credential_details_cubit.g.dart';

part 'credential_details_state.dart';

class CredentialDetailsCubit extends Cubit<CredentialDetailsState> {
  CredentialDetailsCubit({
    required this.walletCubit,
    required this.didKitProvider,
  }) : super(const CredentialDetailsState());

  final WalletCubit walletCubit;
  final DIDKitProvider didKitProvider;

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
}
