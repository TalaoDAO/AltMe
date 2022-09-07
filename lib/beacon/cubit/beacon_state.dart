part of 'beacon_cubit.dart';

@JsonSerializable()
class BeaconState extends Equatable {
  const BeaconState({
    this.status = BeaconStatus.init,
    this.message,
  });

  factory BeaconState.fromJson(Map<String, dynamic> json) =>
      _$BeaconStateFromJson(json);

  final BeaconStatus? status;
  final StateMessage? message;

  Map<String, dynamic> toJson() => _$BeaconStateToJson(this);

  BeaconState loading() {
    return const BeaconState(status: BeaconStatus.loading);
  }

  BeaconState error({
    required MessageHandler messageHandler,
  }) {
    return BeaconState(
      status: BeaconStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
    );
  }

  BeaconState copyWith({
    BeaconStatus status = BeaconStatus.idle,
    MessageHandler? messageHandler,
  }) {
    return BeaconState(
      status: status,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
    );
  }

  @override
  List<Object?> get props => [status, message];
}
