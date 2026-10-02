part of 'wallet_connect_cubit.dart';

@JsonSerializable()
class WalletConnectState extends Equatable {
  const WalletConnectState({
    this.status = WalletConnectStatus.init,
    this.message,
    this.sessionTopic,
    this.sessionProposalEvent,
    this.parameters,
    this.signType,
    this.transaction,
    this.operationDetails,
  });

  factory WalletConnectState.fromJson(Map<String, dynamic> json) =>
      _$WalletConnectStateFromJson(json);

  final WalletConnectStatus? status;
  final StateMessage? message;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final SessionProposalEvent? sessionProposalEvent;
  final String? sessionTopic;
  final dynamic parameters;
  final String? signType;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final Transaction? transaction;
  final List<OperationDetails>? operationDetails;

  Map<String, dynamic> toJson() => _$WalletConnectStateToJson(this);

  WalletConnectState loading() {
    final walletConnectState = copyWith(status: WalletConnectStatus.loading);
    return walletConnectState;
  }

  WalletConnectState error({required MessageHandler messageHandler}) {
    final walletConnectState = copyWith(
      status: WalletConnectStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
    );
    return walletConnectState;
  }

  WalletConnectState copyWith({
    WalletConnectStatus status = WalletConnectStatus.idle,
    StateMessage? message,
    SessionProposalEvent? sessionProposalEvent,
    String? sessionTopic,
    dynamic parameters,
    String? signType,
    Transaction? transaction,
    List<OperationDetails>? operationDetails,
  }) {
    final walletConnectState = WalletConnectState(
      status: status,
      message: message,
      sessionProposalEvent: sessionProposalEvent ?? this.sessionProposalEvent,
      sessionTopic: sessionTopic ?? this.sessionTopic,
      parameters: parameters ?? this.parameters,
      signType: signType ?? this.signType,
      transaction: transaction ?? this.transaction,
      operationDetails: operationDetails ?? this.operationDetails,
    );
    return walletConnectState;
  }

  @override
  List<Object?> get props => [
    status,
    message,
    sessionProposalEvent,
    parameters,
    signType,
    transaction,
    operationDetails,
  ];
}
