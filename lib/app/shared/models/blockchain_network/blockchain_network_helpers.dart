import 'package:altme/app/shared/constants/parameters.dart';
import 'package:altme/app/shared/models/model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

enum BlockchainNetworkType {
  tezosMainnet,
  tezosGhostnet,
  ethereumMainnet,
  ethereumTestnet,
  polygonMainnet,
  polygonTestnet,
  binanceMainnet,
  binanceTestnet,
  fantomMainnet,
  fantomTestnet,
}

extension BlockchainNetworkTypeX on BlockchainNetworkType {
  BlockchainNetwork get network {
    switch (this) {
      case BlockchainNetworkType.tezosMainnet:
        final network = TezosNetwork.mainNet();
        return network;
      case BlockchainNetworkType.tezosGhostnet:
        final network = TezosNetwork.ghostnet();
        return network;
      case BlockchainNetworkType.ethereumMainnet:
        final network = EthereumNetwork.mainNet();
        return network;
      case BlockchainNetworkType.ethereumTestnet:
        final network = EthereumNetwork.testNet();
        return network;
      case BlockchainNetworkType.polygonMainnet:
        final network = PolygonNetwork.mainNet();
        return network;
      case BlockchainNetworkType.polygonTestnet:
        final network = PolygonNetwork.testNet();
        return network;
      case BlockchainNetworkType.binanceMainnet:
        final network = BinanceNetwork.mainNet();
        return network;
      case BlockchainNetworkType.binanceTestnet:
        final network = BinanceNetwork.testNet();
        return network;
      case BlockchainNetworkType.fantomMainnet:
        final network = FantomNetwork.mainNet();
        return network;
      case BlockchainNetworkType.fantomTestnet:
        final network = FantomNetwork.testNet();
        return network;
    }
  }
}

BlockchainNetwork? blockchainNetworkFromChainId(int chainId) {
  for (final type in BlockchainNetworkType.values) {
    final network = type.network;
    if (network.chainId == chainId) {
      return network;
    }
  }
  return null;
}

Future<String> fetchRpcUrl({
  required BlockchainNetwork blockchainNetwork,
  required DotEnv dotEnv,
}) async {
  String rpcUrl = '';

  if (blockchainNetwork is BinanceNetwork ||
      blockchainNetwork is FantomNetwork ||
      blockchainNetwork is EtherlinkNetwork) {
    rpcUrl = blockchainNetwork.rpcNodeUrl as String;
  } else {
    if (blockchainNetwork.networkname == 'Mainnet') {
      await dotEnv.load();
      final String infuraApiKey = dotEnv.get('INFURA_API_KEY');

      late String prefixUrl;

      if (blockchainNetwork is PolygonNetwork) {
        prefixUrl = Parameters.POLYGON_INFURA_URL;
      } else {
        prefixUrl = Parameters.web3RpcMainnetUrl;
      }

      return '$prefixUrl$infuraApiKey';
    } else {
      rpcUrl = blockchainNetwork.rpcNodeUrl as String;
    }
  }

  return rpcUrl;
}
