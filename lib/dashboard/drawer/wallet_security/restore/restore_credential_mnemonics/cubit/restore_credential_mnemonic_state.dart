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
    final loadingState = copyWith(
      status: AppStatus.loading,
      isTextFieldEdited: isTextFieldEdited,
      isMnemonicValid: isMnemonicValid,
    );
    return loadingState;
  }

  RestoreCredentialMnemonicState error({
    required MessageHandler messageHandler,
  }) {
    final errorState = copyWith(
      status: AppStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
      isTextFieldEdited: isTextFieldEdited,
      isMnemonicValid: isMnemonicValid,
    );
    return errorState;
  }

  RestoreCredentialMnemonicState populating({
    bool? isTextFieldEdited,
    bool? isMnemonicValid,
  }) {
    final populatingState = copyWith(
      status: AppStatus.populate,
      isTextFieldEdited: isTextFieldEdited ?? this.isTextFieldEdited,
      isMnemonicValid: isMnemonicValid ?? this.isMnemonicValid,
    );
    return populatingState;
  }

  RestoreCredentialMnemonicState success({
    MessageHandler? messageHandler,
    int? recoveredCredentialLength,
  }) {
    final successState = copyWith(
      status: AppStatus.success,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
      isTextFieldEdited: isTextFieldEdited,
      isMnemonicValid: isMnemonicValid,
    );
    return successState;
  }

  RestoreCredentialMnemonicState copyWith({
    AppStatus? status,
    StateMessage? message,
    bool? isTextFieldEdited,
    bool? isMnemonicValid,
    int? recoveredCredentialLength,
    String? backupFilePath,
  }) {
    final updatedState = RestoreCredentialMnemonicState(
      status: status ?? this.status,
      isTextFieldEdited: isTextFieldEdited ?? this.isTextFieldEdited,
      isMnemonicValid: isMnemonicValid ?? this.isMnemonicValid,
      message: message ?? this.message,
    );
    return updatedState;
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
