part of 'otp_cubit.dart';

@JsonSerializable()
class EnterpriseOTPState extends Equatable {
  const EnterpriseOTPState({
    this.status = AppStatus.init,
    this.message,
    this.isOTPCorrect = false,
  });

  factory EnterpriseOTPState.fromJson(Map<String, dynamic> json) =>
      _$EnterpriseOTPStateFromJson(json);

  final AppStatus status;
  final StateMessage? message;
  final bool isOTPCorrect;

  EnterpriseOTPState loading() {
    return copyWith(status: AppStatus.loading);
  }

  EnterpriseOTPState error({
    required MessageHandler messageHandler,
  }) {
    return copyWith(
      status: AppStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
    );
  }

  EnterpriseOTPState copyWith({
    AppStatus? status,
    StateMessage? message,
    bool? isOTPCorrect,
  }) {
    return EnterpriseOTPState(
      status: status ?? this.status,
      message: message ?? this.message,
      isOTPCorrect: isOTPCorrect ?? this.isOTPCorrect,
    );
  }

  Map<String, dynamic> toJson() => _$EnterpriseOTPStateToJson(this);

  @override
  List<Object?> get props => [
        status,
        message,
        isOTPCorrect,
      ];
}
