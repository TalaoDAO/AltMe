part of 'qr_code_scan_cubit.dart';

@JsonSerializable()
class QRCodeScanState extends Equatable {
  const QRCodeScanState({
    this.status = QrScanStatus.init,
    this.uri,
    this.route,
    this.isScan = false,
    this.isRequestVerified = true,
    this.message,
  });

  factory QRCodeScanState.fromJson(Map<String, dynamic> json) =>
      _$QRCodeScanStateFromJson(json);

  final QrScanStatus status;
  final Uri? uri;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final Route<dynamic>? route;
  final bool isScan;
  final bool isRequestVerified;
  final StateMessage? message;

  Map<String, dynamic> toJson() => _$QRCodeScanStateToJson(this);

  QRCodeScanState loading({bool? isScan}) {
    return QRCodeScanState(
      status: QrScanStatus.loading,
      isScan: isScan ?? this.isScan,
      uri: uri,
      isRequestVerified: isRequestVerified,
    );
  }

  QRCodeScanState acceptHost({required bool isRequestVerified}) {
    return QRCodeScanState(
      status: QrScanStatus.acceptHost,
      isScan: isScan,
      uri: uri,
      isRequestVerified: isRequestVerified,
    );
  }

  QRCodeScanState error({required MessageHandler messageHandler}) {
    return QRCodeScanState(
      status: QrScanStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
      isScan: isScan,
      uri: uri,
      isRequestVerified: isRequestVerified,
    );
  }

  QRCodeScanState copyWith({
    QrScanStatus qrScanStatus = QrScanStatus.idle,
    StateMessage? message,
    Route<dynamic>? route,
    Uri? uri,
    bool? isScan,
  }) {
    return QRCodeScanState(
      status: qrScanStatus,
      message: message,
      isScan: isScan ?? this.isScan,
      uri: uri ?? this.uri,
      route: route ?? this.route,
      isRequestVerified: isRequestVerified,
    );
  }

  @override
  List<Object?> get props =>
      [status, uri, route, isScan, message, isRequestVerified];
}
