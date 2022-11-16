part of 'blockchain_cubit.dart';

@JsonSerializable()
class BlockchainState extends Equatable {
  const BlockchainState({
    this.blockchainType = BlockchainType.tezos,
    this.status = AppStatus.init,
    this.message,
  });

  factory BlockchainState.fromJson(Map<String, dynamic> json) =>
      _$BlockchainStateFromJson(json);

  final BlockchainType? blockchainType;
  final AppStatus? status;
  final StateMessage? message;

  Map<String, dynamic> toJson() => _$BlockchainStateToJson(this);

  BlockchainState loading() {
    return BlockchainState(
      status: AppStatus.loading,
      blockchainType: blockchainType,
    );
  }

  BlockchainState copyWith({
    required AppStatus status,
    BlockchainType? blockchainType,
    MessageHandler? messageHandler,
  }) {
    return BlockchainState(
      blockchainType: blockchainType ?? this.blockchainType,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
      status: status,
    );
  }

  @override
  List<Object?> get props => [status, message, blockchainType];
}
