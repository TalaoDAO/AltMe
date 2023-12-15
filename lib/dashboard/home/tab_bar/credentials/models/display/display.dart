import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';

part 'display.g.dart';

@JsonSerializable()
@immutable
class Display extends Equatable {
  const Display(
    this.nameFallback,
    this.descriptionFallback,
    this.backgroundColor,
    this.textColor,
    this.icon,
  );

  factory Display.fromJson(Map<String, dynamic> json) =>
      _$DisplayFromJson(json);

  @JsonKey(defaultValue: '')
  final String backgroundColor;
  @JsonKey(defaultValue: '')
  final String icon;
  @JsonKey(defaultValue: '')
  final String nameFallback;
  @JsonKey(defaultValue: '')
  final String textColor;
  @JsonKey(defaultValue: '')
  final String descriptionFallback;

  Map<String, dynamic> toJson() => _$DisplayToJson(this);

  @override
  List<Object?> get props =>
      [backgroundColor, icon, nameFallback, textColor, descriptionFallback];
}
