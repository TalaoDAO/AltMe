part of 'tokens_cubit.dart';

@JsonSerializable()
class TokensState extends Equatable {
  const TokensState({
    this.status = AppStatus.init,
    this.message,
    this.data = const [],
    this.isSecure = false,
    this.totalBalanceInUSD = 0.0,
  });

  factory TokensState.fromJson(Map<String, dynamic> json) =>
      _$TokensStateFromJson(json);

  final AppStatus status;
  final StateMessage? message;
  final List<TokenModel> data;
  final bool isSecure;
  final double totalBalanceInUSD;

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

  TokensState copyWith({
    AppStatus? status,
    StateMessage? message,
    List<TokenModel>? data,
    bool? isSecure,
    double? totalBalanceInUSD,
  }) {
    return TokensState(
      status: status ?? this.status,
      message: message ?? this.message,
      data: data ?? this.data,
      isSecure: isSecure ?? this.isSecure,
      totalBalanceInUSD: totalBalanceInUSD ?? this.totalBalanceInUSD,
    );
  }

  Map<String, dynamic> toJson() => _$TokensStateToJson(this);

  @override
  List<Object?> get props => [status, message, data, isSecure];
}
