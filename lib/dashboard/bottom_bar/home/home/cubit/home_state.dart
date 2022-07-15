part of 'home_cubit.dart';

@JsonSerializable()
class HomeState extends Equatable {
  const HomeState({
    this.status = AppStatus.init,
    this.message,
    this.homeStatus = HomeStatus.hasNoWallet,
    this.passBaseStatus,
  });

  factory HomeState.fromJson(Map<String, dynamic> json) =>
      _$HomeStateFromJson(json);

  final AppStatus status;
  final StateMessage? message;
  final HomeStatus homeStatus;
  final PassBaseStatus? passBaseStatus;

  HomeState loading() {
    return HomeState(
      status: AppStatus.loading,
      homeStatus: homeStatus,
      passBaseStatus: null,
    );
  }

  HomeState error({required MessageHandler messageHandler}) {
    return HomeState(
      status: AppStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
      homeStatus: homeStatus,
      passBaseStatus: passBaseStatus,
    );
  }

  HomeState copyWith({
    required AppStatus status,
    MessageHandler? messageHandler,
    HomeStatus? homeStatus,
    PassBaseStatus? passBaseStatus,
  }) {
    return HomeState(
      status: status,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
      homeStatus: homeStatus ?? this.homeStatus,
      passBaseStatus: passBaseStatus ?? this.passBaseStatus,
    );
  }

  Map<String, dynamic> toJson() => _$HomeStateToJson(this);

  @override
  List<Object?> get props => [
        status,
        message,
        homeStatus,
        passBaseStatus,
      ];
}
