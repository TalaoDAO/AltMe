import 'dart:convert';

import 'package:altme/dashboard/home/home.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tezos_nft_model.g.dart';

@JsonSerializable()
@immutable
class TezosNftModel extends NftModel {
  const TezosNftModel({
    required super.name,
    super.displayUri,
    super.thumbnailUri,
    super.description,
    required super.tokenId,
    required super.contractAddress,
    required super.balance,
    super.isTransferable,
    required this.id,
    super.symbol,
    this.standard,
    this.identifier,
    this.mCreators,
    this.mPublishers,
    this.date,
  });

  factory TezosNftModel.fromJson(Map<String, dynamic> json) =>
      _$TezosNftModelFromJson(json);

  final String? standard;
  final int id;
  final String? identifier;
  @JsonKey(name: 'creators')
  final dynamic mCreators;
  @JsonKey(name: 'publishers')
  final dynamic mPublishers;
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

  List<String>? get creators {
    try {
      if (mCreators is String) {
        return (jsonDecode(mCreators as String) as List<dynamic>)
            .map((dynamic e) => e.toString())
            .toList();
      } else if (mCreators is List<String>) {
        return mCreators as List<String>;
      } else {
        return null;
      }
    } catch (_) {
      return null;
    }
  }

  List<String>? get publishers {
    try {
      if (mPublishers is String) {
        return (jsonDecode(mPublishers as String) as List<dynamic>)
            .map((dynamic e) => e.toString())
            .toList();
      } else if (mPublishers is List<String>) {
        return mPublishers as List<String>;
      } else {
        return null;
      }
    } catch (_) {
      return null;
    }
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
        mPublishers,
        mCreators,
        date,
        isTransferable,
      ];
}
