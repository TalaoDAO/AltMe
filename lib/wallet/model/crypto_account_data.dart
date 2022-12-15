// ignore_for_file: must_be_immutable

import 'package:altme/app/shared/enum/enum.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'crypto_account_data.g.dart';

@JsonSerializable()
class CryptoAccountData extends Equatable {
  CryptoAccountData({
    required this.name,
    required this.secretKey,
    required this.walletAddress,
    this.isImported = false,
    this.blockchainType = BlockchainType.tezos,
  });

  factory CryptoAccountData.fromJson(Map<String, dynamic> json) =>
      _$CryptoAccountDataFromJson(json);

  String name;
  final String secretKey;
  final String walletAddress;
  final bool isImported;
  final BlockchainType blockchainType;
  Map<String, dynamic> toJson() => _$CryptoAccountDataToJson(this);

  @override
  List<Object?> get props =>
      [name, secretKey, walletAddress, isImported, blockchainType];
}
