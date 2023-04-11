part of 'restore_credential_mnemonic_cubit.dart';

@JsonSerializable()
class RestoreCredentialMnemonicState extends Equatable {
  const RestoreCredentialMnemonicState({
    this.status = AppStatus.init,
    this.message,
    this.isTextFieldEdited = false,
    this.isMnemonicValid = false,
  });

  factory RestoreCredentialMnemonicState.fromJson(Map<String, dynamic> json) =>
      _$RestoreCredentialMnemonicStateFromJson(json);

  final AppStatus status;
  final StateMessage? message;
  final bool isTextFieldEdited;
  final bool isMnemonicValid;

  RestoreCredentialMnemonicState loading() {
    return copyWith(
      status: AppStatus.loading,
      isTextFieldEdited: isTextFieldEdited,
      isMnemonicValid: isMnemonicValid,
    );
  }

  RestoreCredentialMnemonicState error(
      {required MessageHandler messageHandler}) {
    return copyWith(
      status: AppStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
      isTextFieldEdited: isTextFieldEdited,
      isMnemonicValid: isMnemonicValid,
    );
  }

  RestoreCredentialMnemonicState populating({
    bool? isTextFieldEdited,
    bool? isMnemonicValid,
  }) {
    return copyWith(
      status: AppStatus.populate,
      isTextFieldEdited: isTextFieldEdited ?? this.isTextFieldEdited,
      isMnemonicValid: isMnemonicValid ?? this.isMnemonicValid,
    );
  }

  RestoreCredentialMnemonicState success({
    MessageHandler? messageHandler,
    int? recoveredCredentialLength,
  }) {
    return copyWith(
      status: AppStatus.success,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
      isTextFieldEdited: isTextFieldEdited,
      isMnemonicValid: isMnemonicValid,
    );
  }

  RestoreCredentialMnemonicState copyWith({
    AppStatus? status,
    StateMessage? message,
    bool? isTextFieldEdited,
    bool? isMnemonicValid,
    int? recoveredCredentialLength,
    String? backupFilePath,
  }) {
    return RestoreCredentialMnemonicState(
      status: status ?? this.status,
      isTextFieldEdited: isTextFieldEdited ?? this.isTextFieldEdited,
      isMnemonicValid: isMnemonicValid ?? this.isMnemonicValid,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toJson() => _$RestoreCredentialMnemonicStateToJson(this);

  @override
  List<Object?> get props => [
        status,
        isMnemonicValid,
        isTextFieldEdited,
        message,
      ];
}
