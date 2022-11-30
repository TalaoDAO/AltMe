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
    this.acquiredCredentialsQuantity = 0,
    this.ageEstimate = '',
  });

  factory CameraState.fromJson(Map<String, dynamic> json) =>
      _$CameraStateFromJson(json);

  final CameraStatus status;
  final List<int>? data;
  final int acquiredCredentialsQuantity;
  final String ageEstimate;

  Map<String, dynamic> toJson() => _$CameraStateToJson(this);

  CameraState copyWith({
    CameraStatus? status,
    List<int>? data,
    CameraController? cameraController,
    int? acquiredCredentialsQuantity,
    String? ageEstimate,
  }) {
    return CameraState(
      status: status ?? this.status,
      data: data ?? this.data,
      acquiredCredentialsQuantity:
          acquiredCredentialsQuantity ?? this.acquiredCredentialsQuantity,
      ageEstimate: ageEstimate ?? this.ageEstimate,
    );
  }

  @override
  List<Object?> get props => [
        status,
        data,
        acquiredCredentialsQuantity,
        ageEstimate,
      ];
}
