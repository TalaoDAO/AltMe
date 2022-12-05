import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'camera_config.g.dart';

@JsonSerializable()
class CameraConfig extends Equatable {
  const CameraConfig({
    this.frontCameraAsDefault = true,
  });

  factory CameraConfig.fromJson(Map<String, dynamic> json) =>
      _$CameraConfigFromJson(json);

  final bool frontCameraAsDefault;

  CameraConfig copyWith({bool? frontCameraAsDefault}) {
    return CameraConfig(
      frontCameraAsDefault: frontCameraAsDefault ?? this.frontCameraAsDefault,
    );
  }

  Map<String, dynamic> toJson() => _$CameraConfigToJson(this);

  @override
  List<Object?> get props => [
        frontCameraAsDefault,
      ];
}
