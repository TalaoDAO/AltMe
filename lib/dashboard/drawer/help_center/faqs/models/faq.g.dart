// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'faq.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FaqModel _$FaqModelFromJson(Map<String, dynamic> json) => FaqModel(
      faq: (json['faq'] as List<dynamic>)
          .map((e) => FaqElement.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FaqModelToJson(FaqModel instance) => <String, dynamic>{
      'faq': instance.faq,
    };

FaqElement _$FaqElementFromJson(Map<String, dynamic> json) => FaqElement(
      que: json['que'] as String,
      ans: json['ans'] as String,
      href: json['href'] as String?,
    );

Map<String, dynamic> _$FaqElementToJson(FaqElement instance) =>
    <String, dynamic>{
      'que': instance.que,
      'ans': instance.ans,
      'href': instance.href,
    };
