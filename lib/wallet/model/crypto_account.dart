import 'package:altme/wallet/model/crypto_account_data.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'crypto_account.g.dart';

@JsonSerializable()
class CryptoAccount extends Equatable {
  CryptoAccount({
    List<CryptoAccountData>? data,
  }) : data = data ?? [];

  factory CryptoAccount.fromJson(Map<String, dynamic> json) =>
      _$CryptoAccountFromJson(json);

  final List<CryptoAccountData> data;

  Map<String, dynamic> toJson() => _$CryptoAccountToJson(this);

  @override
  List<Object?> get props => [data];
}
