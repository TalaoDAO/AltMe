import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';

part 'display.g.dart';

@JsonSerializable()
@immutable
class Display extends Equatable {
  const Display(
    this.backgroundColor,
    this.icon,
    this.nameFallback,
    this.descriptionFallback,
  );

  factory Display.fromJson(Map<String, dynamic> json) =>
      _$DisplayFromJson(json);

  factory Display.emptyDisplay() => const Display('', '', '', '');

  @JsonKey(defaultValue: '')
  final String backgroundColor;
  @JsonKey(defaultValue: '')
  final String icon;
  @JsonKey(defaultValue: '')
  final String nameFallback;
  @JsonKey(defaultValue: '')
  final String descriptionFallback;

  Map<String, dynamic> toJson() => _$DisplayToJson(this);

  @override
  List<Object?> get props =>
      [backgroundColor, icon, nameFallback, descriptionFallback];
}
