part of 'splash_cubit.dart';

@JsonSerializable()
class SplashState extends Equatable {
  const SplashState({
    this.status = SplashStatus.init,
    this.versionNumber = '',
  });

  factory SplashState.fromJson(Map<String, dynamic> json) =>
      _$SplashStateFromJson(json);

  final SplashStatus status;
  final String versionNumber;

  SplashState copyWith({SplashStatus? status, String? versionNumber}) {
    return SplashState(
      status: status ?? this.status,
      versionNumber: versionNumber ?? this.versionNumber,
    );
  }

  Map<String, dynamic> toJson() => _$SplashStateToJson(this);

  @override
  List<Object?> get props => [status, versionNumber];
}
