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
    final loadingState = DashboardState(
      status: AppStatus.loading,
      selectedIndex: selectedIndex,
    );
    return loadingState;
  }

  DashboardState error({required MessageHandler messageHandler}) {
    final errorState = DashboardState(
      status: AppStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
      selectedIndex: selectedIndex,
    );
    return errorState;
  }

  DashboardState copyWith({
    AppStatus appStatus = AppStatus.idle,
    MessageHandler? messageHandler,
    int? selectedIndex,
  }) {
    final dashboardState = DashboardState(
      status: appStatus,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
    return dashboardState;
  }

  Map<String, dynamic> toJson() => _$DashboardStateToJson(this);

  @override
  List<Object?> get props => [status, selectedIndex, message];
}
