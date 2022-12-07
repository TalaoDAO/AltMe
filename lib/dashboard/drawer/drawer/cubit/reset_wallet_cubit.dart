import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reset_wallet_cubit.g.dart';
part 'reset_wallet_state.dart';

class ResetWalletCubit extends Cubit<ResetWalletState> {
  ResetWalletCubit() : super(const ResetWalletState());

  void toggleIsRecoveryPhraseWritten() {
    emit(
      state.copyWith(isRecoveryPhraseWritten: !state.isRecoveryPhraseWritten),
    );
  }

  void toggleIsBackupCredentialSaved() {
    emit(
      state.copyWith(isBackupCredentialSaved: !state.isBackupCredentialSaved),
    );
  }
}
