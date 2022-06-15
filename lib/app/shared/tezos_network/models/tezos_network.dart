import 'package:json_annotation/json_annotation.dart';

part 'tezos_network.g.dart';

@JsonSerializable()
class TezosNetwork {
  const TezosNetwork(this.networkname, this.tzktUrl, this.apiKey);

  factory TezosNetwork.fromJson(Map<String, dynamic> json) =>
      _$TezosNetworkFromJson(json);

  factory TezosNetwork.mainNet() =>
      const TezosNetwork('mainnet', 'https://api.tzkt.io', '');
  factory TezosNetwork.ithacaNet() =>
      const TezosNetwork('ithacanet', 'https://api.ithacanet.tzkt.io', '');

  final String networkname;
  final String tzktUrl;
  final String apiKey;

  Map<String, dynamic> toJson() => _$TezosNetworkToJson(this);
}
