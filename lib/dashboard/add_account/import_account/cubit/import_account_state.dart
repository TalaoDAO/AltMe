part of 'import_account_cubit.dart';

@JsonSerializable()
class ImportAccountState extends Equatable {
  const ImportAccountState({
    this.status = AppStatus.init,
    this.message,
    this.isTextFieldEdited = false,
    this.isMnemonicOrKeyValid = false,
    this.mnemonicOrKey = '',
  });

  factory ImportAccountState.fromJson(Map<String, dynamic> json) =>
      _$ImportAccountStateFromJson(json);

  final AppStatus status;
  final StateMessage? message;
  final bool isTextFieldEdited;
  final bool isMnemonicOrKeyValid;
  final String mnemonicOrKey;

  ImportAccountState loading() {
    return ImportAccountState(
      status: AppStatus.loading,
      isTextFieldEdited: isTextFieldEdited,
      isMnemonicOrKeyValid: isMnemonicOrKeyValid,
      mnemonicOrKey: mnemonicOrKey,
    );
  }

  ImportAccountState populating({
    bool? isTextFieldEdited,
    bool? isMnemonicOrKeyValid,
    int? recoveredCredentialLength,
    String? mnemonicOrKey,
  }) {
    return ImportAccountState(
      status: AppStatus.populate,
      isTextFieldEdited: isTextFieldEdited ?? this.isTextFieldEdited,
      isMnemonicOrKeyValid: isMnemonicOrKeyValid ?? this.isMnemonicOrKeyValid,
      mnemonicOrKey: mnemonicOrKey ?? this.mnemonicOrKey,
    );
  }

  ImportAccountState error({required MessageHandler messageHandler}) {
    return ImportAccountState(
      status: AppStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
      isTextFieldEdited: isTextFieldEdited,
      isMnemonicOrKeyValid: isMnemonicOrKeyValid,
      mnemonicOrKey: mnemonicOrKey,
    );
  }

  ImportAccountState success({
    MessageHandler? messageHandler,
  }) {
    return ImportAccountState(
      status: AppStatus.success,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
      isTextFieldEdited: isTextFieldEdited,
      isMnemonicOrKeyValid: isMnemonicOrKeyValid,
      mnemonicOrKey: '',
    );
  }

  Map<String, dynamic> toJson() => _$ImportAccountStateToJson(this);

  @override
  List<Object?> get props => [
        status,
        isMnemonicOrKeyValid,
        isTextFieldEdited,
        message,
        mnemonicOrKey,
      ];
}
