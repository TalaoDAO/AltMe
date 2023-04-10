import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'license_model.g.dart';

@JsonSerializable()
class LicenseModel extends Equatable {
  const LicenseModel(this.title, this.description);

  factory LicenseModel.fromJson(Map<String, dynamic> json) =>
      _$LicenseModelFromJson(json);

  final String title;
  final String description;

  Map<String, dynamic> toJson() => _$LicenseModelToJson(this);

  @override
  List<Object> get props => [
        title,
        description,
      ];
}
