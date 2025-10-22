import 'package:altme/app/app.dart';
import 'package:json_annotation/json_annotation.dart';

part 'binance_network.g.dart';

@JsonSerializable()
class BinanceNetwork extends EthereumNetwork {
  BinanceNetwork({
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
         mainTokenName: 'Binance',
         mainTokenDecimal: '18',
         mainTokenIcon: IconStrings.binance,
         mainTokenSymbol: 'BNB',
       );

  factory BinanceNetwork.mainNet() => BinanceNetwork(
    type: BlockchainType.binance,
    networkname: 'Mainnet',
    apiUrl: Urls.moralisBaseUrl,
    chainId: 56,
    chain: 'bsc',
    rpcNodeUrl: 'https://bsc-dataseed.binance.org/',
    title: 'BNB Chain Mainnet',
    subTitle:
        'This network is the official BNB Chain blockchain running Network.'
        ' You should use this network by default.',
    isMainNet: true,
  );

  factory BinanceNetwork.testNet() => BinanceNetwork(
    type: BlockchainType.binance,
    networkname: 'Testnet',
    apiUrl: Urls.moralisBaseUrl,
    chainId: 97,
    chain: 'bsc testnet',
    rpcNodeUrl: 'https://bsc-testnet.public.blastapi.io',
    title: 'BNB Chain Testnet',
    subTitle:
        'This network is used to test protocol upgrades'
        ' (do not use it unless you are a developer).',
    isMainNet: false,
  );
}
