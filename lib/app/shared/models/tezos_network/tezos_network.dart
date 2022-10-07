import 'package:altme/app/shared/constants/urls.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tezos_network.g.dart';

@JsonSerializable()
class TezosNetwork {
  const TezosNetwork({
    required this.networkname,
    required this.tzktUrl,
    required this.rpcNodeUrl,
    required this.description,
    this.apiKey = '',
  });

  factory TezosNetwork.fromJson(Map<String, dynamic> json) =>
      _$TezosNetworkFromJson(json);

  factory TezosNetwork.mainNet() => const TezosNetwork(
        networkname: 'Mainnet',
        tzktUrl: Urls.tzktMainnetUrl,
        rpcNodeUrl: Urls.mainnetRPC,
        description: 'Tezos Main Network',
      );

  factory TezosNetwork.ghostnet() => const TezosNetwork(
        networkname: 'Ghostnet',
        tzktUrl: Urls.tzktGhostnetUrl,
        rpcNodeUrl: Urls.ghostnetRPC,
        description: 'Tezos Test Network',
      );

  final String networkname;
  final String tzktUrl;
  final String apiKey;
  final String rpcNodeUrl;
  final String description;

  Map<String, dynamic> toJson() => _$TezosNetworkToJson(this);

  @override
  String toString() {
    return 'TezosNetwork{networkName: $networkname,tzktUrl: $tzktUrl, '
        'rpcNodeUrl: $rpcNodeUrl, apiKey: $apiKey ,description:$description}';
  }
}
