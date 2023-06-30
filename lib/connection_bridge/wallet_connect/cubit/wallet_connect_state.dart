part of 'wallet_connect_cubit.dart';

@JsonSerializable()
class WalletConnectState extends Equatable {
  WalletConnectState({
    this.status = WalletConnectStatus.init,
    this.message,

    /// v1
    this.isWalletConnectStarted = false,
    this.sessionId,
    List<WCClient>? wcClients,
    this.currentDappPeerId,
    this.currentDAppPeerMeta,
    this.signId,
    this.signMessage,
    this.transactionId,
    this.wcTransaction,

    /// v2
    this.sessionProposalEvent,
    this.parameters,
    this.signType,
    this.transaction,
  }) : wcClients = wcClients ?? [];

  factory WalletConnectState.fromJson(Map<String, dynamic> json) =>
      _$WalletConnectStateFromJson(json);

  final WalletConnectStatus? status;
  final StateMessage? message;

  /// v1
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
  final WCEthereumTransaction? wcTransaction;

  /// v2
  @JsonKey(includeFromJson: false, includeToJson: false)
  final SessionProposalEvent? sessionProposalEvent;
  final dynamic parameters;
  final String? signType;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final Transaction? transaction;

  Map<String, dynamic> toJson() => _$WalletConnectStateToJson(this);

  WalletConnectState loading() {
    return copyWith(status: WalletConnectStatus.loading);
  }

  WalletConnectState error({required MessageHandler messageHandler}) {
    return copyWith(
      status: WalletConnectStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
    );
  }

  WalletConnectState copyWith({
    WalletConnectStatus status = WalletConnectStatus.idle,
    StateMessage? message,
    bool? isWalletConnectStarted,
    int? sessionId,
    String? currentDappPeerId,
    WCPeerMeta? currentDAppPeerMeta,
    List<WCClient>? wcClients,
    int? signId,
    WCEthereumSignMessage? signMessage,
    int? transactionId,
    WCEthereumTransaction? wcTransaction,
    SessionProposalEvent? sessionProposalEvent,
    dynamic parameters,
    String? signType,
    Transaction? transaction,
  }) {
    return WalletConnectState(
      status: status,
      message: message,
      isWalletConnectStarted:
          isWalletConnectStarted ?? this.isWalletConnectStarted,
      currentDAppPeerMeta: currentDAppPeerMeta ?? this.currentDAppPeerMeta,
      currentDappPeerId: currentDappPeerId ?? this.currentDappPeerId,
      sessionId: sessionId ?? this.sessionId,
      wcClients: wcClients ?? this.wcClients,
      signId: signId ?? this.signId,
      signMessage: signMessage ?? this.signMessage,
      transactionId: transactionId ?? this.transactionId,
      wcTransaction: wcTransaction ?? this.wcTransaction,
      sessionProposalEvent: sessionProposalEvent ?? this.sessionProposalEvent,
      parameters: parameters ?? this.parameters,
      signType: signType ?? this.signType,
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
        wcTransaction,
        sessionProposalEvent,
        parameters,
        signType,
        transaction,
      ];
}
