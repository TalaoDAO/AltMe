part of 'nft_cubit.dart';

@JsonSerializable()
class NftState extends Equatable {
  const NftState({
    this.status = AppStatus.init,
    this.message,
    this.data = const [],
  });

  factory NftState.fromJson(Map<String, dynamic> json) =>
      _$NftStateFromJson(json);

  final AppStatus status;
  final StateMessage? message;
  final List<NftModel> data;

  NftState loading() {
    return NftState(
      status: AppStatus.loading,
      data: data,
    );
  }

  NftState error({
    required MessageHandler messageHandler,
  }) {
    return NftState(
      status: AppStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
      data: data,
    );
  }

  NftState success({MessageHandler? messageHandler, List<NftModel>? data}) {
    return NftState(
      status: AppStatus.success,
      data: data ?? this.data,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
    );
  }

  Map<String, dynamic> toJson() => _$NftStateToJson(this);

  @override
  List<Object?> get props => [status, message, data];
}
