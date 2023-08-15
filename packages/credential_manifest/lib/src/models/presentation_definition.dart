import 'package:credential_manifest/src/models/input_descriptor.dart';
import 'package:json_annotation/json_annotation.dart';

part 'presentation_definition.g.dart';

@JsonSerializable(explicitToJson: true)
class PresentationDefinition {
  PresentationDefinition({
    required this.inputDescriptors,
    this.id,
  });

  factory PresentationDefinition.fromJson(Map<String, dynamic> json) =>
      _$PresentationDefinitionFromJson(json);
  final String? id;
  @JsonKey(name: 'input_descriptors')
  final List<InputDescriptor> inputDescriptors;

  Map<String, dynamic> toJson() => _$PresentationDefinitionToJson(this);
}
