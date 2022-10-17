import 'package:altme/app/shared/constants/urls.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tezos_network.g.dart';

@JsonSerializable()
class TezosNetwork extends Equatable {
  const TezosNetwork({
    required this.networkname,
    required this.tzktUrl,
    required this.rpcNodeUrl,
    required this.title,
    required this.subTitle,
    this.apiKey = '',
  });

  factory TezosNetwork.fromJson(Map<String, dynamic> json) =>
      _$TezosNetworkFromJson(json);

  factory TezosNetwork.mainNet() => const TezosNetwork(
        networkname: 'Mainnet',
        tzktUrl: Urls.tzktMainnetUrl,
        rpcNodeUrl: Urls.mainnetRPC,
        title: 'Tezos Mainnet',
        subTitle:
            'This network is the official Tezos blockchain running Network.'
            ' You should use this network by default.',
      );

  factory TezosNetwork.ghostnet() => const TezosNetwork(
        networkname: 'Ghostnet',
        tzktUrl: Urls.tzktGhostnetUrl,
        rpcNodeUrl: Urls.ghostnetRPC,
        title: 'Tezos Ghostnet',
        subTitle: 'This network is used to test protocol upgrades'
            ' (do not use it unless you are a developer).',
      );

  final String networkname;
  final String tzktUrl;
  final String apiKey;
  final String rpcNodeUrl;
  final String title;
  final String subTitle;

  Map<String, dynamic> toJson() => _$TezosNetworkToJson(this);

  @override
  List<Object?> get props => [
        networkname,
        tzktUrl,
        apiKey,
        rpcNodeUrl,
        title,
        subTitle,
      ];

  @override
  String toString() {
    return 'TezosNetwork{networkName: $networkname,tzktUrl: $tzktUrl, '
        'rpcNodeUrl: $rpcNodeUrl, apiKey: $apiKey ,title:$title '
        ',subTitle:$subTitle}';
  }
}
