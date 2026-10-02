part of 'nft_cubit.dart';

@JsonSerializable()
class NftState extends Equatable {
  const NftState({
    this.status = AppStatus.init,
    this.message,
    this.offset = 0,
    this.data = const [],
    this.blockchainType = BlockchainType.tezos,
  });

  factory NftState.fromJson(Map<String, dynamic> json) =>
      _$NftStateFromJson(json);

  final AppStatus status;
  final StateMessage? message;
  final List<NftModel> data;
  final int offset;
  final BlockchainType blockchainType;

  NftState fetching() {
    final state = NftState(
      status: AppStatus.fetching,
      data: data,
      offset: offset,
    );
    return state;
  }

  NftState loading() {
    final state = NftState(
      status: AppStatus.loading,
      data: data,
      offset: offset,
    );
    return state;
  }

  NftState error({required MessageHandler messageHandler}) {
    final state = NftState(
      status: AppStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
      data: data,
      offset: offset,
    );
    return state;
  }

  NftState populate({List<NftModel>? data}) {
    final state = NftState(
      status: AppStatus.populate,
      data: data ?? this.data,
      offset: offset,
      message: null,
    );
    return state;
  }

  NftState reset({required BlockchainType blockchainType}) {
    final state = NftState(
      status: AppStatus.init,
      message: null,
      data: const [],
      offset: 0,
      blockchainType: blockchainType,
    );
    return state;
  }

  NftState copyWith({
    AppStatus? status,
    MessageHandler? messageHandler,
    List<NftModel>? data,
    int? offset,
    StateMessage? message,
    BlockchainType? blockchainType,
  }) {
    final state = NftState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message,
      offset: offset ?? this.offset,
      blockchainType: blockchainType ?? this.blockchainType,
    );
    return state;
  }

  Map<String, dynamic> toJson() => _$NftStateToJson(this);

  @override
  List<Object?> get props => [status, message, data, offset, blockchainType];
}
