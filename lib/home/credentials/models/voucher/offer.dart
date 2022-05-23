import 'package:json_annotation/json_annotation.dart';

part 'offer.g.dart';

@JsonSerializable()
class Offer {
  Offer(this.value, this.currency);

  factory Offer.fromJson(Map<String, dynamic> json) => _$OfferFromJson(json);

  @JsonKey(defaultValue: '')
  final String value;
  @JsonKey(defaultValue: '')
  final String currency;

  Map<String, dynamic> toJson() => _$OfferToJson(this);
}
