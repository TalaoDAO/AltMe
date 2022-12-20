import 'package:altme/app/app.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ethereum_network.g.dart';

@JsonSerializable()
class EthereumNetwork extends BlockchainNetwork {
  const EthereumNetwork({
    required String networkname,
    required String apiUrl,
    required String rpcNodeUrl,
    required String title,
    required String subTitle,
    String apiKey = '',
  }) : super(
          networkname: networkname,
          apiUrl: apiUrl,
          rpcNodeUrl: rpcNodeUrl,
          title: title,
          subTitle: subTitle,
          apiKey: apiKey,
        );

  factory EthereumNetwork.fromJson(Map<String, dynamic> json) =>
      _$EthereumNetworkFromJson(json);

  Map<String, dynamic> toJson() => _$EthereumNetworkToJson(this);
}
