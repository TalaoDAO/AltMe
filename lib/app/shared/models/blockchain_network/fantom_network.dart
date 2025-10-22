import 'package:altme/app/app.dart';
import 'package:json_annotation/json_annotation.dart';

part 'fantom_network.g.dart';

@JsonSerializable()
class FantomNetwork extends EthereumNetwork {
  FantomNetwork({
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
         mainTokenName: 'Fantom',
         mainTokenDecimal: '18',
         mainTokenIcon: IconStrings.fantom,
         mainTokenSymbol: 'FTM',
       );

  factory FantomNetwork.mainNet() => FantomNetwork(
    type: BlockchainType.fantom,
    networkname: 'Mainnet',
    apiUrl: Urls.moralisBaseUrl,
    chainId: 250,
    chain: 'fantom',
    rpcNodeUrl: 'https://rpcapi.fantom.network/',
    title: 'Fantom Mainnet',
    subTitle:
        'This network is the official Fantom blockchain running Network.'
        ' You should use this network by default.',
    isMainNet: true,
  );

  factory FantomNetwork.testNet() => FantomNetwork(
    type: BlockchainType.fantom,
    networkname: 'Testnet',
    apiUrl: Urls.moralisBaseUrl,
    chainId: 4002,
    chain: 'fantom',
    rpcNodeUrl: 'https://rpc.testnet.fantom.network',
    title: 'Fantom Testnet',
    subTitle:
        'This network is used to test protocol upgrades'
        ' (do not use it unless you are a developer).',
    isMainNet: false,
  );
}
