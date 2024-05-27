import 'package:credential_manifest/src/models/contains.dart';
import 'package:json_annotation/json_annotation.dart';

part 'filter.g.dart';

@JsonSerializable(explicitToJson: true)
class Filter {
  Filter({
    required this.type,
    this.pattern,
    this.contains,
    this.containsConst,
  });
  factory Filter.fromJson(Map<String, dynamic> json) => _$FilterFromJson(json);

  final String type;
  final String? pattern;
  final Contains? contains;
  @JsonKey(name: 'const')
  String? containsConst;

  Map<String, dynamic> toJson() => _$FilterToJson(this);
}
