import 'package:altme/app/shared/constants/urls.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'token_model.g.dart';

@JsonSerializable()
@immutable
class TokenModel extends Equatable {
  const TokenModel(
    this.contractAddress,
    this.name,
    this.symbol,
    this.icon,
    this.thumbnailUri,
    this.balance,
    this.decimals,
  );

  factory TokenModel.fromJson(Map<String, dynamic> json) =>
      _$TokenModelFromJson(json);

  @JsonKey(defaultValue: '')
  final String contractAddress;
  @JsonKey(defaultValue: '')
  final String symbol;
  @JsonKey(defaultValue: '')
  final String name;
  final String? icon;
  final String? thumbnailUri;
  final String balance;
  final String decimals;

  Map<String, dynamic> toJson() => _$TokenModelToJson(this);

  String get calculatedBalance {
    final formatter = NumberFormat('#,###');
    final priceString = balance;
    final decimalsNum = int.parse(decimals);
    if (decimalsNum == 0) {
      final intPart = formatter.format(double.parse(priceString));
      return '$intPart.0';
    } else if (decimalsNum == priceString.length) {
      return '0.$priceString';
    } else if (priceString.length < decimalsNum) {
      final numberOfZero = decimalsNum - priceString.length;
      // ignore: lines_longer_than_80_chars
      return '0.${List.generate(numberOfZero, (index) => '0').join()}$priceString';
    } else {
      final rightPart = formatter.format(
        double.parse(
          priceString.substring(0, priceString.length - decimalsNum),
        ),
      );
      final realDoublePriceInString =
          // ignore: lines_longer_than_80_chars
          '$rightPart.${priceString.substring(priceString.length - decimalsNum, priceString.length)}';
      return realDoublePriceInString;
    }
  }

  String? get iconUrl {
    final iconUrl = icon ?? thumbnailUri;
    if (iconUrl == null) {
      return null;
    } else {
      return iconUrl.replaceFirst('ipfs://', Urls.talaoIpfsGateway);
    }
  }

  @override
  List<Object?> get props =>
      [contractAddress, name, symbol, icon, thumbnailUri, balance, decimals];
}
