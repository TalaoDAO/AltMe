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
        return TezosNetwork.mainNet();
      case BlockchainNetworkType.tezosGhostnet:
        return TezosNetwork.ghostnet();
      case BlockchainNetworkType.ethereumMainnet:
        return EthereumNetwork.mainNet();
      case BlockchainNetworkType.ethereumTestnet:
        return EthereumNetwork.testNet();
      case BlockchainNetworkType.polygonMainnet:
        return PolygonNetwork.mainNet();
      case BlockchainNetworkType.polygonTestnet:
        return PolygonNetwork.testNet();
      case BlockchainNetworkType.binanceMainnet:
        return BinanceNetwork.mainNet();
      case BlockchainNetworkType.binanceTestnet:
        return BinanceNetwork.testNet();
      case BlockchainNetworkType.fantomMainnet:
        return FantomNetwork.mainNet();
      case BlockchainNetworkType.fantomTestnet:
        return FantomNetwork.testNet();
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
