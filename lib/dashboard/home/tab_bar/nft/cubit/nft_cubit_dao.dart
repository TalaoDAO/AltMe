import 'package:altme/app/shared/models/blockchain_network/tezos_network.dart';
import 'package:altme/dashboard/home/home.dart';

mixin NFTCubitDao {
  Future<List<NftModel>> getTezosNFTs({
    required int offset,
    required int limit,
    required String walletAddress,
    required TezosNetwork network,
  });

  Future<List<NftModel>> getEthereumNFTs({
    required int offset,
    required int limit,
    required String walletAddress,
  });
}
