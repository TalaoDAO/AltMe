part of 'beacon_cubit.dart';

@JsonSerializable()
class BeaconState extends Equatable {
  const BeaconState({
    this.status = BeaconStatus.init,
    this.isBeaconStarted = false,
    this.beaconRequest,
    this.message,
    this.lastBeaconRequestTime,
  });

  factory BeaconState.fromJson(Map<String, dynamic> json) =>
      _$BeaconStateFromJson(json);

  final BeaconStatus? status;
  final StateMessage? message;
  final BeaconRequest? beaconRequest;
  final bool isBeaconStarted;
  final DateTime? lastBeaconRequestTime;

  Map<String, dynamic> toJson() => _$BeaconStateToJson(this);

  BeaconState loading() {
    return BeaconState(
      status: BeaconStatus.loading,
      beaconRequest: beaconRequest,
      isBeaconStarted: isBeaconStarted,
    );
  }

  BeaconState error({
    required MessageHandler messageHandler,
  }) {
    return BeaconState(
      status: BeaconStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
      beaconRequest: beaconRequest,
      isBeaconStarted: isBeaconStarted,
    );
  }

  BeaconState copyWith({
    BeaconStatus status = BeaconStatus.idle,
    MessageHandler? messageHandler,
    BeaconRequest? beaconRequest,
    bool? isBeaconStarted,
    DateTime? lastBeaconRequestTime,
  }) {
    return BeaconState(
      status: status,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
      beaconRequest: beaconRequest ?? this.beaconRequest,
      isBeaconStarted: isBeaconStarted ?? this.isBeaconStarted,
      lastBeaconRequestTime:
          lastBeaconRequestTime ?? this.lastBeaconRequestTime,
    );
  }

  @override
  List<Object?> get props =>
      [status, message, beaconRequest, isBeaconStarted, lastBeaconRequestTime];
}
