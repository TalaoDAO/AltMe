part of 'qr_code_scan_cubit.dart';

@JsonSerializable()
class QRCodeScanState extends Equatable {
  const QRCodeScanState({
    this.uri,
    this.route,
    this.isDeepLink = false,
    this.message,
  });

  factory QRCodeScanState.fromJson(Map<String, dynamic> json) =>
      _$QRCodeScanStateFromJson(json);

  final Uri? uri;
  @JsonKey(ignore: true)
  final Route? route;
  final bool isDeepLink;
  final StateMessage? message;

  Map<String, dynamic> toJson() => _$QRCodeScanStateToJson(this);

  QRCodeScanState copyWith({
    Uri? uri,
    Route? route,
    bool? isDeepLink,
    StateMessage? message,
  }) {
    return QRCodeScanState(
      uri: uri ?? this.uri,
      route: route ?? this.route,
      isDeepLink: isDeepLink ?? this.isDeepLink,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [uri, route, isDeepLink, message];
}

class QRCodeScanStateWorking extends QRCodeScanState {
  const QRCodeScanStateWorking({bool isDeepLink = false})
      : super(isDeepLink: isDeepLink);
}

class QRCodeScanStateHost extends QRCodeScanState {
  const QRCodeScanStateHost({Uri? uri, required bool isDeepLink})
      : super(uri: uri, isDeepLink: isDeepLink);
}

class QRCodeScanStateSuccess extends QRCodeScanState {
  const QRCodeScanStateSuccess({Route? route, required bool isDeepLink})
      : super(route: route, isDeepLink: isDeepLink);
}

class QRCodeScanStateUnknown extends QRCodeScanState {
  const QRCodeScanStateUnknown({required Uri uri, required bool isDeepLink})
      : super(uri: uri, isDeepLink: isDeepLink);
}

class QRCodeScanStateMessage extends QRCodeScanState {
  const QRCodeScanStateMessage({
    StateMessage? message,
    required bool isDeepLink,
  }) : super(message: message, isDeepLink: isDeepLink);
}
