part of 'camera_cubit.dart';

enum CameraStatus {
  initializing,
  intialized,
  initializeFailed,
  loading,
  imageCaptured,
  error
}

@JsonSerializable()
class CameraState extends Equatable {
  const CameraState({
    this.status = CameraStatus.initializing,
    this.data,
  });

  factory CameraState.fromJson(Map<String, dynamic> json) =>
      _$CameraStateFromJson(json);

  final CameraStatus status;
  final List<int>? data;

  Map<String, dynamic> toJson() => _$CameraStateToJson(this);

  CameraState copyWith({
    CameraStatus? status,
    List<int>? data,
    CameraController? cameraController,
  }) {
    return CameraState(
      status: status ?? this.status,
      data: data ?? this.data,
    );
  }

  @override
  List<Object?> get props => [
        status,
        data,
      ];
}
