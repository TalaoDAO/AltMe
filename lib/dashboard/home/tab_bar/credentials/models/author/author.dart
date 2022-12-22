import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';

part 'author.g.dart';

@JsonSerializable()
@immutable
class Author extends Equatable {
  const Author(this.name);

  factory Author.fromJson(Map<String, dynamic> json) => _$AuthorFromJson(json);

  @JsonKey(defaultValue: '')
  final String name;

  Map<String, dynamic> toJson() => _$AuthorToJson(this);

  @override
  List<Object?> get props => [name];
}
