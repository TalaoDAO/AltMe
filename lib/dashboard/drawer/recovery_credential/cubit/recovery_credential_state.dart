part of 'recovery_credential_cubit.dart';

@JsonSerializable()
class RecoveryCredentialState extends Equatable {
  const RecoveryCredentialState({
    this.status = AppStatus.init,
    this.message,
    this.isTextFieldEdited = false,
    this.isMnemonicValid = false,
    this.recoveredCredentialLength,
    this.mnemonic,
    this.backupFilePath,
  });

  factory RecoveryCredentialState.fromJson(Map<String, dynamic> json) =>
      _$RecoveryCredentialStateFromJson(json);

  final AppStatus status;
  final StateMessage? message;
  final bool isTextFieldEdited;
  final bool isMnemonicValid;
  final int? recoveredCredentialLength;
  final String? mnemonic;
  final String? backupFilePath;

  RecoveryCredentialState loading() {
    return copyWith(
      status: AppStatus.loading,
      isTextFieldEdited: isTextFieldEdited,
      isMnemonicValid: isMnemonicValid,
      recoveredCredentialLength: recoveredCredentialLength,
    );
  }

  RecoveryCredentialState error({required MessageHandler messageHandler}) {
    return copyWith(
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
    String? mnemonic,
  }) {
    return copyWith(
      status: AppStatus.populate,
      isTextFieldEdited: isTextFieldEdited ?? this.isTextFieldEdited,
      isMnemonicValid: isMnemonicValid ?? this.isMnemonicValid,
      mnemonic: mnemonic,
    );
  }

  RecoveryCredentialState success({
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
      recoveredCredentialLength:
          recoveredCredentialLength ?? this.recoveredCredentialLength,
    );
  }

  RecoveryCredentialState copyWith({
    AppStatus? status,
    StateMessage? message,
    bool? isTextFieldEdited,
    bool? isMnemonicValid,
    int? recoveredCredentialLength,
    String? mnemonic,
    String? backupFilePath,
  }) {
    return RecoveryCredentialState(
      status: status ?? this.status,
      isTextFieldEdited: isTextFieldEdited ?? this.isTextFieldEdited,
      isMnemonicValid: isMnemonicValid ?? this.isMnemonicValid,
      message: message ?? this.message,
      recoveredCredentialLength:
          recoveredCredentialLength ?? this.recoveredCredentialLength,
      mnemonic: mnemonic ?? this.mnemonic,
      backupFilePath: backupFilePath ?? this.backupFilePath,
    );
  }

  Map<String, dynamic> toJson() => _$RecoveryCredentialStateToJson(this);

  @override
  List<Object?> get props => [
        status,
        isMnemonicValid,
        isTextFieldEdited,
        message,
        recoveredCredentialLength,
        mnemonic,
        backupFilePath,
      ];
}
