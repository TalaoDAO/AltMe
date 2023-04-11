part of 'manage_accounts_cubit.dart';

@JsonSerializable()
class ManageAccountsState extends Equatable {
  ManageAccountsState({
    this.status = AppStatus.init,
    this.message,
    this.currentCryptoIndex = 0,
    CryptoAccount? cryptoAccount,
  }) : cryptoAccount = cryptoAccount ?? CryptoAccount(data: const []);

  factory ManageAccountsState.fromJson(Map<String, dynamic> json) =>
      _$ManageAccountsStateFromJson(json);

  final AppStatus status;
  final StateMessage? message;
  final int currentCryptoIndex;
  final CryptoAccount cryptoAccount;

  ManageAccountsState loading() {
    return ManageAccountsState(
      status: AppStatus.loading,
      currentCryptoIndex: currentCryptoIndex,
      cryptoAccount: cryptoAccount,
    );
  }

  ManageAccountsState error({required MessageHandler messageHandler}) {
    return ManageAccountsState(
      status: AppStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
      currentCryptoIndex: currentCryptoIndex,
      cryptoAccount: cryptoAccount,
    );
  }

  ManageAccountsState success({
    MessageHandler? messageHandler,
    CryptoAccount? cryptoAccount,
    int? currentCryptoIndex,
  }) {
    return ManageAccountsState(
      status: AppStatus.success,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
      currentCryptoIndex: currentCryptoIndex ?? this.currentCryptoIndex,
      cryptoAccount: cryptoAccount ?? this.cryptoAccount,
    );
  }

  Map<String, dynamic> toJson() => _$ManageAccountsStateToJson(this);

  @override
  List<Object?> get props => [
    status,
    message,
  ];
}
