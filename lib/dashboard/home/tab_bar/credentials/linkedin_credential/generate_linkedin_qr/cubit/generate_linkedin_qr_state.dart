part of 'generate_linkedin_qr_cubit.dart';

@JsonSerializable()
class GenerateLinkedInQrState extends Equatable {
  const GenerateLinkedInQrState({
    this.status = AppStatus.init,
    this.message,
    this.qrValue,
  });

  factory GenerateLinkedInQrState.fromJson(Map<String, dynamic> json) =>
      _$GenerateLinkedInQrStateFromJson(json);

  final AppStatus status;
  final StateMessage? message;
  final String? qrValue;

  GenerateLinkedInQrState loading() {
    return GenerateLinkedInQrState(
      status: AppStatus.loading,
      qrValue: qrValue,
    );
  }

  GenerateLinkedInQrState error({required MessageHandler messageHandler}) {
    return GenerateLinkedInQrState(
      status: AppStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
    );
  }

  GenerateLinkedInQrState copyWith({
    required AppStatus status,
    MessageHandler? messageHandler,
    String? qrValue,
  }) {
    return GenerateLinkedInQrState(
      status: status,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
      qrValue: qrValue ?? this.qrValue,
    );
  }

  Map<String, dynamic> toJson() => _$GenerateLinkedInQrStateToJson(this);

  @override
  List<Object?> get props => [status, message, qrValue];
}
