import 'package:credential_manifest/src/models/constraints.dart';
import 'package:json_annotation/json_annotation.dart';

part 'input_descriptor.g.dart';

@JsonSerializable(explicitToJson: true)
class InputDescriptor {
  InputDescriptor(this.id, this.constraints, this.purpose);

  factory InputDescriptor.fromJson(Map<String, dynamic> json) =>
      _$InputDescriptorFromJson(json);

  final Constraints? constraints;
  final String? purpose;
  final String? id;

  Map<String, dynamic> toJson() => _$InputDescriptorToJson(this);
}
