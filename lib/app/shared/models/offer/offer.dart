import 'package:json_annotation/json_annotation.dart';

part 'offer.g.dart';

@JsonSerializable()
class Offer {
  @JsonKey(defaultValue: '')
  final String value;
  @JsonKey(defaultValue: '')
  final String currency;

  factory Offer.fromJson(Map<String, dynamic> json) => _$OfferFromJson(json);

  Offer(this.value, this.currency);

  Map<String, dynamic> toJson() => _$OfferToJson(this);
}
