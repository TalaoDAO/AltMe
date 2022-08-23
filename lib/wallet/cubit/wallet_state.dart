part of 'wallet_cubit.dart';

@JsonSerializable()
class WalletState extends Equatable {
  WalletState({
    this.status = WalletStatus.init,
    this.message,
    this.currentCryptoIndex = 0,
    CryptoAccount? cryptoAccount,
    List<CredentialModel>? credentials,
  })  : credentials = credentials ?? [],
        cryptoAccount = cryptoAccount ?? CryptoAccount(data: const []);

  factory WalletState.fromJson(Map<String, dynamic> json) =>
      _$WalletStateFromJson(json);

  final WalletStatus status;
  final List<CredentialModel> credentials;
  final StateMessage? message;
  final int currentCryptoIndex;
  final CryptoAccount cryptoAccount;

  CryptoAccountData get currentAccount {
    return cryptoAccount.data[currentCryptoIndex];
  }

  WalletState loading() {
    return WalletState(
      status: WalletStatus.loading,
      credentials: credentials,
      currentCryptoIndex: currentCryptoIndex,
      cryptoAccount: cryptoAccount,
    );
  }

  WalletState error({required MessageHandler messageHandler}) {
    return WalletState(
      status: WalletStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
      credentials: credentials,
      currentCryptoIndex: currentCryptoIndex,
      cryptoAccount: cryptoAccount,
    );
  }

  WalletState copyWith({
    required WalletStatus status,
    MessageHandler? messageHandler,
    List<CredentialModel>? credentials,
    CryptoAccount? cryptoAccount,
    int? currentCryptoIndex,
  }) {
    return WalletState(
      status: status,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
      credentials: credentials ?? this.credentials,
      currentCryptoIndex: currentCryptoIndex ?? this.currentCryptoIndex,
      cryptoAccount: cryptoAccount ?? this.cryptoAccount,
    );
  }

  Map<String, dynamic> toJson() => _$WalletStateToJson(this);

  @override
  List<Object?> get props => [
        status,
        message,
        credentials,
        currentCryptoIndex,
        cryptoAccount,
      ];
}
