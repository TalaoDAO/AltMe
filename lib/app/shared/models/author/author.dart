import 'package:json_annotation/json_annotation.dart';

part 'author.g.dart';

@JsonSerializable()
class Author {
  Author(this.name, this.logo);

  factory Author.fromJson(Map<String, dynamic> json) => _$AuthorFromJson(json);

  @JsonKey(defaultValue: '')
  final String name;
  @JsonKey(defaultValue: '')
  final String logo;

  Map<String, dynamic> toJson() => _$AuthorToJson(this);
}
