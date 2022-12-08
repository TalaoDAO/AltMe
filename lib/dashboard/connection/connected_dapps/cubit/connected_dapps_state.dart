part of 'connected_dapps_cubit.dart';

@JsonSerializable()
class ConnectedDappsState extends Equatable {
  ConnectedDappsState({
    this.status = AppStatus.init,
    this.message,
    this.xtzModel,
    List<SavedDappData>? savedDapps,
  }) : savedDapps = savedDapps ?? [];

  factory ConnectedDappsState.fromJson(Map<String, dynamic> json) =>
      _$ConnectedDappsStateFromJson(json);

  final AppStatus status;
  final StateMessage? message;
  final TokenModel? xtzModel;
  final List<SavedDappData> savedDapps;

  ConnectedDappsState loading() {
    return copyWith(status: AppStatus.loading);
  }

  ConnectedDappsState error({
    required MessageHandler messageHandler,
  }) {
    return copyWith(status: AppStatus.error);
  }

  ConnectedDappsState copyWith({
    AppStatus? status,
    MessageHandler? messageHandler,
    TokenModel? xtzModel,
    List<SavedDappData>? savedDapps,
  }) {
    return ConnectedDappsState(
      status: status ?? this.status,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
      xtzModel: xtzModel ?? this.xtzModel,
      savedDapps: savedDapps ?? this.savedDapps,
    );
  }

  Map<String, dynamic> toJson() => _$ConnectedDappsStateToJson(this);

  @override
  List<Object?> get props => [status, message, savedDapps, xtzModel];
}
