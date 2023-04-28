part of 'polygon_id_cubit.dart';

@JsonSerializable()
class PolygonIdState extends Equatable {
  const PolygonIdState({
    this.status = PolygonIdStatus.init,
    this.isInitialised = false,
    this.message,
    this.loadingText,
    this.scannedResponse,
  });

  factory PolygonIdState.fromJson(Map<String, dynamic> json) =>
      _$PolygonIdStateFromJson(json);

  final PolygonIdStatus status;
  final StateMessage? message;
  final StateMessage? loadingText;
  final bool isInitialised;
  final String? scannedResponse;

  PolygonIdState error({required StateMessage message}) {
    return PolygonIdState(
      status: PolygonIdStatus.error,
      message: message,
      scannedResponse: scannedResponse,
    );
  }

  PolygonIdState copyWith({
    PolygonIdStatus status = PolygonIdStatus.idle,
    bool? isInitialised,
    StateMessage? message,
    StateMessage? loadingText,
    Route<dynamic>? route,
    String? scannedResponse,
  }) {
    return PolygonIdState(
      status: status,
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
        message,
        isInitialised,
        scannedResponse,
        loadingText,
      ];
}
