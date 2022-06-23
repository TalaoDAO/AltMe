part of 'wallet_cubit.dart';

@JsonSerializable()
class WalletState extends Equatable {
  WalletState({
    this.status = WalletStatus.init,
    this.message,
    this.currentIndex,
    List<CredentialModel>? credentials,
    List<WalletAccount>? walletAccounts,
  })  : credentials = credentials ?? [],
        walletAccounts = walletAccounts ?? [];

  factory WalletState.fromJson(Map<String, dynamic> json) =>
      _$WalletStateFromJson(json);

  final WalletStatus status;
  final List<CredentialModel> credentials;
  final StateMessage? message;
  final int? currentIndex;
  final List<WalletAccount> walletAccounts;

  WalletState loading() {
    return WalletState(
      status: WalletStatus.loading,
      credentials: credentials,
      currentIndex: currentIndex,
      walletAccounts: walletAccounts,
    );
  }

  WalletState error({required MessageHandler messageHandler}) {
    return WalletState(
      status: WalletStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
      credentials: credentials,
      currentIndex: currentIndex,
      walletAccounts: walletAccounts,
    );
  }

  WalletState copyWith({
    required WalletStatus status,
    MessageHandler? messageHandler,
    List<CredentialModel>? credentials,
    List<WalletAccount>? walletAccounts,
    int? currentIndex,
  }) {
    return WalletState(
      status: status,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
      credentials: credentials ?? this.credentials,
      currentIndex: currentIndex ?? this.currentIndex,
      walletAccounts: walletAccounts ?? this.walletAccounts,
    );
  }

  Map<String, dynamic> toJson() => _$WalletStateToJson(this);

  @override
  List<Object?> get props => [
        status,
        message,
        credentials,
        currentIndex,
        walletAccounts,
      ];
}
