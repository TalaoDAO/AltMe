part of 'beacon_connected_dapps_cubit.dart';

@JsonSerializable()
class BeaconConnectedDappsState extends Equatable {
  BeaconConnectedDappsState({
    this.status = AppStatus.init,
    this.message,
    this.xtzModel,
    List<P2PPeer>? peers,
  }) : peers = peers ?? [];

  factory BeaconConnectedDappsState.fromJson(Map<String, dynamic> json) =>
      _$BeaconConnectedDappsStateFromJson(json);

  final AppStatus status;
  final StateMessage? message;
  final TokenModel? xtzModel;
  final List<P2PPeer> peers;

  BeaconConnectedDappsState loading() {
    return copyWith(status: AppStatus.loading);
  }

  BeaconConnectedDappsState error({
    required MessageHandler messageHandler,
  }) {
    return copyWith(status: AppStatus.error);
  }

  BeaconConnectedDappsState copyWith({
    AppStatus? status,
    MessageHandler? messageHandler,
    TokenModel? xtzModel,
    List<P2PPeer>? peers,
  }) {
    return BeaconConnectedDappsState(
      status: status ?? this.status,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
      xtzModel: xtzModel ?? this.xtzModel,
      peers: peers ?? this.peers,
    );
  }

  Map<String, dynamic> toJson() => _$BeaconConnectedDappsStateToJson(this);

  @override
  List<Object?> get props => [status, message, peers, xtzModel];
}
