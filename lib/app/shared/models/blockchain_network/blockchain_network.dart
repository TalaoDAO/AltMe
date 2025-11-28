import 'package:altme/app/app.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'blockchain_network.g.dart';

@JsonSerializable()
class BlockchainNetwork extends Equatable {
  const BlockchainNetwork({
    required this.networkname,
    required this.apiUrl,
    required this.rpcNodeUrl,
    required this.title,
    required this.subTitle,
    required this.type,
    required this.isMainNet,
    required this.chainId,
    this.apiKey = '',
  });

  factory BlockchainNetwork.fromJson(Map<String, dynamic> json) =>
      _$BlockchainNetworkFromJson(json);

  Map<String, dynamic> toJson() => _$BlockchainNetworkToJson(this);

  final String networkname;
  final String apiUrl;
  final String apiKey;
  final dynamic rpcNodeUrl;
  final String? title;
  final String? subTitle;
  final BlockchainType type;
  final bool isMainNet;
  final int chainId;

  @override
  List<Object?> get props => [
    networkname,
    apiUrl,
    rpcNodeUrl,
    title,
    subTitle,
    type,
    isMainNet,
    chainId,
    apiKey,
  ];

  @override
  String toString() {
    return 'BlockchainNetwork{networkName: $networkname,apiUrl: $apiUrl, '
        'rpcNodeUrl: $rpcNodeUrl, apiKey: $apiKey ,title:$title '
        ',subTitle:$subTitle, type: $type}';
  }

  Future<void> openBlockchainExplorer(String txHash) async {
    if (this is TezosNetwork) {
      await LaunchUrl.launch('https://tzkt.io/$txHash');
    } else if (this is PolygonNetwork) {
      await LaunchUrl.launch('https://polygonscan.com/tx/$txHash');
    } else if (this is BinanceNetwork) {
      await LaunchUrl.launch('https://www.bscscan.com/tx/$txHash');
    } else if (this is FantomNetwork) {
      await LaunchUrl.launch('https://ftmscan.com/tx/$txHash');
    } else if (this is EthereumNetwork) {
      if (isMainNet) {
        await LaunchUrl.launch('https://etherscan.io/tx/$txHash');
        return;
      }
      await LaunchUrl.launch('https://sepolia.etherscan.io/tx/$txHash');
    } else {
      UnimplementedError();
    }
  }

  Future<void> openAddressBlockchainExplorer(String address) async {
    if (this is TezosNetwork) {
      await LaunchUrl.launch('https://tzkt.io/$address/operations');
    } else if (this is PolygonNetwork) {
      await LaunchUrl.launch('https://polygonscan.com/address/$address');
    } else if (this is BinanceNetwork) {
      await LaunchUrl.launch('https://www.bscscan.com/address/$address');
    } else if (this is FantomNetwork) {
      await LaunchUrl.launch('https://ftmscan.com/address/$address');
    } else if (this is EthereumNetwork) {
      await LaunchUrl.launch('https://etherscan.io/address/$address');
    } else {
      UnimplementedError();
    }
  }
}
