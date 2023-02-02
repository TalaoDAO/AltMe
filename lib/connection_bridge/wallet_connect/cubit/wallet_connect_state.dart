part of 'wallet_connect_cubit.dart';

@JsonSerializable()
class WalletConnectState extends Equatable {
  WalletConnectState({
    this.status = WalletConnectStatus.init,
    this.isWalletConnectStarted = false,
    this.message,
    this.sessionId,
    List<WCClient>? wcClients,
    this.currentDappPeerId,
    this.currentDAppPeerMeta,
    this.signId,
    this.signMessage,
    this.transactionId,
    this.transaction,
  }) : wcClients = wcClients ?? [];

  factory WalletConnectState.fromJson(Map<String, dynamic> json) =>
      _$WalletConnectStateFromJson(json);

  final WalletConnectStatus? status;
  final StateMessage? message;
  final bool isWalletConnectStarted;
  final int? sessionId;
  final String? currentDappPeerId;
  final WCPeerMeta? currentDAppPeerMeta;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final List<WCClient> wcClients;
  final int? signId;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final WCEthereumSignMessage? signMessage;
  final int? transactionId;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final WCEthereumTransaction? transaction;

  Map<String, dynamic> toJson() => _$WalletConnectStateToJson(this);

  WalletConnectState loading() {
    return WalletConnectState(
      status: WalletConnectStatus.loading,
      isWalletConnectStarted: isWalletConnectStarted,
      sessionId: sessionId,
      wcClients: wcClients,
      currentDappPeerId: currentDappPeerId,
      currentDAppPeerMeta: currentDAppPeerMeta,
      signId: signId,
      signMessage: signMessage,
      transactionId: transactionId,
      transaction: transaction,
    );
  }

  WalletConnectState error({
    required MessageHandler messageHandler,
  }) {
    return WalletConnectState(
      status: WalletConnectStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
      isWalletConnectStarted: isWalletConnectStarted,
      currentDappPeerId: currentDappPeerId,
      currentDAppPeerMeta: currentDAppPeerMeta,
      sessionId: sessionId,
      wcClients: wcClients,
      signId: signId,
      signMessage: signMessage,
      transactionId: transactionId,
      transaction: transaction,
    );
  }

  WalletConnectState copyWith({
    WalletConnectStatus status = WalletConnectStatus.idle,
    MessageHandler? messageHandler,
    bool? isWalletConnectStarted,
    int? sessionId,
    String? currentDappPeerId,
    WCPeerMeta? currentDAppPeerMeta,
    List<WCClient>? wcClients,
    int? signId,
    WCEthereumSignMessage? signMessage,
    int? transactionId,
    WCEthereumTransaction? transaction,
  }) {
    return WalletConnectState(
      status: status,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
      isWalletConnectStarted:
          isWalletConnectStarted ?? this.isWalletConnectStarted,
      currentDAppPeerMeta: currentDAppPeerMeta ?? this.currentDAppPeerMeta,
      currentDappPeerId: currentDappPeerId ?? this.currentDappPeerId,
      sessionId: sessionId ?? this.sessionId,
      wcClients: wcClients ?? this.wcClients,
      signId: signId ?? this.signId,
      signMessage: signMessage ?? this.signMessage,
      transactionId: transactionId ?? this.transactionId,
      transaction: transaction ?? this.transaction,
    );
  }

  @override
  List<Object?> get props => [
        status,
        message,
        isWalletConnectStarted,
        sessionId,
        currentDappPeerId,
        currentDAppPeerMeta,
        wcClients,
        signId,
        signMessage,
        transactionId,
        transaction,
      ];
}
