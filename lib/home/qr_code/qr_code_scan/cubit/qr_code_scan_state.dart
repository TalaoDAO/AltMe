part of 'qr_code_scan_cubit.dart';

@JsonSerializable()
class QRCodeScanState extends Equatable {
  const QRCodeScanState({
    this.status = QrScanStatus.init,
    this.uri,
    this.route,
    this.isDeepLink = false,
    this.message,
  });

  factory QRCodeScanState.fromJson(Map<String, dynamic> json) =>
      _$QRCodeScanStateFromJson(json);

  final QrScanStatus status;
  final Uri? uri;
  @JsonKey(ignore: true)
  final Route? route;
  final bool isDeepLink;
  final StateMessage? message;

  Map<String, dynamic> toJson() => _$QRCodeScanStateToJson(this);


  QRCodeScanState loading({bool? isDeepLink}) {
    return QRCodeScanState(
      status: QrScanStatus.loading,
      isDeepLink: isDeepLink ?? this.isDeepLink,
      uri: uri,
    );
  }

  QRCodeScanState acceptHost({required Uri uri}) {
    return QRCodeScanState(
      status: QrScanStatus.acceptHost,
      isDeepLink: isDeepLink,
      uri: uri,
    );
  }

  QRCodeScanState error({required MessageHandler messageHandler}) {
    return QRCodeScanState(
      status: QrScanStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
      isDeepLink: isDeepLink,
      uri: uri,
    );
  }

  QRCodeScanState success({
    MessageHandler? messageHandler,
    required Route route,
  }) {
    return QRCodeScanState(
      status: QrScanStatus.success,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
      isDeepLink: isDeepLink,
      uri: uri,
      route: route,
    );
  }

  @override
  List<Object?> get props => [status, uri, route, isDeepLink, message];
}
