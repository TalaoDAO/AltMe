part of 'dashboard_cubit.dart';

@JsonSerializable()
class DashboardState extends Equatable {
  const DashboardState({
    this.status = AppStatus.init,
    this.message,
    this.selectedIndex = 0,
  });

  factory DashboardState.fromJson(Map<String, dynamic> json) =>
      _$DashboardStateFromJson(json);

  final AppStatus status;
  final int selectedIndex;
  final StateMessage? message;

  DashboardState loading() {
    return DashboardState(
      status: AppStatus.loading,
      selectedIndex: selectedIndex,
    );
  }

  DashboardState error({
    required MessageHandler messageHandler,
  }) {
    return DashboardState(
      status: AppStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
      selectedIndex: selectedIndex,
    );
  }

  DashboardState copyWith({
    AppStatus appStatus = AppStatus.idle,
    MessageHandler? messageHandler,
    int? selectedIndex,
  }) {
    return DashboardState(
      status: appStatus,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }

  Map<String, dynamic> toJson() => _$DashboardStateToJson(this);

  @override
  List<Object?> get props => [status, selectedIndex, message];
}
