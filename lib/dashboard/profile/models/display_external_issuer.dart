import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'display_external_issuer.g.dart';

@JsonSerializable()
class DisplayExternalIssuer extends Equatable {
  const DisplayExternalIssuer({
    this.name, //title
    this.description, //subtitle
    this.category,
    this.redirect,
    this.background_url,
    this.logo,
    this.background_color,
    this.text_color,
    this.how_to_get_it,
    this.issuer_id,
    this.subtitle,
    this.validity_period,
    this.website,
    this.why_get_this_card,
    this.title,
  });

  factory DisplayExternalIssuer.fromJson(Map<String, dynamic> json) =>
      _$DisplayExternalIssuerFromJson(json);

  final String? name;
  final String? description;
  final String? category;
  final String? redirect;
  final String? background_url;
  final String? logo;
  final String? background_color;
  final String? text_color;
  final String? how_to_get_it;
  final String? issuer_id;
  final String? subtitle;
  final String? validity_period;
  final String? why_get_this_card;
  final String? website;
  final String? title;

  Map<String, dynamic> toJson() => _$DisplayExternalIssuerToJson(this);

  DisplayExternalIssuer copyWith({
    String? name,
    String? description,
    String? category,
    String? redirect,
    String? background_url,
    String? logo,
    String? background_color,
    String? text_color,
    String? how_to_get_it,
    String? issuer_id,
    String? subtitle,
    String? validity_period,
    String? why_get_this_card,
    String? website,
    String? title,
  }) =>
      DisplayExternalIssuer(
        name: name ?? this.name,
        description: description ?? this.description,
        category: category ?? this.category,
        redirect: redirect ?? this.redirect,
        background_url: background_url ?? this.background_url,
        logo: logo ?? this.logo,
        background_color: background_color ?? this.background_color,
        text_color: text_color ?? this.text_color,
        how_to_get_it: how_to_get_it ?? this.how_to_get_it,
        issuer_id: issuer_id ?? this.issuer_id,
        subtitle: subtitle ?? this.subtitle,
        validity_period: validity_period ?? validity_period,
        why_get_this_card: why_get_this_card ?? this.why_get_this_card,
        website: website ?? this.website,
        title: title ?? this.title,
      );

  @override
  List<Object?> get props => [
        name,
        description,
        category,
        redirect,
        background_url,
        logo,
        background_color,
        text_color,
        how_to_get_it,
        issuer_id,
        subtitle,
        validity_period,
        why_get_this_card,
        website,
        title,
      ];
}
