part of 'qr_code_scan_cubit.dart';

@JsonSerializable()
class QRCodeScanState extends Equatable {
  const QRCodeScanState({
    this.status = QrScanStatus.init,
    this.uri,
    this.route,
    this.isScan = false,
    this.message,
    this.dialogData,
  });

  factory QRCodeScanState.fromJson(Map<String, dynamic> json) =>
      _$QRCodeScanStateFromJson(json);

  final QrScanStatus status;
  final Uri? uri;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final Route<dynamic>? route;
  final bool isScan;

  final StateMessage? message;
  final String? dialogData;

  Map<String, dynamic> toJson() => _$QRCodeScanStateToJson(this);

  QRCodeScanState loading({bool? isScan}) {
    return QRCodeScanState(
      status: QrScanStatus.loading,
      isScan: isScan ?? this.isScan,
      uri: uri,
    );
  }

  QRCodeScanState acceptHost() {
    return QRCodeScanState(
      status: QrScanStatus.acceptHost,
      isScan: isScan,
      uri: uri,
    );
  }

  QRCodeScanState error({required StateMessage message}) {
    return QRCodeScanState(
      status: QrScanStatus.error,
      message: message,
      isScan: isScan,
      uri: uri,
    );
  }

  QRCodeScanState copyWith({
    QrScanStatus qrScanStatus = QrScanStatus.idle,
    StateMessage? message,
    Route<dynamic>? route,
    Uri? uri,
    bool? isScan,
    String? dialogData,
  }) {
    late Uri? newUri;
    if (uri.toString().startsWith('${Parameters.universalLink}/oidc4vc?uri=')) {
      newUri = Uri.parse(
        Uri.decodeFull(
          uri
              .toString()
              .substring('${Parameters.universalLink}/oidc4vc?uri='.length),
        ),
      );
    } else {
      newUri = uri;
    }
    return QRCodeScanState(
      status: qrScanStatus,
      message: message,
      isScan: isScan ?? this.isScan,
      uri: newUri ?? this.uri,
      route: route, // route should be cleared when one route is done
      dialogData: dialogData,
    );
  }

  @override
  List<Object?> get props => [
        status,
        uri,
        route,
        isScan,
        message,
        dialogData,
      ];
}
