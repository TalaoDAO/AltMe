part of 'splash_cubit.dart';

@JsonSerializable()
class SplashState extends Equatable {
  const SplashState({
    this.status = SplashStatus.init,
    this.versionNumber = '',
    this.buildNumber = '',
    this.isNewVersion = false,
  });

  factory SplashState.fromJson(Map<String, dynamic> json) =>
      _$SplashStateFromJson(json);

  final SplashStatus status;
  final String versionNumber;
  final String buildNumber;
  final bool isNewVersion;

  SplashState copyWith({
    SplashStatus? status,
    String? versionNumber,
    String? buildNumber,
    bool? isNewVersion,
  }) {
    return SplashState(
      status: status ?? this.status,
      versionNumber: versionNumber ?? this.versionNumber,
      buildNumber: buildNumber ?? this.buildNumber,
      isNewVersion: isNewVersion ?? this.isNewVersion,
    );
  }

  Map<String, dynamic> toJson() => _$SplashStateToJson(this);

  @override
  List<Object?> get props => [status, versionNumber, buildNumber, isNewVersion];
}
