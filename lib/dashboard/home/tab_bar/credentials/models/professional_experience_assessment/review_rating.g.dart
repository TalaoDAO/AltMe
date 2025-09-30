// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_rating.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewRating _$ReviewRatingFromJson(Map<String, dynamic> json) => ReviewRating(
      json['bestRating'] as String? ?? '',
      json['ratingValue'] as String? ?? '',
      json['type'] as String? ?? '',
      json['worstRating'] as String? ?? '',
    );

Map<String, dynamic> _$ReviewRatingToJson(ReviewRating instance) =>
    <String, dynamic>{
      'bestRating': instance.bestRating,
      'ratingValue': instance.ratingValue,
      'type': instance.type,
      'worstRating': instance.worstRating,
    };
