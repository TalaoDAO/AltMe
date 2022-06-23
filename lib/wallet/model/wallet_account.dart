import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:key_generator/key_generator.dart';

part 'wallet_account.g.dart';

@JsonSerializable()
class WalletAccount extends Equatable {
  const WalletAccount({
    this.name = '',
    this.mnemonics,
    required this.key,
    required this.secretKey,
    required this.walletAddress,
    required this.accountType,
  });

  factory WalletAccount.fromJson(Map<String, dynamic> json) =>
      _$WalletAccountFromJson(json);

  final String? name;
  final String? mnemonics;
  final String key;
  final String secretKey;
  final String walletAddress;
  final AccountType accountType;

  Map<String, dynamic> toJson() => _$WalletAccountToJson(this);

  @override
  List<Object?> get props => [name, mnemonics, key, secretKey, walletAddress];
}
