part of 'import_account_cubit.dart';

@JsonSerializable()
class ImportAccountState extends Equatable {
  const ImportAccountState({
    this.status = AppStatus.init,
    this.message,
    this.isTextFieldEdited = false,
    this.isMnemonicOrKeyValid = false,
    this.accountType = AccountType.tezos,
  });

  factory ImportAccountState.fromJson(Map<String, dynamic> json) =>
      _$ImportAccountStateFromJson(json);

  final AppStatus status;
  final StateMessage? message;
  final bool isTextFieldEdited;
  final bool isMnemonicOrKeyValid;
  final AccountType accountType;

  ImportAccountState loading() {
    final loadingState = ImportAccountState(
      status: AppStatus.loading,
      isTextFieldEdited: isTextFieldEdited,
      isMnemonicOrKeyValid: isMnemonicOrKeyValid,
      accountType: accountType,
    );
    return loadingState;
  }

  ImportAccountState populating({
    bool? isTextFieldEdited,
    bool? isMnemonicOrKeyValid,
    int? recoveredCredentialLength,
    AccountType? accountType,
  }) {
    final populatingState = ImportAccountState(
      status: AppStatus.populate,
      isTextFieldEdited: isTextFieldEdited ?? this.isTextFieldEdited,
      isMnemonicOrKeyValid: isMnemonicOrKeyValid ?? this.isMnemonicOrKeyValid,
      accountType: accountType ?? this.accountType,
    );
    return populatingState;
  }

  ImportAccountState error({required MessageHandler messageHandler}) {
    final errorState = ImportAccountState(
      status: AppStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
      isTextFieldEdited: isTextFieldEdited,
      isMnemonicOrKeyValid: isMnemonicOrKeyValid,
      accountType: accountType,
    );
    return errorState;
  }

  ImportAccountState success({MessageHandler? messageHandler}) {
    final successState = ImportAccountState(
      status: AppStatus.success,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
      isTextFieldEdited: isTextFieldEdited,
      isMnemonicOrKeyValid: isMnemonicOrKeyValid,
      accountType: accountType,
    );
    return successState;
  }

  Map<String, dynamic> toJson() => _$ImportAccountStateToJson(this);

  @override
  List<Object?> get props => [
    status,
    isMnemonicOrKeyValid,
    isTextFieldEdited,
    message,
    accountType,
  ];
}
