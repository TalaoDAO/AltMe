import 'package:altme/app/shared/shared.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';

part 'nft_details_cubit.g.dart';

part 'nft_details_state.dart';

class NftDetailsCubit extends Cubit<NftDetailsState> {
  NftDetailsCubit({
    required this.manageNetworkCubit,
    required this.walletCubit,
  }) : super(const NftDetailsState(status: AppStatus.init));

  final ManageNetworkCubit manageNetworkCubit;
  final WalletCubit walletCubit;

  Future<void> burnDefiComplianceToken({required NftModel nftModel}) async {
    final network = manageNetworkCubit.state.network;
    if (network is! EthereumNetwork) return;
    emit(state.copyWith(status: AppStatus.loading));
    final selectedNetwork = manageNetworkCubit.state.network as EthereumNetwork;
    final rpcUrl = selectedNetwork.rpcNodeUrl;
    final chainId = selectedNetwork.chainId;
    final contractAddress = nftModel.contractAddress;
    final abi = await rootBundle.loadString('assets/abi/ssi-sbt-abi.json');
    final privateKey = walletCubit.state.currentAccount?.secretKey ?? '';
    final tokenId = nftModel.tokenId;

    await MWeb3Client.burnToken(
      privateKey: privateKey,
      rpcUrl: rpcUrl,
      contractAddress: contractAddress,
      abi: abi,
      tokenId: BigInt.parse(tokenId),
      chainId: chainId,
    );
    emit(state.copyWith(status: AppStatus.success));
  }
}
