part of 'rights_cubit.dart';

@JsonSerializable()
class RightsState extends Equatable {
  const RightsState({this.status = AppStatus.init, this.message});

  factory RightsState.fromJson(Map<String, dynamic> json) =>
      _$RightsStateFromJson(json);

  final AppStatus status;
  final StateMessage? message;

  RightsState loading() {
    const loadingState = RightsState(status: AppStatus.loading);
    return loadingState;
  }

  RightsState error({required MessageHandler messageHandler}) {
    final errorState = RightsState(
      status: AppStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
    );
    return errorState;
  }

  RightsState copyWith({
    AppStatus appStatus = AppStatus.idle,
    MessageHandler? messageHandler,
    int? selectedIndex,
  }) {
    final rightsState = RightsState(
      status: appStatus,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
    );
    return rightsState;
  }

  Map<String, dynamic> toJson() => _$RightsStateToJson(this);

  @override
  List<Object?> get props => [status, message];
}
