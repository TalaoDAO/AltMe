part of 'wallet_connect_cubit.dart';

@JsonSerializable()
class WalletConnectState extends Equatable {
  const WalletConnectState({
    this.status = WalletConnectStatus.init,
    this.isWalletConnectStarted = false,
    this.message,
    this.sessionId,
    this.walletPeerMeta,
    this.dAppPeerMeta,
    this.wcClient,
    this.signId,
    this.signMessage,
  });

  factory WalletConnectState.fromJson(Map<String, dynamic> json) =>
      _$WalletConnectStateFromJson(json);

  final WalletConnectStatus? status;
  final StateMessage? message;
  final bool isWalletConnectStarted;
  final int? sessionId;
  @JsonKey(ignore: true)
  final WCPeerMeta? walletPeerMeta;
  @JsonKey(ignore: true)
  final WCPeerMeta? dAppPeerMeta;
  @JsonKey(ignore: true)
  final WCClient? wcClient;
  final int? signId;
  @JsonKey(ignore: true)
  final WCEthereumSignMessage? signMessage;

  Map<String, dynamic> toJson() => _$WalletConnectStateToJson(this);

  WalletConnectState loading() {
    return WalletConnectState(
      status: WalletConnectStatus.loading,
      isWalletConnectStarted: isWalletConnectStarted,
      sessionId: sessionId,
      walletPeerMeta: walletPeerMeta,
      dAppPeerMeta: dAppPeerMeta,
      wcClient: wcClient,
      signId: signId,
      signMessage: signMessage,
    );
  }

  WalletConnectState error({
    required MessageHandler messageHandler,
  }) {
    return WalletConnectState(
      status: WalletConnectStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
      isWalletConnectStarted: isWalletConnectStarted,
      sessionId: sessionId,
      walletPeerMeta: walletPeerMeta,
      dAppPeerMeta: dAppPeerMeta,
      wcClient: wcClient,
      signId: signId,
      signMessage: signMessage,
    );
  }

  WalletConnectState copyWith({
    WalletConnectStatus status = WalletConnectStatus.idle,
    MessageHandler? messageHandler,
    bool? isWalletConnectStarted,
    int? sessionId,
    WCPeerMeta? walletPeerMeta,
    WCPeerMeta? dAppPeerMeta,
    WCClient? wcClient,
    int? signId,
    WCEthereumSignMessage? signMessage,
  }) {
    return WalletConnectState(
      status: status,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
      isWalletConnectStarted:
          isWalletConnectStarted ?? this.isWalletConnectStarted,
      walletPeerMeta: walletPeerMeta ?? this.walletPeerMeta,
      dAppPeerMeta: dAppPeerMeta ?? this.dAppPeerMeta,
      sessionId: sessionId ?? this.sessionId,
      wcClient: wcClient ?? this.wcClient,
      signId: signId,
      signMessage: signMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        message,
        isWalletConnectStarted,
        sessionId,
        walletPeerMeta,
        dAppPeerMeta,
        wcClient,
        signId,
        signMessage,
      ];
}
