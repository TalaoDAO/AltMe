import 'package:altme/app/app.dart';
import 'package:json_annotation/json_annotation.dart';

part 'etherlink_network.g.dart';

@JsonSerializable()
class EtherlinkNetwork extends EthereumNetwork {
  const EtherlinkNetwork({
    required super.networkname,
    required super.apiUrl,
    required super.rpcNodeUrl,
    required super.title,
    required super.subTitle,
    required super.chainId,
    required super.chain,
    required super.type,
    super.apiKey,
  }) : super(
          mainTokenName: 'Etherlink',
          mainTokenDecimal: '18',
          mainTokenIcon: IconStrings.etherlink,
          mainTokenSymbol: 'XTZ',
        );

  factory EtherlinkNetwork.mainNet() => const EtherlinkNetwork(
        type: BlockchainType.etherlink,
        networkname: 'Mainnet',
        apiUrl: Urls.moralisBaseUrl,
        chainId: 42793,
        chain: 'etherlink',
        rpcNodeUrl: 'https://explorer.etherlink.com',
        title: 'Etherlink Mainnet',
        subTitle:
            'This network is the official Etherlink blockchain running Network.'
            ' You should use this network by default.',
      );

  factory EtherlinkNetwork.testNet() => const EtherlinkNetwork(
        type: BlockchainType.etherlink,
        networkname: 'Ghostnet',
        apiUrl: Urls.moralisBaseUrl,
        chain: 'etherlink-testnet',
        chainId: 128123,
        rpcNodeUrl: 'https://testnet.explorer.etherlink.com/',
        title: 'Etherlink Testnet (Ghostnet)',
        subTitle: 'This network is used to test protocol upgrades'
            ' (do not use it unless you are a developer).',
      );
}
