part of 'onboarding_gen_phrase_cubit.dart';

@JsonSerializable()
class OnBoardingGenPhraseState extends Equatable {
  OnBoardingGenPhraseState({
    this.status = AppStatus.init,
    this.message,
    this.isTicked = false,
    List<String>? mnemonic,
  }) : mnemonic = mnemonic ?? bip39.generateMnemonic().split(' ');

  factory OnBoardingGenPhraseState.fromJson(Map<String, dynamic> json) =>
      _$OnBoardingGenPhraseStateFromJson(json);

  final AppStatus status;
  final List<String> mnemonic;
  final StateMessage? message;
  final bool isTicked;

  OnBoardingGenPhraseState loading() {
    return OnBoardingGenPhraseState(
      status: AppStatus.loading,
      mnemonic: mnemonic,
      isTicked: isTicked,
    );
  }

  OnBoardingGenPhraseState error({
    required MessageHandler messageHandler,
  }) {
    return OnBoardingGenPhraseState(
      status: AppStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
      mnemonic: mnemonic,
      isTicked: isTicked,
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
      isTicked: isTicked,
    );
  }

  OnBoardingGenPhraseState copyWith({
    AppStatus? status,
    StateMessage? message,
    bool? isTicked,
    List<String>? mnemonic,
  }) {
    return OnBoardingGenPhraseState(
      status: status ?? this.status,
      message: message ?? this.message,
      mnemonic: mnemonic ?? this.mnemonic,
      isTicked: isTicked ?? this.isTicked,
    );
  }

  Map<String, dynamic> toJson() => _$OnBoardingGenPhraseStateToJson(this);

  @override
  List<Object?> get props => [status, mnemonic, isTicked, message];
}
