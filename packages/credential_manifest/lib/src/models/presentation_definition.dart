import 'package:credential_manifest/src/models/format.dart';
import 'package:credential_manifest/src/models/input_descriptor.dart';
import 'package:json_annotation/json_annotation.dart';

part 'presentation_definition.g.dart';

@JsonSerializable(explicitToJson: true)
class PresentationDefinition {
  PresentationDefinition({
    required this.inputDescriptors,
    this.id,
    this.name,
    this.purpose,
    this.format,
  });

  factory PresentationDefinition.fromJson(Map<String, dynamic> json) =>
      _$PresentationDefinitionFromJson(json);

  final String? id;
  @JsonKey(name: 'input_descriptors')
  final List<InputDescriptor> inputDescriptors;
  String? name;
  String? purpose;
  Format? format;

  Map<String, dynamic> toJson() => _$PresentationDefinitionToJson(this);
}
