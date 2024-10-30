// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'display_external_issuer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DisplayExternalIssuer _$DisplayExternalIssuerFromJson(
        Map<String, dynamic> json) =>
    DisplayExternalIssuer(
      name: json['name'] as String?,
      description: json['description'] as String?,
      category: json['category'] as String?,
      redirect: json['redirect'] as String?,
      background_url: json['background_url'] as String?,
      background_image: json['background_image'] as String?,
      logo: json['logo'] as String?,
      background_color: json['background_color'] as String?,
      text_color: json['text_color'] as String?,
      how_to_get_it: json['how_to_get_it'] as String?,
      issuer_id: json['issuer_id'] as String?,
      subtitle: json['subtitle'] as String?,
      validity_period: json['validity_period'] as String?,
      website: json['website'] as String?,
      why_get_this_card: json['why_get_this_card'] as String?,
      title: json['title'] as String?,
    );

Map<String, dynamic> _$DisplayExternalIssuerToJson(
        DisplayExternalIssuer instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'category': instance.category,
      'redirect': instance.redirect,
      'background_url': instance.background_url,
      'background_image': instance.background_image,
      'logo': instance.logo,
      'background_color': instance.background_color,
      'text_color': instance.text_color,
      'how_to_get_it': instance.how_to_get_it,
      'issuer_id': instance.issuer_id,
      'subtitle': instance.subtitle,
      'validity_period': instance.validity_period,
      'why_get_this_card': instance.why_get_this_card,
      'website': instance.website,
      'title': instance.title,
    };
