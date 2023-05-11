part of 'polygon_id_cubit.dart';

@JsonSerializable()
class PolygonIdState extends Equatable {
  const PolygonIdState({
    this.status = AppStatus.init,
    this.polygonAction,
    this.isInitialised = false,
    this.message,
    this.loadingText,
    this.scannedResponse,
  });

  factory PolygonIdState.fromJson(Map<String, dynamic> json) =>
      _$PolygonIdStateFromJson(json);

  final AppStatus status;
  final PolygonIdAction? polygonAction;
  final StateMessage? message;
  final StateMessage? loadingText;
  final bool isInitialised;
  final String? scannedResponse;

  PolygonIdState error({required StateMessage message}) {
    return PolygonIdState(
      status: AppStatus.error,
      message: message,
      scannedResponse: scannedResponse,
    );
  }

  PolygonIdState copyWith({
    AppStatus status = AppStatus.idle,
    PolygonIdAction? polygonAction,
    bool? isInitialised,
    StateMessage? message,
    StateMessage? loadingText,
    Route<dynamic>? route,
    String? scannedResponse,
  }) {
    return PolygonIdState(
      status: status,
      polygonAction: polygonAction,
      message: message,
      loadingText: loadingText,
      isInitialised: isInitialised ?? this.isInitialised,
      scannedResponse: scannedResponse ?? this.scannedResponse,
    );
  }

  Map<String, dynamic> toJson() => _$PolygonIdStateToJson(this);

  @override
  List<Object?> get props => [
        status,
        polygonAction,
        message,
        isInitialised,
        scannedResponse,
        loadingText,
      ];
}
