import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'network_fee_model.g.dart';

enum NetworkSpeed { slow, average, fast }

@JsonSerializable()
class NetworkFeeModel extends Equatable {
  const NetworkFeeModel({
    required this.fee,
    this.feeInUSD = 0.0,
    this.tokenSymbol = 'XTZ',
    required this.networkSpeed,
  });

  factory NetworkFeeModel.fromJson(Map<String, dynamic> json) =>
      _$NetworkFeeModelFromJson(json);

  final double fee;
  final double feeInUSD;
  final String tokenSymbol;
  final NetworkSpeed networkSpeed;

  Map<String, dynamic> toJson() => _$NetworkFeeModelToJson(this);

  static List<NetworkFeeModel> networks() {
    return const [
      NetworkFeeModel(fee: 0.002496, networkSpeed: NetworkSpeed.slow),
      NetworkFeeModel(fee: 0.021900, networkSpeed: NetworkSpeed.average),
      NetworkFeeModel(fee: 0.050000, networkSpeed: NetworkSpeed.fast),
    ];
  }

  NetworkFeeModel copyWith({
    double? fee,
    double? feeInUSD,
    String? tokenSymbol,
    NetworkSpeed? networkSpeed,
  }) {
    return NetworkFeeModel(
      fee: fee ?? this.fee,
      networkSpeed: networkSpeed ?? this.networkSpeed,
      feeInUSD: feeInUSD ?? this.feeInUSD,
      tokenSymbol: tokenSymbol ?? this.tokenSymbol,
    );
  }

  @override
  List<Object?> get props => [fee, feeInUSD, tokenSymbol, networkSpeed];
}
