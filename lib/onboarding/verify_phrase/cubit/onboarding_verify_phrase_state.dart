part of 'onboarding_verify_phrase_cubit.dart';

@JsonSerializable()
class OnBoardingVerifyPhraseState extends Equatable {
  OnBoardingVerifyPhraseState({
    this.status = AppStatus.init,
    this.message,
    this.isVerified = false,
    List<MnemonicState>? mnemonicStates,
  }) : mnemonicStates = mnemonicStates ?? [];

  factory OnBoardingVerifyPhraseState.fromJson(Map<String, dynamic> json) =>
      _$OnBoardingVerifyPhraseStateFromJson(json);

  final AppStatus status;
  final StateMessage? message;
  final bool isVerified;
  final List<MnemonicState> mnemonicStates;

  OnBoardingVerifyPhraseState loading() {
    return OnBoardingVerifyPhraseState(
      status: AppStatus.loading,
      isVerified: isVerified,
      mnemonicStates: mnemonicStates,
    );
  }

  OnBoardingVerifyPhraseState error({
    required MessageHandler messageHandler,
  }) {
    return OnBoardingVerifyPhraseState(
      status: AppStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
      isVerified: isVerified,
      mnemonicStates: mnemonicStates,
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
      mnemonicStates: mnemonicStates,
    );
  }

  OnBoardingVerifyPhraseState copyWith({
    required AppStatus status,
    StateMessage? message,
    bool? isVerified,
    List<MnemonicState>? mnemonicStates,
  }) {
    return OnBoardingVerifyPhraseState(
      status: status,
      message: message ?? this.message,
      isVerified: isVerified ?? this.isVerified,
      mnemonicStates: mnemonicStates ?? this.mnemonicStates,
    );
  }

  Map<String, dynamic> toJson() => _$OnBoardingVerifyPhraseStateToJson(this);

  @override
  List<Object?> get props => [status, isVerified, message, mnemonicStates];
}

@JsonSerializable()
class MnemonicState extends Equatable {
  const MnemonicState({
    this.mnemonicStatus = MnemonicStatus.unselected,
    required this.order,
  });

  factory MnemonicState.fromJson(Map<String, dynamic> json) =>
      _$MnemonicStateFromJson(json);

  final MnemonicStatus mnemonicStatus;
  final int order;

  MnemonicState copyWith({
    required MnemonicStatus mnemonicStatus,
  }) {
    return MnemonicState(
      order: order,
      mnemonicStatus: mnemonicStatus,
    );
  }

  Map<String, dynamic> toJson() => _$MnemonicStateToJson(this);

  @override
  List<Object?> get props => [mnemonicStatus, order];
}
