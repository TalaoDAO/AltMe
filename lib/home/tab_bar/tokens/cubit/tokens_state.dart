part of 'tokens_cubit.dart';

@JsonSerializable()
class TokensState extends Equatable {
  const TokensState({
    this.status = AppStatus.init,
    this.message,
    this.data = const [],
  });

  factory TokensState.fromJson(Map<String, dynamic> json) =>
      _$TokensStateFromJson(json);

  final AppStatus status;
  final StateMessage? message;
  final List<TokenModel> data;

  TokensState fetching() {
    return TokensState(status: AppStatus.fetching, data: data);
  }

  TokensState errorWhileFetching({
    required MessageHandler messageHandler,
  }) {
    return TokensState(
      status: AppStatus.errorWhileFetching,
      message: StateMessage.error(messageHandler: messageHandler),
      data: data,
    );
  }

  TokensState loading() {
    return TokensState(status: AppStatus.loading, data: data);
  }

  TokensState error({
    required MessageHandler messageHandler,
  }) {
    return TokensState(
      status: AppStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
      data: data,
    );
  }

  TokensState populate({
    List<TokenModel>? data,
  }) {
    return TokensState(
      status: AppStatus.populate,
      data: data ?? this.data,
    );
  }

  TokensState success({
    MessageHandler? messageHandler,
    List<TokenModel>? data,
  }) {
    return TokensState(
      status: AppStatus.success,
      data: data ?? this.data,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
    );
  }

  Map<String, dynamic> toJson() => _$TokensStateToJson(this);

  @override
  List<Object?> get props => [status, message, data];
}
