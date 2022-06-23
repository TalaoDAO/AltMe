import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:key_generator/key_generator.dart';

part 'crypto_account.g.dart';

@JsonSerializable()
class CryptoAccount extends Equatable {
  const CryptoAccount({
    this.name = '',
    this.mnemonics,
    required this.key,
    required this.secretKey,
    required this.walletAddress,
  });

  factory CryptoAccount.fromJson(Map<String, dynamic> json) =>
      _$CryptoAccountFromJson(json);

  final String? name;
  final String? mnemonics;
  final String key;
  final String secretKey;
  final String walletAddress;

  Map<String, dynamic> toJson() => _$CryptoAccountToJson(this);

  @override
  List<Object?> get props => [name, mnemonics, key, secretKey, walletAddress];
}
