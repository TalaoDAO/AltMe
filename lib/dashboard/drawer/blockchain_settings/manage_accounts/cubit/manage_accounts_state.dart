part of 'manage_accounts_cubit.dart';

@JsonSerializable()
class ManageAccountsState extends Equatable {
  const ManageAccountsState({
    this.status = AppStatus.init,
    this.message,
    this.currentCryptoIndex = 0,
    CryptoAccount? cryptoAccount,
  }) : cryptoAccount = cryptoAccount ?? const CryptoAccount(data: []);

  factory ManageAccountsState.fromJson(Map<String, dynamic> json) =>
      _$ManageAccountsStateFromJson(json);

  final AppStatus status;
  final StateMessage? message;
  final int currentCryptoIndex;
  final CryptoAccount cryptoAccount;

  ManageAccountsState loading() {
    final loadingState = ManageAccountsState(
      status: AppStatus.loading,
      currentCryptoIndex: currentCryptoIndex,
      cryptoAccount: cryptoAccount,
    );
    return loadingState;
  }

  ManageAccountsState error({required MessageHandler messageHandler}) {
    final errorState = ManageAccountsState(
      status: AppStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
      currentCryptoIndex: currentCryptoIndex,
      cryptoAccount: cryptoAccount,
    );
    return errorState;
  }

  ManageAccountsState success({
    MessageHandler? messageHandler,
    CryptoAccount? cryptoAccount,
    int? currentCryptoIndex,
  }) {
    final successState = ManageAccountsState(
      status: AppStatus.success,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
      currentCryptoIndex: currentCryptoIndex ?? this.currentCryptoIndex,
      cryptoAccount: cryptoAccount ?? this.cryptoAccount,
    );
    return successState;
  }

  Map<String, dynamic> toJson() => _$ManageAccountsStateToJson(this);

  @override
  List<Object?> get props => [status, message];
}
