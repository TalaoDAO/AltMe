part of 'polygon_id_cubit.dart';

@JsonSerializable()
class PolygonIdState extends Equatable {
  const PolygonIdState({
    this.status = AppStatus.init,
    this.isInitialised = false,
    this.message,
    this.loadingText,
    this.route,
    this.scannedResponse,
  });

  factory PolygonIdState.fromJson(Map<String, dynamic> json) =>
      _$PolygonIdStateFromJson(json);

  final AppStatus status;
  final StateMessage? message;
  final StateMessage? loadingText;
  final bool isInitialised;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final Route<dynamic>? route;
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
      route: route ?? this.route,
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
        route,
        loadingText,
      ];
}
