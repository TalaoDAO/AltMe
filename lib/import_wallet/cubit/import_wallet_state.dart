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
    final importWalletState = ImportWalletState(
      status: AppStatus.loading,
      isTextFieldEdited: isTextFieldEdited,
      isMnemonicOrKeyValid: isMnemonicOrKeyValid,
    );
    return importWalletState;
  }

  ImportWalletState populating({
    bool? isTextFieldEdited,
    bool? isMnemonicOrKeyValid,
    int? recoveredCredentialLength,
  }) {
    final importWalletState = ImportWalletState(
      status: AppStatus.populate,
      isTextFieldEdited: isTextFieldEdited ?? this.isTextFieldEdited,
      isMnemonicOrKeyValid: isMnemonicOrKeyValid ?? this.isMnemonicOrKeyValid,
    );
    return importWalletState;
  }

  ImportWalletState error({required MessageHandler messageHandler}) {
    final importWalletState = ImportWalletState(
      status: AppStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
      isTextFieldEdited: isTextFieldEdited,
      isMnemonicOrKeyValid: isMnemonicOrKeyValid,
    );
    return importWalletState;
  }

  ImportWalletState copyWith({
    required AppStatus status,
    MessageHandler? messageHandler,
  }) {
    final importWalletState = ImportWalletState(
      status: status,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
      isTextFieldEdited: isTextFieldEdited,
      isMnemonicOrKeyValid: isMnemonicOrKeyValid,
    );
    return importWalletState;
  }

  ImportWalletState success({MessageHandler? messageHandler}) {
    final importWalletState = ImportWalletState(
      status: AppStatus.success,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
      isTextFieldEdited: isTextFieldEdited,
      isMnemonicOrKeyValid: isMnemonicOrKeyValid,
    );
    return importWalletState;
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
