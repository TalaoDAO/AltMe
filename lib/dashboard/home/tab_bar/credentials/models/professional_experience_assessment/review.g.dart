// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Review _$ReviewFromJson(Map<String, dynamic> json) => Review(
      json['name'] as String? ?? '',
      (json['reviewBody'] as List<dynamic>?)
              ?.map((e) => Translation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      Review._reviewRatingFromJson(json['reviewRating']),
      json['type'] as String? ?? '',
    );

Map<String, dynamic> _$ReviewToJson(Review instance) => <String, dynamic>{
      'name': instance.name,
      'reviewBody': instance.reviewBody.map((e) => e.toJson()).toList(),
      'reviewRating': instance.reviewRating.toJson(),
      'type': instance.type,
    };
