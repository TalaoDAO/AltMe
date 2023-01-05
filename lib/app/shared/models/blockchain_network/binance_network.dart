import 'package:altme/app/app.dart';
import 'package:json_annotation/json_annotation.dart';

part 'binance_network.g.dart';

@JsonSerializable()
class BinanceNetwork extends EthereumNetwork {
  const BinanceNetwork({
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
        );

  factory BinanceNetwork.mainNet() => const BinanceNetwork(
        type: BlockchainType.binance,
        networkname: 'Mainnet',
        apiUrl: Urls.moralisBaseUrl,
        chainId: 56,
        chain: 'bsc',
        rpcNodeUrl: 'https://ethereum.publicnode.com',
        title: 'Binance Mainnet',
        subTitle:
            'This network is the official Binance blockchain running Network.'
            ' You should use this network by default.',
      );
}
