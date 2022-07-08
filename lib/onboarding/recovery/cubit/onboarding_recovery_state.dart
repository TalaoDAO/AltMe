part of 'onboarding_recovery_cubit.dart';

@JsonSerializable()
class OnBoardingRecoveryState extends Equatable {
  const OnBoardingRecoveryState({
    this.status = AppStatus.init,
    this.message,
    this.isTextFieldEdited = false,
    this.isMnemonicOrKeyValid = false,
  });

  factory OnBoardingRecoveryState.fromJson(Map<String, dynamic> json) =>
      _$OnBoardingRecoveryStateFromJson(json);

  final AppStatus status;
  final StateMessage? message;
  final bool isTextFieldEdited;
  final bool isMnemonicOrKeyValid;

  OnBoardingRecoveryState loading() {
    return OnBoardingRecoveryState(
      status: AppStatus.loading,
      isTextFieldEdited: isTextFieldEdited,
      isMnemonicOrKeyValid: isMnemonicOrKeyValid,
    );
  }

  OnBoardingRecoveryState populating({
    bool? isTextFieldEdited,
    bool? isMnemonicOrKeyValid,
    int? recoveredCredentialLength,
  }) {
    return OnBoardingRecoveryState(
      status: AppStatus.populate,
      isTextFieldEdited: isTextFieldEdited ?? this.isTextFieldEdited,
      isMnemonicOrKeyValid: isMnemonicOrKeyValid ?? this.isMnemonicOrKeyValid,
    );
  }

  OnBoardingRecoveryState error({required MessageHandler messageHandler}) {
    return OnBoardingRecoveryState(
      status: AppStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
      isTextFieldEdited: isTextFieldEdited,
      isMnemonicOrKeyValid: isMnemonicOrKeyValid,
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
      isMnemonicOrKeyValid: isMnemonicOrKeyValid,
    );
  }

  Map<String, dynamic> toJson() => _$OnBoardingRecoveryStateToJson(this);

  @override
  List<Object?> get props => [
        status,
        isMnemonicOrKeyValid,
        isTextFieldEdited,
        message,
      ];
}
