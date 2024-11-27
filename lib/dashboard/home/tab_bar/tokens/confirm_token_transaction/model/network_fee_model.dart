import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'network_fee_model.g.dart';

enum NetworkSpeed { slow, average, fast }

@JsonSerializable()
class NetworkFeeModel extends Equatable {
  const NetworkFeeModel({
    required this.totalFee,
    required this.networkSpeed,
    this.feeInUSD = 0.0,
    this.tokenSymbol = 'XTZ',
    this.bakerFee,
  });

  factory NetworkFeeModel.fromJson(Map<String, dynamic> json) =>
      _$NetworkFeeModelFromJson(json);

  final String totalFee;
  final String? bakerFee;
  final double feeInUSD;
  final String tokenSymbol;
  final NetworkSpeed networkSpeed;

  Map<String, dynamic> toJson() => _$NetworkFeeModelToJson(this);

  NetworkFeeModel copyWith({
    String? totalFee,
    String? bakerFee,
    double? feeInUSD,
    String? tokenSymbol,
    NetworkSpeed? networkSpeed,
  }) {
    return NetworkFeeModel(
      totalFee: totalFee ?? this.totalFee,
      bakerFee: bakerFee ?? this.bakerFee,
      networkSpeed: networkSpeed ?? this.networkSpeed,
      feeInUSD: feeInUSD ?? this.feeInUSD,
      tokenSymbol: tokenSymbol ?? this.tokenSymbol,
    );
  }

  @override
  List<Object?> get props => [totalFee, feeInUSD, tokenSymbol, networkSpeed];
}
