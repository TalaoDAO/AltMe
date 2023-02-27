import 'package:altme/dashboard/home/home.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ethereum_nft_model.g.dart';

@JsonSerializable()
@immutable
class EthereumNftModel extends NftModel {
  const EthereumNftModel({
    required super.name,
    required super.tokenId,
    required super.contractAddress,
    required super.balance,
    super.symbol,
    String? animationUrl,
    String? image,
    super.description,
    required this.type,
    this.minterAddress,
    this.lastMetadataSync,
  }) : super(
          displayUri: animationUrl,
          thumbnailUri: image,
        );

  factory EthereumNftModel.fromJson(Map<String, dynamic> json) =>
      _$EthereumNftModelFromJson(json);

  final String type;
  @JsonKey(name: 'minter_address')
  final String? minterAddress;
  @JsonKey(name: 'last_metadata_sync')
  final String? lastMetadataSync;

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
      decimalsToShow: 0,
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
        minterAddress,
        lastMetadataSync,
      ];
}
