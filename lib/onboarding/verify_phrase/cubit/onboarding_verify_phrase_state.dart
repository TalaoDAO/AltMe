part of 'onboarding_verify_phrase_cubit.dart';

@JsonSerializable()
class OnBoardingVerifyPhraseState extends Equatable {
  const OnBoardingVerifyPhraseState({
    this.status = AppStatus.init,
    this.message,
    this.isVerified = false,
  });

  factory OnBoardingVerifyPhraseState.fromJson(Map<String, dynamic> json) =>
      _$OnBoardingVerifyPhraseStateFromJson(json);

  final AppStatus status;
  final StateMessage? message;
  final bool isVerified;

  OnBoardingVerifyPhraseState loading() {
    return OnBoardingVerifyPhraseState(
      status: AppStatus.loading,
      isVerified: isVerified,
    );
  }

  OnBoardingVerifyPhraseState error({
    required MessageHandler messageHandler,
  }) {
    return OnBoardingVerifyPhraseState(
      status: AppStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
      isVerified: isVerified,
    );
  }

  OnBoardingVerifyPhraseState success({
    MessageHandler? messageHandler,
    String? filePath,
  }) {
    return OnBoardingVerifyPhraseState(
      status: AppStatus.success,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
      isVerified: isVerified,
    );
  }

  OnBoardingVerifyPhraseState copyWith({
    AppStatus? status,
    StateMessage? message,
    bool? isVerified,
  }) {
    return OnBoardingVerifyPhraseState(
      status: status ?? this.status,
      message: message ?? this.message,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  Map<String, dynamic> toJson() => _$OnBoardingVerifyPhraseStateToJson(this);

  @override
  List<Object?> get props => [status, isVerified, message];
}
