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
      NetworkFeeModel(fee: 0.001250, networkSpeed: NetworkSpeed.slow),
      NetworkFeeModel(fee: 0.002496, networkSpeed: NetworkSpeed.average),
      NetworkFeeModel(fee: 0.021900, networkSpeed: NetworkSpeed.fast),
    ];
  }

  @override
  List<Object?> get props => [fee, feeInUSD, tokenSymbol, networkSpeed];
}
