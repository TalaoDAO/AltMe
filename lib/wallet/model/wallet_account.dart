import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'wallet_account.g.dart';

@JsonSerializable()
class WalletAccount extends Equatable {
  const WalletAccount({
    this.mnemonics,
    required this.secretKey,
    required this.walletAddress,
  });

  factory WalletAccount.fromJson(Map<String, dynamic> json) =>
      _$WalletAccountFromJson(json);

  final String? mnemonics;
  final String secretKey;
  final String walletAddress;

  Map<String, dynamic> toJson() => _$WalletAccountToJson(this);

  @override
  List<Object?> get props => [mnemonics, secretKey, walletAddress];
}
