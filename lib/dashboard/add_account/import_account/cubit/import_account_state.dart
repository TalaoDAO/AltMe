part of 'import_account_cubit.dart';

@JsonSerializable()
class ImportAccountState extends Equatable {
  const ImportAccountState({
    this.status = AppStatus.init,
    this.message,
    this.isTextFieldEdited = false,
    this.isMnemonicOrKeyValid = false,
    this.mnemonicOrKey = '',
    this.accountType = AccountType.tezos,
  });

  factory ImportAccountState.fromJson(Map<String, dynamic> json) =>
      _$ImportAccountStateFromJson(json);

  final AppStatus status;
  final StateMessage? message;
  final bool isTextFieldEdited;
  final bool isMnemonicOrKeyValid;
  final String mnemonicOrKey;
  final AccountType accountType;

  ImportAccountState loading() {
    return ImportAccountState(
      status: AppStatus.loading,
      isTextFieldEdited: isTextFieldEdited,
      isMnemonicOrKeyValid: isMnemonicOrKeyValid,
      mnemonicOrKey: mnemonicOrKey,
      accountType: accountType,
    );
  }

  ImportAccountState populating({
    bool? isTextFieldEdited,
    bool? isMnemonicOrKeyValid,
    int? recoveredCredentialLength,
    String? mnemonicOrKey,
    AccountType? accountType,
  }) {
    return ImportAccountState(
      status: AppStatus.populate,
      isTextFieldEdited: isTextFieldEdited ?? this.isTextFieldEdited,
      isMnemonicOrKeyValid: isMnemonicOrKeyValid ?? this.isMnemonicOrKeyValid,
      mnemonicOrKey: mnemonicOrKey ?? this.mnemonicOrKey,
      accountType: accountType ?? this.accountType,
    );
  }

  ImportAccountState error({required MessageHandler messageHandler}) {
    return ImportAccountState(
      status: AppStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
      isTextFieldEdited: isTextFieldEdited,
      isMnemonicOrKeyValid: isMnemonicOrKeyValid,
      mnemonicOrKey: mnemonicOrKey,
      accountType: accountType,
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
      accountType: accountType,
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
        accountType,
      ];
}
