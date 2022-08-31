import 'package:altme/app/shared/constants/urls.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tezos_network.g.dart';

@JsonSerializable()
class TezosNetwork {
  const TezosNetwork({
    required this.networkname,
    required this.tzktUrl,
    required this.rpcNodeUrl,
    this.apiKey = '',
  });

  factory TezosNetwork.fromJson(Map<String, dynamic> json) =>
      _$TezosNetworkFromJson(json);

  factory TezosNetwork.mainNet() => const TezosNetwork(
        networkname: 'Mainnet',
        tzktUrl: 'https://api.tzkt.io',
        rpcNodeUrl: Urls.mainnetRPC,
      );

  factory TezosNetwork.ghostnet() => const TezosNetwork(
        networkname: 'Ghostnet',
        tzktUrl: 'https://api.ghostnet.tzkt.io',
        rpcNodeUrl: Urls.ghostnetRPC,
      );

  final String networkname;
  final String tzktUrl;
  final String apiKey;
  final String rpcNodeUrl;

  Map<String, dynamic> toJson() => _$TezosNetworkToJson(this);

  @override
  String toString() {
    // ignore: lines_longer_than_80_chars
    return 'TezosNetwork{networkName: $networkname, tzktUrl: $tzktUrl, rpcNodeUrl: $rpcNodeUrl , apiKey: $apiKey}';
  }
}
