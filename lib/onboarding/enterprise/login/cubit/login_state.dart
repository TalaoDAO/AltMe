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
    return copyWith(
      status: AppStatus.loading,
      message: null,
    );
  }

  EnterpriseLoginState error({required StateMessage message}) {
    return copyWith(
      status: AppStatus.error,
      message: message,
    );
  }

  EnterpriseLoginState copyWith({
    required StateMessage? message,
    AppStatus? status,
    bool? isEmailFormatCorrect,
    bool? isPasswordFormatCorrect,
    bool? obscurePassword,
  }) {
    return EnterpriseLoginState(
      status: status ?? this.status,
      message: message,
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
