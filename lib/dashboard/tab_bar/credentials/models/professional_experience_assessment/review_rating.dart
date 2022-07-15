import 'package:json_annotation/json_annotation.dart';

part 'review_rating.g.dart';

@JsonSerializable(explicitToJson: true)
class ReviewRating {
  ReviewRating(this.bestRating, this.ratingValue, this.type, this.worstRating);

  factory ReviewRating.fromJson(Map<String, dynamic> json) =>
      _$ReviewRatingFromJson(json);

  @JsonKey(defaultValue: '')
  final String bestRating;
  @JsonKey(defaultValue: '')
  final String ratingValue;
  @JsonKey(defaultValue: '')
  final String type;
  @JsonKey(defaultValue: '')
  final String worstRating;

  Map<String, dynamic> toJson() => _$ReviewRatingToJson(this);
}
