import 'package:altme/dashboard/home/home.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tezos_nft_model.g.dart';

@JsonSerializable()
@immutable
class TezosNftModel extends NftModel {
  const TezosNftModel({
    required String name,
    String? displayUri,
    String? thumbnailUri,
    String? description,
    required String tokenId,
    required String contractAddress,
    required String balance,
    bool isTransferable = true,
    required this.id,
    String? symbol,
    this.standard,
    this.identifier,
    this.creators,
    this.publishers,
    this.date,
  }) : super(
          name: name,
          symbol: symbol,
          displayUri: displayUri,
          description: description,
          thumbnailUri: thumbnailUri,
          tokenId: tokenId,
          contractAddress: contractAddress,
          balance: balance,
          isTransferable: isTransferable,
        );

  factory TezosNftModel.fromJson(Map<String, dynamic> json) =>
      _$TezosNftModelFromJson(json);

  final String? standard;
  final int id;
  final String? identifier;
  final List<String>? creators;
  final List<String>? publishers;
  final String? date;

  @override
  Map<String, dynamic> toJson() => _$TezosNftModelToJson(this);

  TokenModel getToken() {
    return TokenModel(
      contractAddress: contractAddress,
      name: name,
      symbol: symbol ?? name,
      balance: balance,
      standard: standard ?? 'fa2',
      decimals: '0',
      tokenId: tokenId,
      decimalsToShow: 0,
    );
  }

  @override
  List<Object?> get props => [
        id,
        tokenId,
        name,
        symbol,
        displayUri,
        thumbnailUri,
        balance,
        description,
        identifier,
        publishers,
        creators,
        date,
        isTransferable,
      ];
}
