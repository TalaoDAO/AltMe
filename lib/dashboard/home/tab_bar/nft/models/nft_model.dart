import 'package:altme/app/shared/constants/urls.dart';
import 'package:altme/dashboard/home/home.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'nft_model.g.dart';

@JsonSerializable()
@immutable
class NftModel extends Equatable {
  const NftModel(
    this.id,
    this.name,
    this.displayUri,
    this.balance,
    this.description,
    this.tokenId,
    this.symbol,
    this.contractAddress,
    this.standard,
  );

  factory NftModel.fromJson(Map<String, dynamic> json) =>
      _$NftModelFromJson(json);

  @JsonKey(defaultValue: '0')
  final String tokenId;
  @JsonKey(defaultValue: '')
  final String name;
  @JsonKey(defaultValue: '')
  final String displayUri;
  final String balance;
  final String? description;
  final String? standard;
  final int id;
  final String? symbol;
  final String contractAddress;

  Map<String, dynamic> toJson() => _$NftModelToJson(this);

  String get displayUrl => displayUri.replaceAll(
        'ipfs://',
        Urls.talaoIpfsGateway,
      );

  TokenModel getToken() {
    return TokenModel(
      contractAddress: contractAddress,
      name: name,
      symbol: symbol ?? name,
      balance: balance,
      standard: standard ?? 'fa2',
      decimals: '0',
      tokenId: tokenId,
      id: id,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        displayUri,
        balance,
        description,
      ];
}
