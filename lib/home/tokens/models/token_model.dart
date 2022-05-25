import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'token_model.g.dart';

@JsonSerializable()
@immutable
class TokenModel extends Equatable {
  const TokenModel(
    this.contract,
    this.name,
    this.symbol,
    this.logoPath,
    this.balance,
  );

  factory TokenModel.fromJson(Map<String, dynamic> json) =>
      _$TokenModelFromJson(json);

  @JsonKey(defaultValue: '')
  final String contract;
  @JsonKey(defaultValue: '')
  final String symbol;
  @JsonKey(defaultValue: '')
  final String name;
  @JsonKey(defaultValue: '')
  final String logoPath;
  final int balance;

  Map<String, dynamic> toJson() => _$TokenModelToJson(this);

  @override
  List<Object?> get props => [contract, name, symbol, logoPath, balance];
}
