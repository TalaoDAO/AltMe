import 'package:credential_manifest/src/models/field.dart';
import 'package:json_annotation/json_annotation.dart';

part 'constraints.g.dart';

@JsonSerializable(explicitToJson: true)
class Constraints {
  Constraints(this.fields);

  factory Constraints.fromJson(Map<String, dynamic> json) =>
      _$ConstraintsFromJson(json);

  final List<Field>? fields;

  Map<String, dynamic> toJson() => _$ConstraintsToJson(this);
}
