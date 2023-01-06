part of 'tokens_cubit.dart';

@JsonSerializable()
class TokensState extends Equatable {
  const TokensState({
    this.status = AppStatus.init,
    this.message,
    this.data = const [],
    this.isSecure = false,
    this.totalBalanceInUSD = 0.0,
    this.offset = 0,
    this.blockchainType = BlockchainType.tezos,
  });

  factory TokensState.fromJson(Map<String, dynamic> json) =>
      _$TokensStateFromJson(json);

  final AppStatus status;
  final StateMessage? message;
  final List<TokenModel> data;
  final bool isSecure;
  final double totalBalanceInUSD;
  final int offset;
  final BlockchainType blockchainType;

  TokensState fetching() {
    return copyWith(
      status: AppStatus.fetching,
    );
  }

  TokensState errorWhileFetching({
    required MessageHandler messageHandler,
  }) {
    return copyWith(
      status: AppStatus.errorWhileFetching,
      message: StateMessage.error(messageHandler: messageHandler),
    );
  }

  TokensState loading() {
    return copyWith(
      status: AppStatus.loading,
    );
  }

  TokensState error({
    required MessageHandler messageHandler,
  }) {
    return copyWith(
      status: AppStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
    );
  }

  TokensState populate({
    List<TokenModel>? data,
  }) {
    return copyWith(
      status: AppStatus.populate,
      data: data,
    );
  }

  TokensState success({
    MessageHandler? messageHandler,
    List<TokenModel>? data,
  }) {
    return copyWith(
      status: AppStatus.success,
      data: data,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
    );
  }

  TokensState reset({required BlockchainType blockchainType}) {
    return TokensState(
      status: AppStatus.init,
      message: null,
      data: const [],
      isSecure: false,
      totalBalanceInUSD: 0,
      offset: 0,
      blockchainType: blockchainType,
    );
  }

  TokensState copyWith({
    AppStatus? status,
    StateMessage? message,
    List<TokenModel>? data,
    bool? isSecure,
    double? totalBalanceInUSD,
    int? offset,
    BlockchainType? blockchainType,
  }) {
    return TokensState(
      status: status ?? this.status,
      message: message,
      data: data ?? this.data,
      isSecure: isSecure ?? this.isSecure,
      totalBalanceInUSD: totalBalanceInUSD ?? this.totalBalanceInUSD,
      offset: offset ?? this.offset,
      blockchainType: blockchainType ?? this.blockchainType,
    );
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
