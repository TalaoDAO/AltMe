import 'package:altme/dashboard/home/home.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ethereum_nft_model.g.dart';

@JsonSerializable()
@immutable
class EthereumNftModel extends NftModel {
  const EthereumNftModel({
    required String name,
    required String tokenId,
    required String contractAddress,
    required String balance,
    String? symbol,
    String? animationUrl,
    String? image,
    String? description,
    required this.type,
  }) : super(
          name: name,
          symbol: symbol,
          displayUri: animationUrl,
          description: description,
          thumbnailUri: image,
          tokenId: tokenId,
          contractAddress: contractAddress,
          balance: balance,
        );

  factory EthereumNftModel.fromJson(Map<String, dynamic> json) =>
      _$EthereumNftModelFromJson(json);

  final String type;

  @override
  Map<String, dynamic> toJson() => _$EthereumNftModelToJson(this);

  TokenModel getToken() {
    return TokenModel(
      contractAddress: contractAddress,
      name: name,
      symbol: symbol ?? name,
      balance: balance,
      standard: type,
      decimals: '0',
      tokenId: tokenId,
    );
  }

  @override
  List<Object?> get props => [
        name,
        symbol,
        tokenId,
        displayUri,
        thumbnailUri,
        description,
        contractAddress,
        balance,
        type,
        isTransferable,
      ];
}
