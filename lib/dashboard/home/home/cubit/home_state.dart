part of 'home_cubit.dart';

@JsonSerializable()
class HomeState extends Equatable {
  const HomeState({
    this.status = AppStatus.init,
    this.message,
    this.homeStatus = HomeStatus.hasNoWallet,
    this.link,
    this.data,
  });

  factory HomeState.fromJson(Map<String, dynamic> json) =>
      _$HomeStateFromJson(json);

  final AppStatus status;
  final StateMessage? message;
  final HomeStatus homeStatus;
  final String? link;
  final dynamic data;

  HomeState loading() {
    final loadingState = HomeState(
      status: AppStatus.loading,
      homeStatus: homeStatus,
      link: link,
    );
    return loadingState;
  }

  HomeState copyWith({
    required AppStatus status,
    StateMessage? message,
    HomeStatus? homeStatus,
    String? link,
    dynamic data,
    bool? needToVerifyMnemonics,
  }) {
    final homeState = HomeState(
      status: status,
      message: message,
      homeStatus: homeStatus ?? this.homeStatus,
      link: link ?? this.link,
      data: data ?? this.data,
    );
    return homeState;
  }

  Map<String, dynamic> toJson() => _$HomeStateToJson(this);

  @override
  List<Object?> get props => [status, message, homeStatus, link, data];
}
