import 'package:json_annotation/json_annotation.dart';

part 'filter.g.dart';

@JsonSerializable(explicitToJson: true)
class Filter {
  Filter(this.type, this.pattern);
  factory Filter.fromJson(Map<String, dynamic> json) => _$FilterFromJson(json);

  final String type;
  final String pattern;

  Map<String, dynamic> toJson() => _$FilterToJson(this);
}
