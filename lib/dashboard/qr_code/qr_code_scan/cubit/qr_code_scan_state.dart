part of 'qr_code_scan_cubit.dart';

@JsonSerializable()
class QRCodeScanState extends Equatable {
  const QRCodeScanState({
    this.status = QrScanStatus.init,
    this.uri,
    this.route,
    this.isScan = false,
    this.message,
  });

  factory QRCodeScanState.fromJson(Map<String, dynamic> json) =>
      _$QRCodeScanStateFromJson(json);

  final QrScanStatus status;
  final Uri? uri;
  @JsonKey(ignore: true)
  final Route? route;
  final bool isScan;
  final StateMessage? message;

  Map<String, dynamic> toJson() => _$QRCodeScanStateToJson(this);

  QRCodeScanState loading({required bool isScan}) {
    return QRCodeScanState(
      status: QrScanStatus.loading,
      isScan: isScan,
      uri: uri,
    );
  }

  QRCodeScanState acceptHost({required Uri uri}) {
    return QRCodeScanState(
      status: QrScanStatus.acceptHost,
      isScan: isScan,
      uri: uri,
    );
  }

  QRCodeScanState error({required MessageHandler messageHandler}) {
    return QRCodeScanState(
      status: QrScanStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
      isScan: isScan,
      uri: uri,
    );
  }

  QRCodeScanState copyWith({
    QrScanStatus qrScanStatus = QrScanStatus.idle,
    StateMessage? message,
    Route? route,
  }) {
    return QRCodeScanState(
      status: qrScanStatus,
      message: message,
      isScan: isScan,
      uri: uri,
      route: route ?? this.route,
    );
  }

  @override
  List<Object?> get props => [status, uri, route, isScan, message];
}
