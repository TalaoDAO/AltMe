part of 'dashboard_cubit.dart';

/// The destinations of the dashboard shown inside its page view.
///
/// Present and the centre button push the scanner instead and are never
/// selected.
enum DashboardTab { wallet, discover, search }

@JsonSerializable()
class DashboardState extends Equatable {
  const DashboardState({
    this.status = AppStatus.init,
    this.message,
    this.tab = DashboardTab.wallet,
  });

  factory DashboardState.fromJson(Map<String, dynamic> json) =>
      _$DashboardStateFromJson(json);

  final AppStatus status;
  final DashboardTab tab;
  final StateMessage? message;

  DashboardState loading() {
    final loadingState = DashboardState(status: AppStatus.loading, tab: tab);
    return loadingState;
  }

  DashboardState error({required MessageHandler messageHandler}) {
    final errorState = DashboardState(
      status: AppStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
      tab: tab,
    );
    return errorState;
  }

  DashboardState copyWith({
    AppStatus appStatus = AppStatus.idle,
    MessageHandler? messageHandler,
    DashboardTab? tab,
  }) {
    final dashboardState = DashboardState(
      status: appStatus,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
      tab: tab ?? this.tab,
    );
    return dashboardState;
  }

  Map<String, dynamic> toJson() => _$DashboardStateToJson(this);

  @override
  List<Object?> get props => [status, tab, message];
}
