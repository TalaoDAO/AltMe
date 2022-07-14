import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'token_model.g.dart';

@JsonSerializable()
@immutable
class TokenModel extends Equatable {
  const TokenModel(
    this.contractAddress,
    this.name,
    this.symbol,
    this.icon,
    this.thumbnailUri,
    this.balance,
    this.decimals,
  );

  factory TokenModel.fromJson(Map<String, dynamic> json) =>
      _$TokenModelFromJson(json);

  @JsonKey(defaultValue: '')
  final String contractAddress;
  @JsonKey(defaultValue: '')
  final String symbol;
  @JsonKey(defaultValue: '')
  final String name;
  final String? icon;
  final String? thumbnailUri;
  final String balance;
  final String decimals;

  Map<String, dynamic> toJson() => _$TokenModelToJson(this);

  @override
  List<Object?> get props =>
      [contractAddress, name, symbol, icon, thumbnailUri, balance, decimals];
}
