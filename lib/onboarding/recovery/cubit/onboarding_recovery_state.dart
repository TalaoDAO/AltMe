part of 'onboarding_recovery_cubit.dart';

@JsonSerializable()
class OnBoardingRecoveryState extends Equatable {
  const OnBoardingRecoveryState({
    this.status = AppStatus.init,
    this.message,
    this.isTextFieldEdited = false,
    this.isMnemonicValid = false,
  });

  factory OnBoardingRecoveryState.fromJson(Map<String, dynamic> json) =>
      _$OnBoardingRecoveryStateFromJson(json);

  final AppStatus status;
  final StateMessage? message;
  final bool isTextFieldEdited;
  final bool isMnemonicValid;

  OnBoardingRecoveryState loading() {
    return OnBoardingRecoveryState(
      status: AppStatus.loading,
      isTextFieldEdited: isTextFieldEdited,
      isMnemonicValid: isMnemonicValid,
    );
  }

  OnBoardingRecoveryState populating({
    bool? isTextFieldEdited,
    bool? isMnemonicValid,
    int? recoveredCredentialLength,
  }) {
    return OnBoardingRecoveryState(
      status: AppStatus.populate,
      isTextFieldEdited: isTextFieldEdited ?? this.isTextFieldEdited,
      isMnemonicValid: isMnemonicValid ?? this.isMnemonicValid,
    );
  }

  OnBoardingRecoveryState error({required MessageHandler messageHandler}) {
    return OnBoardingRecoveryState(
      status: AppStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
      isTextFieldEdited: isTextFieldEdited,
      isMnemonicValid: isMnemonicValid,
    );
  }

  OnBoardingRecoveryState success({
    MessageHandler? messageHandler,
  }) {
    return OnBoardingRecoveryState(
      status: AppStatus.success,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
      isTextFieldEdited: isTextFieldEdited,
      isMnemonicValid: isMnemonicValid,
    );
  }

  Map<String, dynamic> toJson() => _$OnBoardingRecoveryStateToJson(this);

  @override
  List<Object?> get props => [
        status,
        isMnemonicValid,
        isTextFieldEdited,
        message,
      ];
}
