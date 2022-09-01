import 'package:altme/app/shared/constants/urls.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'contract_model.g.dart';

@JsonSerializable()
class ContractModel extends Equatable {
  const ContractModel({
    required this.symbol,
    required this.address,
    required this.thumbnailUri,
    required this.decimals,
    required this.name,
    required this.currentPrice,
    required this.buyPrice,
    required this.sellPrice,
    required this.precision,
    required this.type,
    required this.totalSupply,
    required this.qptTokenSupply,
    required this.usdValue,
  });

  factory ContractModel.fromJson(Map<String, dynamic> json) =>
      _$ContractModelFromJson(json);

  final String symbol;
  final String address;
  final String? thumbnailUri;
  final int decimals;
  final String? name;
  final double currentPrice;
  final double buyPrice;
  final double sellPrice;
  final int precision;
  final String type;
  final double? totalSupply;
  final double? qptTokenSupply;
  final double usdValue;

  Map<String, dynamic> toJson() => _$ContractModelToJson(this);

  String? get iconUrl {
    return thumbnailUri?.replaceFirst('ipfs://', Urls.talaoIpfsGateway);
  }

  bool isEqualTo({required ContractModel contractModel}) {
    return address == contractModel.address;
  }

  @override
  List<Object?> get props => [
        symbol,
        address,
        thumbnailUri,
        decimals,
        name,
        currentPrice,
        buyPrice,
        sellPrice,
        precision,
        type,
        totalSupply,
        qptTokenSupply,
        usdValue,
      ];
}
