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
    String? animationUrl,
    String? image,
    String? description,
    required this.type,
  }) : super(
          name: name,
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

  Map<String, dynamic> toJson() => _$EthereumNftModelToJson(this);

  @override
  TokenModel getToken() {
    return TokenModel(
      contractAddress: contractAddress,
      name: name,
      symbol: name,
      balance: balance,
      standard: type,
      decimals: '0',
      tokenId: tokenId,
      id: -1,
    );
  }

  @override
  List<Object?> get props => [
        name,
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
