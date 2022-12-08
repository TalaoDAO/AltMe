part of 'rights_cubit.dart';

@JsonSerializable()
class RightsState extends Equatable {
  const RightsState({
    this.status = AppStatus.init,
    this.message,
  });

  factory RightsState.fromJson(Map<String, dynamic> json) =>
      _$RightsStateFromJson(json);

  final AppStatus status;
  final StateMessage? message;

  RightsState loading() {
    return const RightsState(status: AppStatus.loading);
  }

  RightsState error({
    required MessageHandler messageHandler,
  }) {
    return RightsState(
      status: AppStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
    );
  }

  RightsState copyWith({
    AppStatus appStatus = AppStatus.idle,
    MessageHandler? messageHandler,
    int? selectedIndex,
  }) {
    return RightsState(
      status: appStatus,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
    );
  }

  Map<String, dynamic> toJson() => _$RightsStateToJson(this);

  @override
  List<Object?> get props => [status, message];
}
