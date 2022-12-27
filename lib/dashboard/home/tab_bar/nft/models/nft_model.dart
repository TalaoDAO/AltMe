import 'package:altme/app/app.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'nft_model.g.dart';

@JsonSerializable()
@immutable
class NftModel extends Equatable {
  const NftModel({
    required this.tokenId,
    required this.name,
    this.symbol,
    required this.contractAddress,
    required this.balance,
    this.description,
    this.displayUri,
    this.thumbnailUri,
    this.isTransferable = true,
  });

  factory NftModel.fromJson(Map<String, dynamic> json) =>
      _$NftModelFromJson(json);

  @JsonKey(defaultValue: '')
  final String name;
  final String? symbol;
  @JsonKey(defaultValue: '0')
  final String tokenId;
  final String? description;
  final String? displayUri;
  final String? thumbnailUri;
  final String contractAddress;
  final String balance;
  final bool isTransferable;

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

  Map<String, dynamic> toJson() => _$NftModelToJson(this);

  @override
  List<Object?> get props => [
        name,
        symbol,
        tokenId,
        description,
        displayUri,
        thumbnailUri,
        contractAddress,
        balance,
        isTransferable,
      ];
}
