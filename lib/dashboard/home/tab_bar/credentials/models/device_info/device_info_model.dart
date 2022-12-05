import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:json_annotation/json_annotation.dart';

part 'device_info_model.g.dart';

@JsonSerializable(explicitToJson: true)
class DeviceInfoModel extends CredentialSubjectModel {
  DeviceInfoModel({
    this.systemName,
    this.device,
    this.systemVersion,
    this.identifier,
    String? id,
    String? type,
  }) : super(
          id: id,
          type: type,
          credentialSubjectType: CredentialSubjectType.deviceInfo,
          credentialCategory: CredentialCategory.othersCards,
        );

  factory DeviceInfoModel.fromJson(Map<String, dynamic> json) =>
      _$DeviceInfoModelFromJson(json);

  @JsonKey(defaultValue: '')
  final String? systemName;

  @JsonKey(defaultValue: '')
  final String? device;

  @JsonKey(defaultValue: '')
  final String? systemVersion;

  @JsonKey(defaultValue: '')
  final String? identifier;

  @override
  Map<String, dynamic> toJson() => _$DeviceInfoModelToJson(this);
}
