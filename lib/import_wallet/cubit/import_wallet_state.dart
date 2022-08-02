part of 'import_wallet_cubit.dart';

@JsonSerializable()
class ImportWalletState extends Equatable {
  const ImportWalletState({
    this.status = AppStatus.init,
    this.message,
    this.isTextFieldEdited = false,
    this.isMnemonicOrKeyValid = false,
  });

  factory ImportWalletState.fromJson(Map<String, dynamic> json) =>
      _$ImportWalletStateFromJson(json);

  final AppStatus status;
  final StateMessage? message;
  final bool isTextFieldEdited;
  final bool isMnemonicOrKeyValid;

  ImportWalletState loading() {
    return ImportWalletState(
      status: AppStatus.loading,
      isTextFieldEdited: isTextFieldEdited,
      isMnemonicOrKeyValid: isMnemonicOrKeyValid,
    );
  }

  ImportWalletState populating({
    bool? isTextFieldEdited,
    bool? isMnemonicOrKeyValid,
    int? recoveredCredentialLength,
  }) {
    return ImportWalletState(
      status: AppStatus.populate,
      isTextFieldEdited: isTextFieldEdited ?? this.isTextFieldEdited,
      isMnemonicOrKeyValid: isMnemonicOrKeyValid ?? this.isMnemonicOrKeyValid,
    );
  }

  ImportWalletState error({required MessageHandler messageHandler}) {
    return ImportWalletState(
      status: AppStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
      isTextFieldEdited: isTextFieldEdited,
      isMnemonicOrKeyValid: isMnemonicOrKeyValid,
    );
  }

  ImportWalletState success({
    MessageHandler? messageHandler,
  }) {
    return ImportWalletState(
      status: AppStatus.success,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
      isTextFieldEdited: isTextFieldEdited,
      isMnemonicOrKeyValid: isMnemonicOrKeyValid,
    );
  }

  Map<String, dynamic> toJson() => _$ImportWalletStateToJson(this);

  @override
  List<Object?> get props => [
        status,
        isMnemonicOrKeyValid,
        isTextFieldEdited,
        message,
      ];
}
