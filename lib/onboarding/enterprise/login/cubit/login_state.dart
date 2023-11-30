part of 'login_cubit.dart';

@JsonSerializable()
class EnterpriseLoginState extends Equatable {
  const EnterpriseLoginState({
    this.status = AppStatus.init,
    this.message,
    this.isEmailFormatCorrect = false,
    this.isPasswordFormatCorrect = false,
    this.obscurePassword = true,
  });

  factory EnterpriseLoginState.fromJson(Map<String, dynamic> json) =>
      _$EnterpriseLoginStateFromJson(json);

  final AppStatus status;
  final StateMessage? message;
  final bool isEmailFormatCorrect;
  final bool isPasswordFormatCorrect;
  final bool obscurePassword;

  EnterpriseLoginState loading() {
    return copyWith(status: AppStatus.loading);
  }

  EnterpriseLoginState error({
    required MessageHandler messageHandler,
  }) {
    return copyWith(
      status: AppStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
    );
  }

  EnterpriseLoginState copyWith({
    AppStatus? status,
    StateMessage? message,
    bool? isEmailFormatCorrect,
    bool? isPasswordFormatCorrect,
    bool? obscurePassword,
  }) {
    return EnterpriseLoginState(
      status: status ?? this.status,
      message: message ?? this.message,
      isEmailFormatCorrect: isEmailFormatCorrect ?? this.isEmailFormatCorrect,
      isPasswordFormatCorrect:
          isPasswordFormatCorrect ?? this.isPasswordFormatCorrect,
      obscurePassword: obscurePassword ?? this.obscurePassword,
    );
  }

  Map<String, dynamic> toJson() => _$EnterpriseLoginStateToJson(this);

  @override
  List<Object?> get props => [
        status,
        message,
        isEmailFormatCorrect,
        isPasswordFormatCorrect,
        obscurePassword
      ];
}
