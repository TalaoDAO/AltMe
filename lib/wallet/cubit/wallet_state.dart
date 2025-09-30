part of 'wallet_cubit.dart';

@JsonSerializable()
class WalletState extends Equatable {
  const WalletState({
    this.status = WalletStatus.init,
    this.message,
    this.currentCryptoIndex = 0,
    this.cryptoAccount = const CryptoAccount(),
  });

  factory WalletState.fromJson(Map<String, dynamic> json) =>
      _$WalletStateFromJson(json);

  final WalletStatus status;
  final StateMessage? message;
  final int currentCryptoIndex;
  final CryptoAccount cryptoAccount;

  CryptoAccountData? get currentAccount {
    return cryptoAccount.data.length > currentCryptoIndex
        ? cryptoAccount.data[currentCryptoIndex]
        : null;
  }

  WalletState loading() {
    return WalletState(
      status: WalletStatus.loading,
      currentCryptoIndex: currentCryptoIndex,
      cryptoAccount: cryptoAccount,
    );
  }

  WalletState error({required MessageHandler messageHandler}) {
    return WalletState(
      status: WalletStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
      currentCryptoIndex: currentCryptoIndex,
      cryptoAccount: cryptoAccount,
    );
  }

  WalletState copyWith({
    WalletStatus? status,
    MessageHandler? messageHandler,
    CryptoAccount? cryptoAccount,
    int? currentCryptoIndex,
  }) {
    return WalletState(
      status: status ?? this.status,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
      currentCryptoIndex: currentCryptoIndex ?? this.currentCryptoIndex,
      cryptoAccount: cryptoAccount ?? this.cryptoAccount,
    );
  }

  Map<String, dynamic> toJson() => _$WalletStateToJson(this);

  @override
  List<Object?> get props => [
    status,
    message,
    currentCryptoIndex,
    cryptoAccount,
  ];
}
