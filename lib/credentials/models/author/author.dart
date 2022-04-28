import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';

part 'author.g.dart';

@JsonSerializable()
@immutable
class Author extends Equatable {
  const Author(this.name, this.logo);

  factory Author.fromJson(Map<String, dynamic> json) => _$AuthorFromJson(json);

  @JsonKey(defaultValue: '')
  final String name;
  @JsonKey(defaultValue: '')
  final String logo;

  Map<String, dynamic> toJson() => _$AuthorToJson(this);

  @override
  List<Object?> get props => [name, logo];
}
