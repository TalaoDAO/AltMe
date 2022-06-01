part of 'pin_code_cubit.dart';

@JsonSerializable()
class PinCodeState extends Equatable {
  const PinCodeState({
    this.status = AppStatus.init,
    this.message,
    this.data,
  });

  factory PinCodeState.fromJson(Map<String, dynamic> json) =>
      _$PinCodeStateFromJson(json);

  final AppStatus status;
  final StateMessage? message;
  final dynamic data;

  PinCodeState loading() {
    return PinCodeState(
      status: AppStatus.loading,
      data: data,
    );
  }

  PinCodeState error({
    required MessageHandler messageHandler,
  }) {
    return PinCodeState(
      status: AppStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
      data: data,
    );
  }

  PinCodeState success({MessageHandler? messageHandler, dynamic data}) {
    return PinCodeState(
      status: AppStatus.success,
      data: data ?? this.data,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
    );
  }

  Map<String, dynamic> toJson() => _$PinCodeStateToJson(this);

  @override
  List<Object?> get props => [status, message, data];
}
