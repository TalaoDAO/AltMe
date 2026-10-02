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
    this.artifactUri = '',
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
  @JsonKey(defaultValue: true)
  final bool isTransferable;
  @JsonKey(defaultValue: '')
  final String artifactUri;

  String? get displayUrl {
    if (displayUri?.isEmpty ?? true) {
      return null;
    }
    final resolvedDisplayUrl = displayUri?.replaceAll(
      'ipfs://',
      Urls.ipfsGateway,
    );
    return resolvedDisplayUrl;
  }

  String? get thumbnailUrl {
    if (thumbnailUri?.isEmpty ?? true) {
      return null;
    }
    final resolvedThumbnailUrl = thumbnailUri?.replaceAll(
      'ipfs://',
      Urls.ipfsGateway,
    );
    return resolvedThumbnailUrl;
  }

  String? get artifactUrl {
    if (artifactUri == '') {
      return null;
    }
    final resolvedArtifactUrl = artifactUri.replaceAll(
      'ipfs://',
      Urls.ipfsGateway,
    );
    return resolvedArtifactUrl;
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
