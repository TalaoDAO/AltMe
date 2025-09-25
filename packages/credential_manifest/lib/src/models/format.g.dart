// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'format.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Format _$FormatFromJson(Map<String, dynamic> json) => Format(
  jwtVp: json['jwt_vp'] == null
      ? null
      : FormatType.fromJson(json['jwt_vp'] as Map<String, dynamic>),
  jwtVc: json['jwt_vc'] == null
      ? null
      : FormatType.fromJson(json['jwt_vc'] as Map<String, dynamic>),
  jwtVpJson: json['jwt_vp_json'] == null
      ? null
      : FormatType.fromJson(json['jwt_vp_json'] as Map<String, dynamic>),
  jwtVcJson: json['jwt_vc_json'] == null
      ? null
      : FormatType.fromJson(json['jwt_vc_json'] as Map<String, dynamic>),
  ldpVp: json['ldp_vp'] == null
      ? null
      : FormatType.fromJson(json['ldp_vp'] as Map<String, dynamic>),
  ldpVc: json['ldp_vc'] == null
      ? null
      : FormatType.fromJson(json['ldp_vc'] as Map<String, dynamic>),
  vcSdJwt: json['vc+sd-jwt'] == null
      ? null
      : FormatType.fromJson(json['vc+sd-jwt'] as Map<String, dynamic>),
  jwtVcJsonLd: json['jwt_vc_json_ld'] == null
      ? null
      : FormatType.fromJson(json['jwt_vc_json_ld'] as Map<String, dynamic>),
  jwtVpJsonLd: json['jwt_vp_json_ld'] == null
      ? null
      : FormatType.fromJson(json['jwt_vp_json_ld'] as Map<String, dynamic>),
  dcSdJwt: json['dc+sd-jwt'] == null
      ? null
      : FormatType.fromJson(json['dc+sd-jwt'] as Map<String, dynamic>),
);

Map<String, dynamic> _$FormatToJson(Format instance) => <String, dynamic>{
  'jwt_vp': instance.jwtVp?.toJson(),
  'jwt_vc': instance.jwtVc?.toJson(),
  'jwt_vp_json': instance.jwtVpJson?.toJson(),
  'jwt_vc_json': instance.jwtVcJson?.toJson(),
  'jwt_vp_json_ld': instance.jwtVpJsonLd?.toJson(),
  'jwt_vc_json_ld': instance.jwtVcJsonLd?.toJson(),
  'ldp_vp': instance.ldpVp?.toJson(),
  'ldp_vc': instance.ldpVc?.toJson(),
  'vc+sd-jwt': instance.vcSdJwt?.toJson(),
  'dc+sd-jwt': instance.dcSdJwt?.toJson(),
};
