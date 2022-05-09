import '../index.dart';

class ReviewModel {
  final String name;
  final List<TranslationModel> reviewBody;
  final ReviewRatingModel reviewRating;
  final String type;

  ReviewModel(this.name, this.reviewBody, this.reviewRating, this.type);
}
