part of 'tos_cubit.dart';

class TOSState extends Equatable {
  const TOSState({
    this.agreeTerms = false,
    this.scrollIsOver = false,
    this.readTerms = false,
    this.acceptanceButtonEnabled = false,
  });

  final bool scrollIsOver;
  final bool agreeTerms;
  final bool readTerms;
  final bool acceptanceButtonEnabled;

  TOSState copyWith({
    bool? agreeTerms,
    bool? scrollIsOver,
    bool? readTerms,
    bool? acceptanceButtonEnabled,
  }) {
    return TOSState(
      agreeTerms: agreeTerms ?? this.agreeTerms,
      scrollIsOver: scrollIsOver ?? this.scrollIsOver,
      readTerms: readTerms ?? this.readTerms,
      acceptanceButtonEnabled:
          acceptanceButtonEnabled ?? this.acceptanceButtonEnabled,
    );
  }

  @override
  List<Object?> get props =>
      [agreeTerms, scrollIsOver, readTerms, acceptanceButtonEnabled];
}
