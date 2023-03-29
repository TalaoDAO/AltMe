part of 'splash_cubit.dart';

@JsonSerializable()
class SplashState extends Equatable {
  const SplashState({
    this.status = SplashStatus.init,
    this.versionNumber = '',
    this.buildNumber = '',
    this.isNewVersion = false,
    this.loadedValue = 0,
  });

  factory SplashState.fromJson(Map<String, dynamic> json) =>
      _$SplashStateFromJson(json);

  final SplashStatus status;
  final String versionNumber;
  final String buildNumber;
  final bool isNewVersion;
  final double loadedValue;

  SplashState copyWith({
    SplashStatus? status,
    String? versionNumber,
    String? buildNumber,
    bool? isNewVersion,
    double? loadedValue,
  }) {
    return SplashState(
      status: status ?? this.status,
      versionNumber: versionNumber ?? this.versionNumber,
      buildNumber: buildNumber ?? this.buildNumber,
      isNewVersion: isNewVersion ?? this.isNewVersion,
      loadedValue: loadedValue ?? this.loadedValue,
    );
  }

  Map<String, dynamic> toJson() => _$SplashStateToJson(this);

  @override
  List<Object?> get props =>
      [status, versionNumber, buildNumber, isNewVersion, loadedValue];
}
