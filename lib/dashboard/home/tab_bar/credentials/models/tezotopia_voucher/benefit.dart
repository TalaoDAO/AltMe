import 'package:json_annotation/json_annotation.dart';

part 'benefit.g.dart';

@JsonSerializable(explicitToJson: true)
class Benefit {
  Benefit({
    this.category,
    this.discount,
  });

  factory Benefit.fromJson(Map<String, dynamic> json) =>
      _$BenefitFromJson(json);

  final String? category;
  final String? discount;

  Map<String, dynamic> toJson() => _$BenefitToJson(this);
}
