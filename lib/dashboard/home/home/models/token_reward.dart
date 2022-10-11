import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'token_reward.g.dart';

@JsonSerializable()
class TokenReward extends Equatable {
  const TokenReward({
    required this.amount,
    required this.symbol,
    required this.name,
  });

  factory TokenReward.fromJson(Map<String, dynamic> json) =>
      _$TokenRewardFromJson(json);

  final double amount;
  final String symbol;
  final String name;

  Map<String, dynamic> toJson() => _$TokenRewardToJson(this);

  @override
  List<Object?> get props => [
        amount,
        symbol,
        name,
      ];
}
