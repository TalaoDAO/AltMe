import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/home/tab_bar/nft/cubit/nft_cubit_dao.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:json_annotation/json_annotation.dart';

part 'nft_cubit.g.dart';

part 'nft_state.dart';

class NftCubit extends Cubit<NftState> with NFTCubitDao {
  NftCubit({
    required this.client,
    required this.walletCubit,
    required this.manageNetworkCubit,
  }) : super(const NftState()) {
    getNftList();
  }

  final DioClient client;
  final WalletCubit walletCubit;
  final ManageNetworkCubit manageNetworkCubit;

  final int _limit = 10;
  int _offsetOfLoadedData = -1;

  List<NftModel> data = [];

  final log = getLogger('NftCubit');

  Future<void> getNftList() async {
    final activeIndex = walletCubit.state.currentCryptoIndex;

    if (state.offset == _offsetOfLoadedData) return;
    _offsetOfLoadedData = state.offset;
    if (data.length < state.offset) return;
    try {
      log.i('starting funtion getTezosNftList()');
      if (state.offset == 0) {
        emit(state.fetching());
      } else {
        emit(state.loading());
      }

      //final activeIndex = walletCubit.state.currentCryptoIndex;
      final walletAddress =
          walletCubit.state.cryptoAccount.data[activeIndex].walletAddress;

      late List<NftModel> newData;

      if (walletCubit.state.cryptoAccount.data[activeIndex].blockchainType ==
          BlockchainType.ethereum) {
        newData = await getEthereumNFTs(
          offset: state.offset,
          limit: _limit,
          walletAddress: walletAddress,
          network: manageNetworkCubit.state.network as EthereumNetwork,
        );
      } else {
        newData = await getTezosNFTs(
          offset: state.offset,
          limit: _limit,
          walletAddress: walletAddress,
          network: manageNetworkCubit.state.network as TezosNetwork,
        );
      }

      if (state.offset == 0) {
        data = newData;
      } else {
        data.addAll(newData);
      }
      log.i('nfts - $data');
      emit(state.populate(data: data));
    } catch (e, s) {
      if (isClosed) return;
      log.e('failed to fetch nfts, e: $e, s: $s');
      emit(
        state.copyWith(
          status: state.offset == 0
              ? AppStatus.errorWhileFetching
              : AppStatus.error,
          message: StateMessage.error(
            messageHandler: ResponseMessage(
              ResponseString
                  .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
            ),
          ),
          offset: state.offset == 0 ? 0 : state.offset - 1,
        ),
      );
    }
  }

  Future<void> fetchFromZero() async {
    log.i('refreshing nft page');
    _offsetOfLoadedData = -1;
    emit(state.copyWith(offset: 0));
    await getNftList();
  }

  Future<void> fetchMoreTezosNfts() async {
    log.i('fetching more nfts');
    final offset = state.offset + _limit;
    emit(state.copyWith(offset: offset));
    await getNftList();
  }

  @override
  Future<List<NftModel>> getEthereumNFTs({
    required int offset,
    required int limit,
    required String walletAddress,
    required EthereumNetwork network,
  }) async {
    await dotenv.load();
    final username = dotenv.get('INFURA_API_KEY');
    final password = dotenv.get('INFURA_API_KEY_SECRET');
    final basicAuth =
        'Basic ${base64.encode(utf8.encode('$username:$password'))}';

    final dynamic responseString = await client.get(
      '${network.apiUrl}/networks/1/accounts/$walletAddress/assets/nfts',
      headers: <String, String>{
        'Authorization': basicAuth,
      },
    );

    final dynamic response = jsonDecode(responseString as String);

    final nftsJson = response['assets'] as List<dynamic>;
    return List<EthereumNftModel>.from(
      nftsJson.map<EthereumNftModel>((dynamic e) {
        return EthereumNftModel(
          name: e['metadata']['name'] as String,
          description: e['metadata']['description'] as String?,
          tokenId: e['tokenId'] as String,
          contractAddress: e['contract'] as String,
          balance: e['supply'] as String,
          type: e['type'] as String,
          image: e['metadata']['image'] as String?,
          animationUrl: e['metadata']['animation_url'] as String?,
        );
      }),
    ).toList();
  }

  @override
  Future<List<NftModel>> getTezosNFTs({
    required int offset,
    required int limit,
    required String walletAddress,
    required TezosNetwork network,
  }) async {
    final List<dynamic> response = await client.get(
      '${network.apiUrl}/v1/tokens/balances',
      queryParameters: <String, dynamic>{
        'account': walletAddress,
        'balance.eq': 1,
        'token.metadata.null': false,
        'sort.desc': 'firstLevel',
        'select':
            'token.tokenId as tokenId,token.id as id,token.metadata.name as name,token.metadata.displayUri as displayUri,balance,token.metadata.thumbnailUri as thumbnailUri,token.metadata.description as description,token.standard as standard,token.metadata.symbol as symbol,token.contract.address as contractAddress,token.metadata.identifier as identifier,token.metadata.creators as creators,token.metadata.publishers as publishers,token.metadata.date as date,token.metadata.is_transferable as isTransferable', // ignore: lines_longer_than_80_chars
        'offset': offset,
        'limit': limit,
      },
    ) as List<dynamic>;
    final List<TezosNftModel> data = response
        .map((dynamic e) => TezosNftModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return data;
  }
}
