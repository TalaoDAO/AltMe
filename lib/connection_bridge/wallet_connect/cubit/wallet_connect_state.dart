part of 'wallet_connect_cubit.dart';

@JsonSerializable()
class WalletConnectState extends Equatable {
  const WalletConnectState({
    this.status = WalletConnectStatus.init,
    this.isWalletConnectStarted = false,
    this.message,
    this.sessionId,
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
      sessionId: sessionId ?? this.sessionId,
      wcClient: wcClient ?? this.wcClient,
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
        wcClient,
        signId,
        signMessage,
      ];
}
