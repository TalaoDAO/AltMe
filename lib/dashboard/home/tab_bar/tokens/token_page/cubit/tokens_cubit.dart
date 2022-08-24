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
  double? _xtzUsdValue;

  List<TokenModel> data = [];

  void toggleIsSecure() {
    emit(state.copyWith(isSecure: !state.isSecure));
  }

  Future<List<TokenModel>> getBalanceOfAssetList({
    String baseUrl = '',
    required int offset,
    int limit = 15,
  }) async {
    if (data.length < offset) return data;
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
              '''token.contract.address as contractAddress,token.id as id,token.metadata.symbol as symbol,token.metadata.name as name,balance,token.metadata.icon as icon,token.metadata.thumbnailUri as thumbnailUri,token.metadata.decimals as decimals''',
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
        final tezosToken = await _getXtzBalance(baseUrl, walletAddress);
        newData.insert(0, tezosToken);
        data = newData;
      } else {
        data.addAll(newData);
      }
      emit(state.populate(data: data));
      //get usd balance of tokens and update tokens
      final contracts = await _getUSDBalanceOfTokens();
      if (contracts?.isNotEmpty ?? false) {
        for (int i = 0; i < data.length; i++) {
          //we know that the first element is XTZ token all the time
          if (i == 0 && _xtzUsdValue != null) {
            data[i] = data[i].copyWith(
              tokenUSDPrice: _xtzUsdValue,
              balanceUSDPrice:
                  data[i].calculatedBalanceInDouble * _xtzUsdValue!,
            );
            continue;
          }
          try {
            final token = data[i];
            final contract = contracts!.firstWhere(
              (element) =>
                  element.symbol == token.symbol &&
                  element.tokenAddress == token.contractAddress,
            );
            data[i] = token.copyWith(
              tokenUSDPrice: contract.usdValue,
              balanceUSDPrice:
                  token.calculatedBalanceInDouble * contract.usdValue,
            );
          } catch (e) {
            getLogger(runtimeType.toString())
                .e('error in finding contract for token to get price');
          }
        }
        double totalBalanceInUSD = 0;
        for (final tokenElement in data) {
          totalBalanceInUSD += tokenElement.balanceUSDPrice ?? 0;
        }
        emit(
          state.copyWith(
            status: AppStatus.success,
            data: data,
            totalBalanceInUSD: totalBalanceInUSD,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: AppStatus.success,
            data: data,
          ),
        );
      }

      return data;
    } catch (e) {
      if (isClosed) return data;
      emit(
        state.errorWhileFetching(
          messageHandler: ResponseMessage(
            ResponseString.RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
          ),
        ),
      );
      return data;
    }
  }

  Future<List<ContractModel>?> _getUSDBalanceOfTokens() async {
    try {
      final dynamic result = await client.get(Urls.tezToolPrices);
      _xtzUsdValue = result['xtzusdValue'] as double?;
      final contracts = result['contracts'] as List<dynamic>;
      return List.of(
        contracts.map(
          (dynamic e) => ContractModel.fromJson(e as Map<String, dynamic>),
        ),
      );
    } catch (e, s) {
      getLogger(runtimeType.toString())
          .e('error in get balance of tokens, e: $e, s: $s', e, s);
      return null;
    }
  }

  Future<TokenModel> _getXtzBalance(
    String baseUrl,
    String walletAddress,
  ) async {
    final int balance =
        await client.get('$baseUrl/v1/accounts/$walletAddress/balance') as int;
        
    final token = TokenModel(
      id: -1,
      contractAddress: '',
      name: 'Tezos',
      symbol: 'XTZ',
      icon: 'https://s2.coinmarketcap.com/static/img/coins/64x64/2011.png',
      balance: balance.toString(),
      decimals: '6',
    );

    return token.copyWith(
      tokenUSDPrice: _xtzUsdValue,
      balanceUSDPrice: _xtzUsdValue != null
          ? token.calculatedBalanceInDouble * (_xtzUsdValue!)
          : null,
    );
  }
}
