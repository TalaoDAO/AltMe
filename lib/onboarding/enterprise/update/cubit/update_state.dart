part of 'update_cubit.dart';

@JsonSerializable()
class EnterpriseUpdateState extends Equatable {
  const EnterpriseUpdateState({
    this.status = AppStatus.init,
    this.message,
    this.isEmailFormatCorrect = false,
    this.isPasswordFormatCorrect = false,
    this.obscurePassword = true,
  });

  factory EnterpriseUpdateState.fromJson(Map<String, dynamic> json) =>
      _$EnterpriseUpdateStateFromJson(json);

  final AppStatus status;
  final StateMessage? message;
  final bool isEmailFormatCorrect;
  final bool isPasswordFormatCorrect;
  final bool obscurePassword;

  EnterpriseUpdateState loading() {
    return copyWith(
      status: AppStatus.loading,
      message: null,
    );
  }

  EnterpriseUpdateState error({required StateMessage message}) {
    return copyWith(
      status: AppStatus.error,
      message: message,
    );
  }

  EnterpriseUpdateState copyWith({
    required StateMessage? message,
    AppStatus? status,
    bool? isEmailFormatCorrect,
    bool? isPasswordFormatCorrect,
    bool? obscurePassword,
  }) {
    return EnterpriseUpdateState(
      status: status ?? this.status,
      message: message,
      isEmailFormatCorrect: isEmailFormatCorrect ?? this.isEmailFormatCorrect,
      isPasswordFormatCorrect:
          isPasswordFormatCorrect ?? this.isPasswordFormatCorrect,
      obscurePassword: obscurePassword ?? this.obscurePassword,
    );
  }

  Map<String, dynamic> toJson() => _$EnterpriseUpdateStateToJson(this);

  @override
  List<Object?> get props => [
        status,
        message,
        isEmailFormatCorrect,
        isPasswordFormatCorrect,
        obscurePassword
      ];
}
