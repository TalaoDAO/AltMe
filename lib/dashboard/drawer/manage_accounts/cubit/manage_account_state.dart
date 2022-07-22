part of 'manage_account_cubit.dart';

@JsonSerializable()
class ManageAccountState extends Equatable {
  ManageAccountState({
    this.status = AppStatus.init,
    this.message,
    this.currentCryptoIndex = 0,
    CryptoAccount? cryptoAccount,
  }) : cryptoAccount = cryptoAccount ?? CryptoAccount(data: const []);

  factory ManageAccountState.fromJson(Map<String, dynamic> json) =>
      _$ManageAccountStateFromJson(json);

  final AppStatus status;
  final StateMessage? message;
  final int currentCryptoIndex;
  final CryptoAccount cryptoAccount;

  ManageAccountState loading() {
    return ManageAccountState(
      status: AppStatus.loading,
      currentCryptoIndex: currentCryptoIndex,
      cryptoAccount: cryptoAccount,
    );
  }

  ManageAccountState error({required MessageHandler messageHandler}) {
    return ManageAccountState(
      status: AppStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
      currentCryptoIndex: currentCryptoIndex,
      cryptoAccount: cryptoAccount,
    );
  }

  ManageAccountState success({
    MessageHandler? messageHandler,
    CryptoAccount? cryptoAccount,
    int? currentCryptoIndex,
  }) {
    return ManageAccountState(
      status: AppStatus.success,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
      currentCryptoIndex: currentCryptoIndex ?? this.currentCryptoIndex,
      cryptoAccount: cryptoAccount ?? this.cryptoAccount,
    );
  }

  Map<String, dynamic> toJson() => _$ManageAccountStateToJson(this);

  @override
  List<Object?> get props => [
    status,
    message,
  ];
}
