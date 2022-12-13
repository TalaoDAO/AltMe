import 'package:altme/app/shared/constants/urls.dart';
import 'package:altme/dashboard/home/home.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'nft_model.g.dart';

@JsonSerializable()
@immutable
class NftModel extends Equatable {
  const NftModel({
    required this.id,
    required this.name,
    this.displayUri,
    this.thumbnailUri,
    required this.balance,
    this.description,
    required this.tokenId,
    this.symbol,
    required this.contractAddress,
    this.standard,
    this.identifier,
    this.creators,
    this.publishers,
    this.date,
    this.isTransferable,
  });

  factory NftModel.fromJson(Map<String, dynamic> json) =>
      _$NftModelFromJson(json);

  @JsonKey(defaultValue: '0')
  final String tokenId;
  @JsonKey(defaultValue: '')
  final String name;
  final String? displayUri;
  final String? thumbnailUri;
  final String balance;
  final String? description;
  final String? standard;
  final int id;
  final String? symbol;
  final String contractAddress;
  final String? identifier;
  final List<String>? creators;
  final List<String>? publishers;
  final String? date;
  final bool? isTransferable;

  Map<String, dynamic> toJson() => _$NftModelToJson(this);

  String? get displayUrl {
    if (displayUri?.isEmpty ?? true) {
      return null;
    }
    return displayUri?.replaceAll(
      'ipfs://',
      Urls.talaoIpfsGateway,
    );
  }

  String? get thumbnailUrl {
    if (thumbnailUri?.isEmpty ?? true) {
      return null;
    }
    return thumbnailUri?.replaceAll(
      'ipfs://',
      Urls.talaoIpfsGateway,
    );
  }

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
