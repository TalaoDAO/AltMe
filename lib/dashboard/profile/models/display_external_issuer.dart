import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'display_external_issuer.g.dart';

@JsonSerializable()
class DisplayExternalIssuer extends Equatable {
  const DisplayExternalIssuer({
    this.name,
    this.description,
    this.category,
    this.redirect,
    this.background_image,
    this.logo,
    this.background_color,
    this.text_color,
  });

  factory DisplayExternalIssuer.fromJson(Map<String, dynamic> json) =>
      _$DisplayExternalIssuerFromJson(json);

  final String? name;
  final String? description;
  final String? category;
  final String? redirect;
  final String? background_image;
  final String? logo;
  final String? background_color;
  final String? text_color;

  Map<String, dynamic> toJson() => _$DisplayExternalIssuerToJson(this);

  DisplayExternalIssuer copyWith({
    String? name,
    String? description,
    String? category,
    String? redirect,
    String? background_image,
    String? logo,
    String? background_color,
    String? text_color,
  }) =>
      DisplayExternalIssuer(
        name: name ?? this.name,
        description: description ?? this.description,
        category: category ?? this.category,
        redirect: redirect ?? this.redirect,
        background_image: background_image ?? this.background_image,
        logo: logo ?? this.logo,
        background_color: background_color ?? this.background_color,
        text_color: text_color ?? this.text_color,
      );

  @override
  List<Object?> get props => [
        name,
        description,
        category,
        redirect,
        background_image,
        logo,
        background_color,
        text_color,
      ];
}
