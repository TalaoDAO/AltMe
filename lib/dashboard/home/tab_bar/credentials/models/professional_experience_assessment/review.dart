import 'package:altme/app/shared/models/translation/translation.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/professional_experience_assessment/review_rating.dart';
import 'package:json_annotation/json_annotation.dart';

part 'review.g.dart';

@JsonSerializable(explicitToJson: true)
class Review {
  Review(this.name, this.reviewBody, this.reviewRating, this.type);

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);

  @JsonKey(defaultValue: '')
  final String name;
  @JsonKey(defaultValue: <Translation>[])
  final List<Translation> reviewBody;
  @JsonKey(fromJson: _reviewRatingFromJson)
  final ReviewRating reviewRating;
  @JsonKey(defaultValue: '')
  final String type;

  Map<String, dynamic> toJson() => _$ReviewToJson(this);

  static ReviewRating _reviewRatingFromJson(dynamic json) {
    if (json == null || json == '') {
      return ReviewRating('', '', '', '');
    }
    return ReviewRating.fromJson(json as Map<String, dynamic>);
  }
}
