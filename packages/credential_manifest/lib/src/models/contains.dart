import 'package:json_annotation/json_annotation.dart';

part 'contains.g.dart';

@JsonSerializable(explicitToJson: true)
class Contains {
  Contains({
    required this.containsConst,
  });

  factory Contains.fromJson(Map<String, dynamic> json) =>
      _$ContainsFromJson(json);

  @JsonKey(name: 'const')
  String containsConst;

  Map<String, dynamic> toJson() => _$ContainsToJson(this);
}
