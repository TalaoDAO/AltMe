import 'package:altme/app/app.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ethereum_network.g.dart';

@JsonSerializable()
class EthereumNetwork extends BlockchainNetwork {
  EthereumNetwork({
    required super.networkname,
    required super.apiUrl,
    required super.rpcNodeUrl,
    required String super.title,
    required String super.subTitle,
    required super.chainId,
    required this.chain,
    this.mainTokenName = 'Ethereum',
    this.mainTokenDecimal = '18',
    this.mainTokenIcon = IconStrings.ethereum,
    this.mainTokenSymbol = 'ETH',
    required super.type,
    super.apiKey,
    required super.isMainNet,
  });

  factory EthereumNetwork.mainNet() => EthereumNetwork(
    type: BlockchainType.ethereum,
    networkname: 'Mainnet',
    apiUrl: Urls.moralisBaseUrl,
    chainId: 1,
    chain: 'eth',
    rpcNodeUrl: 'https://ethereum.publicnode.com',
    title: 'Ethereum Mainnet',
    subTitle:
        'This network is the official Ethereum blockchain running Network.'
        ' You should use this network by default.',
    isMainNet: true,
  );

  factory EthereumNetwork.testNet() => EthereumNetwork(
    type: BlockchainType.ethereum,
    networkname: 'Testnet',
    apiUrl: Urls.moralisBaseUrl,
    chain: 'sepolia',
    chainId: 11155111, // Sepolia testnet chainId
    rpcNodeUrl: 'https://ethereum-sepolia-rpc.publicnode.com',
    title: 'Ethereum Testnet (Sepolia)',
    subTitle:
        'This network is used to test protocol upgrades'
        ' (do not use it unless you are a developer).',
    isMainNet: false,
  );

  factory EthereumNetwork.fromJson(Map<String, dynamic> json) =>
      _$EthereumNetworkFromJson(json);

  final String chain;
  final String mainTokenName;
  final String mainTokenSymbol;
  final String mainTokenIcon;
  final String mainTokenDecimal;

  @override
  Map<String, dynamic> toJson() => _$EthereumNetworkToJson(this);

  @override
  List<Object?> get props => [
    super.props,
    chain,
    mainTokenName,
    mainTokenIcon,
    mainTokenSymbol,
    mainTokenDecimal,
  ];
}
