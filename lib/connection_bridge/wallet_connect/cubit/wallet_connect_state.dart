part of 'wallet_connect_cubit.dart';

@JsonSerializable()
class WalletConnectState extends Equatable {
  WalletConnectState({
    this.status = WalletConnectStatus.init,
    this.isWalletConnectStarted = false,
    this.message,
    this.sessionId,
    List<WCClient>? wcClients,
    this.currentDAppPeerMeta,
    this.signId,
    this.signMessage,
  }) : wcClients = wcClients ?? [];

  factory WalletConnectState.fromJson(Map<String, dynamic> json) =>
      _$WalletConnectStateFromJson(json);

  final WalletConnectStatus? status;
  final StateMessage? message;
  final bool isWalletConnectStarted;
  final int? sessionId;
  final WCPeerMeta? currentDAppPeerMeta;
  @JsonKey(ignore: true)
  final List<WCClient> wcClients;
  final int? signId;
  @JsonKey(ignore: true)
  final WCEthereumSignMessage? signMessage;

  Map<String, dynamic> toJson() => _$WalletConnectStateToJson(this);

  WalletConnectState loading() {
    return WalletConnectState(
      status: WalletConnectStatus.loading,
      isWalletConnectStarted: isWalletConnectStarted,
      sessionId: sessionId,
      wcClients: wcClients,
      currentDAppPeerMeta: currentDAppPeerMeta,
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
      currentDAppPeerMeta: currentDAppPeerMeta,
      sessionId: sessionId,
      wcClients: wcClients,
      signId: signId,
      signMessage: signMessage,
    );
  }

  WalletConnectState copyWith({
    WalletConnectStatus status = WalletConnectStatus.idle,
    MessageHandler? messageHandler,
    bool? isWalletConnectStarted,
    int? sessionId,
    WCPeerMeta? currentDAppPeerMeta,
    List<WCClient>? wcClients,
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
      currentDAppPeerMeta: currentDAppPeerMeta ?? this.currentDAppPeerMeta,
      sessionId: sessionId ?? this.sessionId,
      wcClients: wcClients ?? this.wcClients,
      signId: signId ?? this.signId,
      signMessage: signMessage ?? this.signMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        message,
        isWalletConnectStarted,
        sessionId,
        currentDAppPeerMeta,
        wcClients,
        signId,
        signMessage,
      ];
}
