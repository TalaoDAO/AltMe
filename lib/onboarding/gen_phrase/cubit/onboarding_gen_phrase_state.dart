part of 'onboarding_gen_phrase_cubit.dart';

@JsonSerializable()
class OnBoardingGenPhraseState extends Equatable {
  OnBoardingGenPhraseState({
    this.status = AppStatus.init,
    this.message,
    List<String>? mnemonic,
  }) : mnemonic = mnemonic ?? bip39.generateMnemonic().split(' ');

  factory OnBoardingGenPhraseState.fromJson(Map<String, dynamic> json) =>
      _$OnBoardingGenPhraseStateFromJson(json);

  final AppStatus status;
  final List<String> mnemonic;
  final StateMessage? message;

  OnBoardingGenPhraseState loading() {
    return OnBoardingGenPhraseState(
      status: AppStatus.loading,
      mnemonic: mnemonic,
    );
  }

  OnBoardingGenPhraseState error({
    required MessageHandler messageHandler,
  }) {
    return OnBoardingGenPhraseState(
      status: AppStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
      mnemonic: mnemonic,
    );
  }

  OnBoardingGenPhraseState success({
    MessageHandler? messageHandler,
    String? filePath,
  }) {
    return OnBoardingGenPhraseState(
      status: AppStatus.success,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
      mnemonic: mnemonic,
    );
  }

  Map<String, dynamic> toJson() => _$OnBoardingGenPhraseStateToJson(this);

  @override
  List<Object?> get props => [status, mnemonic, message];
}
