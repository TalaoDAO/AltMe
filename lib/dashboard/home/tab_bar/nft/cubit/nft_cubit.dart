import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:json_annotation/json_annotation.dart';

part 'nft_cubit.g.dart';

part 'nft_state.dart';

class NftCubit extends Cubit<NftState> {
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
    if (walletCubit.state.currentAccount == null) return;
    if (walletCubit.state.currentAccount!.blockchainType.isDisabled) {
      emit(state.copyWith(status: AppStatus.idle));
      return;
    }

    if (state.offset == _offsetOfLoadedData) return;
    _offsetOfLoadedData = state.offset;
    if (data.length < state.offset) return;
    try {
      log.i('starting funtion getTezosNftList()');

      //final activeIndex = walletCubit.state.currentCryptoIndex;
      final walletAddress = walletCubit.state.currentAccount!.walletAddress;

      late List<NftModel> newData;

      final selectedAccountBlockchainType =
          walletCubit.state.currentAccount!.blockchainType;
      if (state.blockchainType != selectedAccountBlockchainType) {
        emit(state.reset(blockchainType: selectedAccountBlockchainType));
      }
      if (state.offset == 0) {
        emit(state.fetching());
      } else {
        emit(state.loading());
      }

      if (selectedAccountBlockchainType == BlockchainType.tezos) {
        newData = await getTezosNFTs(
          offset: state.offset,
          limit: _limit,
          walletAddress: walletAddress,
          network: manageNetworkCubit.state.network as TezosNetwork,
        );
      } else {
        newData = await getEthereumNFTs(
          offset: state.offset,
          limit: _limit,
          walletAddress: walletAddress,
          network: manageNetworkCubit.state.network as EthereumNetwork,
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

  Future<List<NftModel>> getEthereumNFTs({
    required int offset,
    required int limit,
    required String walletAddress,
    required EthereumNetwork network,
  }) async {
    try {
      await dotenv.load();
      final moralisApiKey = dotenv.get('MORALIS_API_KEY');

      //If you want to see example nft data you should hardcode
      // this wallet address in API call ->
      // 0xd8da6bf26964af9d7eed9e03e53415d37aa96045

      final Map<String, dynamic> response = await client.get(
        '${Urls.moralisBaseUrl}/$walletAddress/nft',
        queryParameters: <String, dynamic>{
          'chain': network.chain,
          'format': 'decimal',
          'normalizeMetadata': true,
        },
        headers: <String, String>{
          'X-API-KEY': moralisApiKey,
        },
      ) as Map<String, dynamic>;

      final result = response['result'] as List<dynamic>;
      if (result.isEmpty) {
        return [];
      }

      final nftList = List<EthereumNftModel>.from(
        result.map<EthereumNftModel>((dynamic e) {
          return EthereumNftModel(
            name: (e['name'] as String? ??
                    e['normalized_metadata']['name'] as String?) ??
                '',
            symbol: e['symbol'] as String?,
            description: e['normalized_metadata']['description'] as String?,
            tokenId: e['token_id'] as String,
            contractAddress: e['token_address'] as String,
            balance: e['amount'] as String,
            type: e['contract_type'] as String,
            minterAddress: e['minter_address'] as String?,
            lastMetadataSync: e['last_metadata_sync'] as String?,
            image: e['normalized_metadata']['image'] as String?,
            animationUrl: e['normalized_metadata']['animation_url'] as String?,
          );
        }),
      ).toList();

      for (final element in nftList) {
        if (element.thumbnailUri == null) {
          try {
            await client.get(
              '${Urls.moralisBaseUrl}/nft/${element.contractAddress}/${element.tokenId}/metadata/resync',
              headers: <String, String>{
                'X-API-KEY': moralisApiKey,
              },
            );
          } catch (e, s) {
            getLogger(toString()).e('failed to resync e: $e s: $s');
          }
        }
      }
      return nftList;
    } catch (e, s) {
      getLogger(toString()).e('e: $e, s: $s');
      return [];
    }
  }

  Future<List<NftModel>> getTezosNFTs({
    required int offset,
    required int limit,
    required String walletAddress,
    required TezosNetwork network,
  }) async {
    try {
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
    } catch (e, s) {
      getLogger(toString()).e('e: $e, s: $s');
      return [];
    }
  }
}
