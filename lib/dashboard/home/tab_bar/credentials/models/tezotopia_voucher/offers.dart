import 'package:altme/dashboard/home/tab_bar/credentials/models/tezotopia_voucher/benefit.dart';
import 'package:json_annotation/json_annotation.dart';

part 'offers.g.dart';

@JsonSerializable(explicitToJson: true)
class Offers {
  Offers({
    this.benefit,
  });

  factory Offers.fromJson(Map<String, dynamic> json) => _$OffersFromJson(json);

  final Benefit? benefit;

  Map<String, dynamic> toJson() => _$OffersToJson(this);
}
