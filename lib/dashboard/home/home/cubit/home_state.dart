part of 'home_cubit.dart';

@JsonSerializable()
class HomeState extends Equatable {
  const HomeState({
    this.status = AppStatus.init,
    this.message,
    this.homeStatus = HomeStatus.hasNoWallet,
    this.link,
    this.tokenReward,
    this.data,
  });

  factory HomeState.fromJson(Map<String, dynamic> json) =>
      _$HomeStateFromJson(json);

  final AppStatus status;
  final StateMessage? message;
  final HomeStatus homeStatus;
  final String? link;
  final TokenReward? tokenReward;
  final dynamic data;

  HomeState loading() {
    return HomeState(
      status: AppStatus.loading,
      homeStatus: homeStatus,
      tokenReward: null,
      link: link,
    );
  }

  HomeState copyWith({
    required AppStatus status,
    StateMessage? message,
    HomeStatus? homeStatus,
    String? link,
    TokenReward? tokenReward,
    dynamic data,
    bool? needToVerifyMnemonics,
  }) {
    return HomeState(
      status: status,
      message: message,
      homeStatus: homeStatus ?? this.homeStatus,
      link: link ?? this.link,
      tokenReward: tokenReward ?? this.tokenReward,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toJson() => _$HomeStateToJson(this);

  @override
  List<Object?> get props => [
        status,
        message,
        homeStatus,
        link,
        tokenReward,
        data,
      ];
}
