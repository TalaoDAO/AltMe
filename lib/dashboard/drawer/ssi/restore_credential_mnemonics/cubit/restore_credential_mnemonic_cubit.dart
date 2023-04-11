import 'package:altme/app/app.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';

part 'restore_credential_mnemonic_cubit.g.dart';
part 'restore_credential_mnemonic_state.dart';

class RestoreCredentialMnemonicCubit
    extends Cubit<RestoreCredentialMnemonicState> {
  RestoreCredentialMnemonicCubit()
      : super(const RestoreCredentialMnemonicState());

  void isMnemonicsValid(String value) {
    emit(
      state.populating(
        isTextFieldEdited: value.isNotEmpty,
        isMnemonicValid: bip39.validateMnemonic(value) && value.isNotEmpty,
      ),
    );
  }
}
