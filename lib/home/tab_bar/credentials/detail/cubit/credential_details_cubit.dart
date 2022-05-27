import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/home/home.dart';
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

  void setTitle(String title) {
    emit(state.copyWith(title: title));
  }

  Future<void> verify(CredentialModel item) async {
    emit(state.copyWith(status: AppStatus.loading));
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final vcStr = jsonEncode(item.data);
    final optStr = jsonEncode({'proofPurpose': 'assertionMethod'});
    final result = await didKitProvider.verifyCredential(vcStr, optStr);
    final jsonResult = jsonDecode(result) as Map<String, dynamic>;

    if ((jsonResult['warnings'] as List).isNotEmpty) {
      emit(
        state.copyWith(
          verificationState: VerificationState.VerifiedWithWarning,
          status: AppStatus.error,
        ),
      );
    } else if ((jsonResult['errors'] as List).isNotEmpty) {
      if (jsonResult['errors'][0] == 'No applicable proof') {
        emit(
          state.copyWith(
            verificationState: VerificationState.Unverified,
            status: AppStatus.error,
          ),
        );
      } else {
        emit(
          state.copyWith(
            verificationState: VerificationState.VerifiedWithError,
            status: AppStatus.error,
          ),
        );
      }
    } else {
      emit(
        state.copyWith(
          verificationState: VerificationState.Verified,
          status: AppStatus.success,
        ),
      );
    }
  }

  Future<void> update(CredentialModel item, String newAlias) async {
    final newCredential = CredentialModel.copyWithAlias(
      oldCredentialModel: item,
      newAlias: newAlias,
    );
    await walletCubit.updateCredential(newCredential);
    setTitle(newAlias);
  }
}
