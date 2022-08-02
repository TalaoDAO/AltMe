part of 'recovery_credential_cubit.dart';

@JsonSerializable()
class RecoveryCredentialState extends Equatable {
  const RecoveryCredentialState({
    this.status = AppStatus.init,
    this.message,
    this.isTextFieldEdited = false,
    this.isMnemonicValid = false,
    this.recoveredCredentialLength,
  });

  factory RecoveryCredentialState.fromJson(Map<String, dynamic> json) =>
      _$RecoveryCredentialStateFromJson(json);

  final AppStatus status;
  final StateMessage? message;
  final bool isTextFieldEdited;
  final bool isMnemonicValid;
  final int? recoveredCredentialLength;

  RecoveryCredentialState loading() {
    return RecoveryCredentialState(
      status: AppStatus.loading,
      isTextFieldEdited: isTextFieldEdited,
      isMnemonicValid: isMnemonicValid,
      recoveredCredentialLength: recoveredCredentialLength,
    );
  }

  RecoveryCredentialState error({required MessageHandler messageHandler}) {
    return RecoveryCredentialState(
      status: AppStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
      isTextFieldEdited: isTextFieldEdited,
      isMnemonicValid: isMnemonicValid,
      recoveredCredentialLength: recoveredCredentialLength,
    );
  }

  RecoveryCredentialState populating({
    bool? isTextFieldEdited,
    bool? isMnemonicValid,
    int? recoveredCredentialLength,
  }) {
    return RecoveryCredentialState(
      status: AppStatus.populate,
      isTextFieldEdited: isTextFieldEdited ?? this.isTextFieldEdited,
      isMnemonicValid: isMnemonicValid ?? this.isMnemonicValid,
    );
  }

  RecoveryCredentialState success({
    MessageHandler? messageHandler,
    int? recoveredCredentialLength,
  }) {
    return RecoveryCredentialState(
      status: AppStatus.success,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
      isTextFieldEdited: isTextFieldEdited,
      isMnemonicValid: isMnemonicValid,
      recoveredCredentialLength:
          recoveredCredentialLength ?? this.recoveredCredentialLength,
    );
  }

  Map<String, dynamic> toJson() => _$RecoveryCredentialStateToJson(this);

  @override
  List<Object?> get props => [
        status,
        isMnemonicValid,
        isTextFieldEdited,
        message,
        recoveredCredentialLength
      ];
}
