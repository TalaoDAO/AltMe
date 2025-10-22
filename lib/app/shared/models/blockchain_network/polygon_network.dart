import 'package:altme/app/app.dart';
import 'package:json_annotation/json_annotation.dart';

part 'polygon_network.g.dart';

@JsonSerializable()
class PolygonNetwork extends EthereumNetwork {
  PolygonNetwork({
    required super.networkname,
    required super.apiUrl,
    required super.rpcNodeUrl,
    required super.title,
    required super.subTitle,
    required super.chainId,
    required super.chain,
    required super.type,
    required super.isMainNet,
    super.apiKey,
  }) : super(
         mainTokenName: 'Polygon',
         mainTokenDecimal: '18',
         mainTokenIcon: IconStrings.polygon,
         mainTokenSymbol: 'MATIC',
       );

  factory PolygonNetwork.mainNet() => PolygonNetwork(
    type: BlockchainType.polygon,
    networkname: 'Mainnet',
    apiUrl: Urls.moralisBaseUrl,
    chainId: 137,
    chain: 'polygon',
    rpcNodeUrl: 'https://polygon-rpc.com/',
    title: 'Polygon Mainnet',
    subTitle:
        'This network is the official Polygon blockchain running Network.'
        ' You should use this network by default.',
    isMainNet: true,
  );

  factory PolygonNetwork.testNet() => PolygonNetwork(
    type: BlockchainType.polygon,
    networkname: 'Testnet',
    apiUrl: Urls.moralisBaseUrl,
    chainId: 80002,
    chain: 'polygon amoy',
    rpcNodeUrl: 'https://rpc-amoy.polygon.technology/',
    title: 'Polygon Amoy Testnet',
    subTitle:
        'This network is used to test protocol upgrades'
        ' (do not use it unless you are a developer).',
    isMainNet: false,
  );
}
