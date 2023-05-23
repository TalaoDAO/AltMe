part of 'onboarding_cubit.dart';

@JsonSerializable()
class OnboardingState extends Equatable {
  const OnboardingState({
    this.status = AppStatus.init,
  });

  factory OnboardingState.fromJson(Map<String, dynamic> json) =>
      _$OnboardingStateFromJson(json);

  final AppStatus status;

  OnboardingState copyWith({
    required AppStatus status,
  }) {
    return OnboardingState(
      status: status,
    );
  }

  Map<String, dynamic> toJson() => _$OnboardingStateToJson(this);

  @override
  List<Object?> get props => [
        status,
      ];
}
