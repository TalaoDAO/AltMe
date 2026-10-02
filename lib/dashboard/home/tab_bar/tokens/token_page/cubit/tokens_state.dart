part of 'tokens_cubit.dart';

@JsonSerializable()
class TokensState extends Equatable {
  const TokensState({
    this.status = AppStatus.init,
    this.message,
    this.data = const {},
    this.isSecure = false,
    this.totalBalanceInUSD = 0.0,
    this.offset = 0,
    this.blockchainType = BlockchainType.tezos,
  });

  factory TokensState.fromJson(Map<String, dynamic> json) =>
      _$TokensStateFromJson(json);

  final AppStatus status;
  final StateMessage? message;
  final Set<TokenModel> data;
  final bool isSecure;
  final double totalBalanceInUSD;
  final int offset;
  final BlockchainType blockchainType;

  TokensState fetching() {
    final state = copyWith(status: AppStatus.fetching);
    return state;
  }

  TokensState errorWhileFetching({required MessageHandler messageHandler}) {
    final state = copyWith(
      status: AppStatus.errorWhileFetching,
      message: StateMessage.error(messageHandler: messageHandler),
    );
    return state;
  }

  TokensState loading() {
    final state = copyWith(status: AppStatus.loading);
    return state;
  }

  TokensState error({required MessageHandler messageHandler}) {
    final state = copyWith(
      status: AppStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
    );
    return state;
  }

  TokensState populate({Set<TokenModel>? data}) {
    final state = copyWith(status: AppStatus.populate, data: data);
    return state;
  }

  TokensState success({MessageHandler? messageHandler, Set<TokenModel>? data}) {
    final state = copyWith(
      status: AppStatus.success,
      data: data,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
    );
    return state;
  }

  TokensState reset({required BlockchainType blockchainType}) {
    final state = TokensState(
      status: AppStatus.init,
      message: null,
      data: const {},
      isSecure: false,
      totalBalanceInUSD: 0,
      offset: 0,
      blockchainType: blockchainType,
    );
    return state;
  }

  TokensState copyWith({
    AppStatus? status,
    StateMessage? message,
    Set<TokenModel>? data,
    bool? isSecure,
    double? totalBalanceInUSD,
    int? offset,
    BlockchainType? blockchainType,
  }) {
    final state = TokensState(
      status: status ?? this.status,
      message: message,
      data: data ?? this.data,
      isSecure: isSecure ?? this.isSecure,
      totalBalanceInUSD: totalBalanceInUSD ?? this.totalBalanceInUSD,
      offset: offset ?? this.offset,
      blockchainType: blockchainType ?? this.blockchainType,
    );
    return state;
  }

  Map<String, dynamic> toJson() => _$TokensStateToJson(this);

  @override
  List<Object?> get props => [
    status,
    message,
    data,
    isSecure,
    totalBalanceInUSD,
    offset,
    blockchainType,
  ];
}
