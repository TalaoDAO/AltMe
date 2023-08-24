import 'package:json_annotation/json_annotation.dart';

part 'format_type.g.dart';

@JsonSerializable(explicitToJson: true)
class FormatType {
  FormatType({
    this.proofType,
  });

  factory FormatType.fromJson(Map<String, dynamic> json) =>
      _$FormatTypeFromJson(json);

  @JsonKey(name: 'proof_type')
  List<String>? proofType;

  Map<String, dynamic> toJson() => _$FormatTypeToJson(this);
}
