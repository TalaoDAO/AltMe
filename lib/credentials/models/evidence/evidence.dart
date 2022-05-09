import 'package:json_annotation/json_annotation.dart';

part 'evidence.g.dart';

@JsonSerializable()
class Evidence {
  Evidence(this.id, this.type);

  factory Evidence.fromJson(Map<String, dynamic> json) =>
      _$EvidenceFromJson(json);

  factory Evidence.emptyEvidence() => Evidence('', []);

  @JsonKey(defaultValue: '')
  final String id;
  @JsonKey(defaultValue: <Evidence>[])
  final List<String> type;

  Map<String, dynamic> toJson() => _$EvidenceToJson(this);
}
