part of 'wallet_cubit.dart';

@JsonSerializable()
class WalletState extends Equatable {
  WalletState({
    this.status = WalletStatus.init,
    this.message,
    this.currentCryptoIndex,
    List<CredentialModel>? credentials,
    List<CryptoAccount>? cryptoAccounts,
  })  : credentials = credentials ?? [],
        cryptoAccounts = cryptoAccounts ?? [];

  factory WalletState.fromJson(Map<String, dynamic> json) =>
      _$WalletStateFromJson(json);

  final WalletStatus status;
  final List<CredentialModel> credentials;
  final StateMessage? message;
  final int? currentCryptoIndex;
  final List<CryptoAccount> cryptoAccounts;

  WalletState loading() {
    return WalletState(
      status: WalletStatus.loading,
      credentials: credentials,
      currentCryptoIndex: currentCryptoIndex,
      cryptoAccounts: cryptoAccounts,
    );
  }

  WalletState error({required MessageHandler messageHandler}) {
    return WalletState(
      status: WalletStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
      credentials: credentials,
      currentCryptoIndex: currentCryptoIndex,
      cryptoAccounts: cryptoAccounts,
    );
  }

  WalletState copyWith({
    required WalletStatus status,
    MessageHandler? messageHandler,
    List<CredentialModel>? credentials,
    List<CryptoAccount>? cryptoAccounts,
    int? currentCryptoIndex,
  }) {
    return WalletState(
      status: status,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
      credentials: credentials ?? this.credentials,
      currentCryptoIndex: currentCryptoIndex ?? this.currentCryptoIndex,
      cryptoAccounts: cryptoAccounts ?? this.cryptoAccounts,
    );
  }

  Map<String, dynamic> toJson() => _$WalletStateToJson(this);

  @override
  List<Object?> get props => [
        status,
        message,
        credentials,
        currentCryptoIndex,
        cryptoAccounts,
      ];
}
