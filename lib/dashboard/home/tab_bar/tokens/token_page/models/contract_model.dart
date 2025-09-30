import 'package:altme/app/shared/constants/urls.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'contract_model.g.dart';

@JsonSerializable()
class ContractModel extends Equatable {
  const ContractModel({
    required this.id,
    required this.symbol,
    required this.image,
    required this.name,
    required this.currentPrice,
  });

  factory ContractModel.fromJson(Map<String, dynamic> json) =>
      _$ContractModelFromJson(json);

  final String id;
  final String symbol;
  final String? name;
  final String? image;
  final double? currentPrice;

  Map<String, dynamic> toJson() => _$ContractModelToJson(this);

  String? get iconUrl {
    return image?.replaceFirst('ipfs://', Urls.ipfsGateway);
  }

  @override
  List<Object?> get props => [id, symbol, name, image];
}
