import 'package:json_annotation/json_annotation.dart';

part 'xtz_data.g.dart';

@JsonSerializable()
class XtzData {
  XtzData({
    this.price,
    this.price24H,
    this.marketCap,
    this.market24H,
    this.volume,
    this.volume24H,
    this.updated,
  });

  factory XtzData.fromJson(Map<String, dynamic> json) =>
      _$XtzDataFromJson(json);

  double? price;
  double? price24H;
  double? marketCap;
  double? market24H;
  double? volume;
  double? volume24H;
  DateTime? updated;

  Map<String, dynamic> toJson() => _$XtzDataToJson(this);
}
