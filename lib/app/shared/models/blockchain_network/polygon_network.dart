import 'package:altme/app/app.dart';
import 'package:json_annotation/json_annotation.dart';

part 'polygon_network.g.dart';

@JsonSerializable()
class PolygonNetwork extends EthereumNetwork {
  const PolygonNetwork({
    required String networkname,
    required String apiUrl,
    required String rpcNodeUrl,
    required String title,
    required String subTitle,
    required int chainId,
    required String chain,
    required BlockchainType type,
    String apiKey = '',
  }) : super(
          networkname: networkname,
          apiUrl: apiUrl,
          rpcNodeUrl: rpcNodeUrl,
          title: title,
          subTitle: subTitle,
          apiKey: apiKey,
          type: type,
          chain: chain,
          chainId: chainId,
          mainTokenName: 'Polygon',
          mainTokenDecimal: '18',
          mainTokenIcon: IconStrings.polygon,
          mainTokenSymbol: 'Matic',
        );

  factory PolygonNetwork.mainNet() => const PolygonNetwork(
        type: BlockchainType.polygon,
        networkname: 'Mainnet',
        apiUrl: Urls.moralisBaseUrl,
        chainId: 137,
        chain: 'polygon',
        rpcNodeUrl: 'https://ethereum.publicnode.com',
        title: 'Polygon Mainnet',
        subTitle:
            'This network is the official Polygon blockchain running Network.'
            ' You should use this network by default.',
      );

  factory PolygonNetwork.testNet() => const PolygonNetwork(
        type: BlockchainType.polygon,
        networkname: 'Testnet',
        apiUrl: Urls.moralisBaseUrl,
        chainId: 80001,
        chain: 'mumbai',
        rpcNodeUrl: 'https://rpc-mumbai.maticvigil.com',
        title: 'Polygon Testnet (Mumbai)',
        subTitle: 'This network is used to test protocol upgrades'
            ' (do not use it unless you are a developer).',
      );
}
