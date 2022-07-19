part of 'home_cubit.dart';

@JsonSerializable()
class HomeState extends Equatable {
  const HomeState({
    this.status = AppStatus.init,
    this.message,
    this.homeStatus = HomeStatus.hasNoWallet,
    this.passBaseStatus,
    this.link,
    this.isMinimized = false,
  });

  factory HomeState.fromJson(Map<String, dynamic> json) =>
      _$HomeStateFromJson(json);

  final AppStatus status;
  final StateMessage? message;
  final HomeStatus homeStatus;
  final PassBaseStatus? passBaseStatus;
  final String? link;
  final bool isMinimized;

  HomeState loading() {
    return HomeState(
      status: AppStatus.loading,
      homeStatus: homeStatus,
      passBaseStatus: null,
      link: link,
      isMinimized: isMinimized,
    );
  }

  HomeState error({required MessageHandler messageHandler}) {
    return HomeState(
      status: AppStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
      homeStatus: homeStatus,
      passBaseStatus: passBaseStatus,
      link: link,
      isMinimized: isMinimized,
    );
  }

  HomeState copyWith({
    required AppStatus status,
    MessageHandler? messageHandler,
    HomeStatus? homeStatus,
    PassBaseStatus? passBaseStatus,
    String? link,
    bool? isMinimized,
  }) {
    return HomeState(
      status: status,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
      homeStatus: homeStatus ?? this.homeStatus,
      passBaseStatus: passBaseStatus ?? this.passBaseStatus,
      link: link ?? this.link,
      isMinimized: isMinimized ?? this.isMinimized,
    );
  }

  Map<String, dynamic> toJson() => _$HomeStateToJson(this);

  @override
  List<Object?> get props => [
        status,
        message,
        homeStatus,
        passBaseStatus,
        link,
        isMinimized,
      ];
}
