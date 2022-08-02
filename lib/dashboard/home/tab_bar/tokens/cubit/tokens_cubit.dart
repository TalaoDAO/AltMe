import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tokens_cubit.g.dart';

part 'tokens_state.dart';

class TokensCubit extends Cubit<TokensState> {
  TokensCubit({
    required this.client,
    required this.walletCubit,
  }) : super(const TokensState()) {
    getBalanceOfAssetList(offset: 0);
  }

  final DioClient client;
  final WalletCubit walletCubit;

  List<TokenModel> data = [];

  Future<void> getBalanceOfAssetList({
    String baseUrl = '',
    required int offset,
    int limit = 15,
  }) async {
    if (data.length < offset) return;
    try {
      if (offset == 0) {
        emit(state.fetching());
      }

      final activeIndex = walletCubit.state.currentCryptoIndex;
      final walletAddress =
          walletCubit.state.cryptoAccount.data[activeIndex].walletAddress;

      final List<dynamic> tokensBalancesJsonArray = await client.get(
        '$baseUrl/v1/tokens/balances',
        queryParameters: <String, dynamic>{
          'account': walletAddress,
          'balance.ne': 1,
          'select':
              '''token.contract.address as contractAddress,token.tokenId as tokenId,token.metadata.symbol as symbol,token.metadata.name as name,balance,token.metadata.icon as icon,token.metadata.thumbnailUri as thumbnailUri,token.metadata.decimals as decimals''',
          'offset': offset,
          'limit': limit,
        },
      ) as List<dynamic>;
      List<TokenModel> newData = [];
      if (tokensBalancesJsonArray.isNotEmpty) {
        newData = tokensBalancesJsonArray
            .map(
              (dynamic json) =>
                  TokenModel.fromJson(json as Map<String, dynamic>),
            )
            .toList();
      }

      if (offset == 0) {
        final tezosToken = await getXtzBalance(baseUrl, walletAddress);
        newData.insert(0, tezosToken);
        data = newData;
      } else {
        data.addAll(newData);
      }
      emit(state.populate(data: data));
    } catch (e) {
      if (isClosed) return;
      emit(
        state.errorWhileFetching(
          messageHandler: ResponseMessage(
            ResponseString.RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
          ),
        ),
      );
    }
  }

  Future<TokenModel> getXtzBalance(String baseUrl, String walletAddress) async {
    final int balance =
        await client.get('$baseUrl/v1/accounts/$walletAddress/balance') as int;

    return TokenModel(
      '',
      'Tezos',
      'XTZ',
      'https://s2.coinmarketcap.com/static/img/coins/64x64/2011.png',
      '',
      balance.toString(),
      '6',
    );
  }
}
