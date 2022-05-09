import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';

part 'work_for.g.dart';

@JsonSerializable()
@immutable
class WorkFor extends Equatable {
  const WorkFor(this.address, this.logo, this.name);

  factory WorkFor.fromJson(Map<String, dynamic> json) =>
      _$WorkForFromJson(json);

  @JsonKey(defaultValue: '')
  final String address;
  @JsonKey(defaultValue: '')
  final String logo;
  @JsonKey(defaultValue: '')
  final String name;

  Map<String, dynamic> toJson() => _$WorkForToJson(this);

  @override
  List<Object?> get props => [name, logo, address];
}
