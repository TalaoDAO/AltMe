import 'package:altme/app/shared/constants/urls.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'token_model.g.dart';

@JsonSerializable()
@immutable
class TokenModel extends Equatable {
  const TokenModel({
    required this.contractAddress,
    required this.name,
    required this.symbol,
    this.icon,
    this.thumbnailUri,
    required this.balance,
    required this.decimals,
    this.tokenUSDPrice = 0,
    this.balanceInUSD = 0,
    this.standard,
    this.tokenId = '0',
    this.decimalsToShow = 2,
  });

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
  @JsonKey(defaultValue: '0')
  final String decimals;
  @JsonKey(defaultValue: 0)
  final double tokenUSDPrice;
  @JsonKey(defaultValue: 0)
  final double balanceInUSD;
  final String? tokenId;
  final String? standard;
  final int decimalsToShow;

  Map<String, dynamic> toJson() => _$TokenModelToJson(this);

  TokenModel copyWith({
    String? contractAddress,
    String? symbol,
    String? name,
    String? icon,
    String? thumbnailUri,
    String? balance,
    String? decimals,
    double? tokenUSDPrice,
    double? balanceInUSD,
    String? tokenId,
    String? standard,
    int? decimalsToShow,
  }) {
    return TokenModel(
      contractAddress: contractAddress ?? this.contractAddress,
      name: name ?? this.name,
      symbol: symbol ?? this.symbol,
      balance: balance ?? this.balance,
      thumbnailUri: thumbnailUri ?? this.thumbnailUri,
      icon: icon ?? this.icon,
      decimals: decimals ?? this.decimals,
      tokenUSDPrice: tokenUSDPrice ?? this.tokenUSDPrice,
      balanceInUSD: balanceInUSD ?? this.balanceInUSD,
      tokenId: tokenId ?? this.tokenId,
      standard: standard ?? this.standard,
      decimalsToShow: decimalsToShow ?? this.decimalsToShow,
    );
  }

  bool get isFA1 => standard?.toLowerCase() == 'fa1.2';

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

  double get calculatedBalanceInDouble {
    return double.parse(calculatedBalance.replaceAll(',', ''));
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
  List<Object?> get props => [
        contractAddress,
        name,
        symbol,
        icon,
        thumbnailUri,
        balance,
        decimals,
        tokenUSDPrice,
        balanceInUSD,
        tokenId,
        standard,
        decimalsToShow,
      ];
}
