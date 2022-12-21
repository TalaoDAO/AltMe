import 'package:json_annotation/json_annotation.dart';

part 'issued_by.g.dart';

@JsonSerializable(explicitToJson: true)
class IssuedBy {
  IssuedBy(this.id, this.name);

  factory IssuedBy.fromJson(Map<String, dynamic> json) =>
      _$IssuedByFromJson(json);

  final String id;
  final String name;

  Map<String, dynamic> toJson() => _$IssuedByToJson(this);
}
