import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'crypto_account_data.g.dart';

@JsonSerializable()
class CryptoAccountData extends Equatable {
  CryptoAccountData({
    this.name = '',
    this.mnemonics,
    required this.key,
    required this.secretKey,
    required this.walletAddress,
  });

  factory CryptoAccountData.fromJson(Map<String, dynamic> json) =>
      _$CryptoAccountDataFromJson(json);

  String name;
  final String? mnemonics;
  final String key;
  final String secretKey;
  final String walletAddress;

  Map<String, dynamic> toJson() => _$CryptoAccountDataToJson(this);

  @override
  List<Object?> get props => [name, mnemonics, key, secretKey, walletAddress];
}
