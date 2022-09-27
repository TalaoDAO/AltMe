import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'nft_cubit.g.dart';

part 'nft_state.dart';

class NftCubit extends Cubit<NftState> {
  NftCubit({
    required this.client,
    required this.walletCubit,
    required this.manageNetworkCubit,
  }) : super(const NftState()) {
    getTezosNftList();
  }

  final DioClient client;
  final WalletCubit walletCubit;
  final ManageNetworkCubit manageNetworkCubit;

  final int _limit = 10;

  List<NftModel> data = [];

  final log = getLogger('NftCubit');

  Future<void> getTezosNftList() async {
    if (data.length < state.offset) return;
    try {
      log.i('starting funtion getTezosNftList()');
      if (state.offset == 0) {
        emit(state.fetching());
      } else {
        emit(state.loading());
      }
      final activeIndex = walletCubit.state.currentCryptoIndex;
      final walletAddress =
          walletCubit.state.cryptoAccount.data[activeIndex].walletAddress;

      final baseUrl = manageNetworkCubit.state.network.tzktUrl;

      final List<dynamic> response = await client.get(
        '$baseUrl/v1/tokens/balances',
        queryParameters: <String, dynamic>{
          'account': walletAddress,
          'balance.eq': 1,
          'select':
              'token.tokenId as id,token.metadata.name as name,token.metadata.displayUri as displayUri,balance,token.metadata.thumbnailUri as thumbnailUri', // ignore: lines_longer_than_80_chars
          'offset': state.offset,
          'limit': _limit,
        },
      ) as List<dynamic>;
      // TODO(all): check the balance variable of NFTModel
      // and get right value from api
      final List<NftModel> newData = response
          .map((dynamic e) => NftModel.fromJson(e as Map<String, dynamic>))
          .toList();

      if (state.offset == 0) {
        data = newData;
      } else {
        data.addAll(newData);
      }
      log.i('nfts - $data');
      emit(state.populate(data: data));
    } catch (e) {
      if (isClosed) return;
      log.e('failed to fetch nfts');
      emit(
        state.copyWith(
          status: state.offset == 0
              ? AppStatus.errorWhileFetching
              : AppStatus.error,
          messageHandler: ResponseMessage(
            ResponseString.RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
          ),
          offset: state.offset == 0 ? 0 : state.offset - 1,
        ),
      );
    }
  }

  Future<void> onRefresh() async {
    log.i('refreshing nft page');
    emit(state.copyWith(offset: 0));
    await getTezosNftList();
  }

  Future<void> fetchMoreTezosNfts() async {
    log.i('fetching more nfts');
    final offset = state.offset + _limit;
    emit(state.copyWith(offset: offset));
    await getTezosNftList();
  }
}
