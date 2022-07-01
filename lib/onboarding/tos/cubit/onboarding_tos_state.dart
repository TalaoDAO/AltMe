part of 'onboarding_tos_cubit.dart';

@JsonSerializable()
class OnBoardingTosState extends Equatable {
  const OnBoardingTosState({
    this.agreeTerms = false,
    this.scrollIsOver = false,
    this.readTerms = false,
    this.acceptanceButtonEnabled = false,
  });

  factory OnBoardingTosState.fromJson(Map<String, dynamic> json) =>
      _$OnBoardingTosStateFromJson(json);

  final bool scrollIsOver;
  final bool agreeTerms;
  final bool readTerms;
  final bool acceptanceButtonEnabled;

  OnBoardingTosState copyWith({
    bool? agreeTerms,
    bool? scrollIsOver,
    bool? readTerms,
    bool? acceptanceButtonEnabled,
  }) {
    return OnBoardingTosState(
      agreeTerms: agreeTerms ?? this.agreeTerms,
      scrollIsOver: scrollIsOver ?? this.scrollIsOver,
      readTerms: readTerms ?? this.readTerms,
      acceptanceButtonEnabled:
          acceptanceButtonEnabled ?? this.acceptanceButtonEnabled,
    );
  }

  Map<String, dynamic> toJson() => _$OnBoardingTosStateToJson(this);

  @override
  List<Object?> get props =>
      [agreeTerms, scrollIsOver, readTerms, acceptanceButtonEnabled];
}
