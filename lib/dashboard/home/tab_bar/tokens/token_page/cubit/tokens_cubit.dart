import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:secure_storage/secure_storage.dart';

part 'tokens_cubit.g.dart';

part 'tokens_state.dart';

class TokensCubit extends Cubit<TokensState> {
  TokensCubit({
    required this.client,
    required this.walletCubit,
    required this.networkCubit,
    required this.allTokensCubit,
    required this.secureStorageProvider,
  }) : super(const TokensState()) {
    getBalanceOfAssetList(offset: 0);
  }

  final SecureStorageProvider secureStorageProvider;
  final DioClient client;
  final WalletCubit walletCubit;
  final ManageNetworkCubit networkCubit;
  final AllTokensCubit allTokensCubit;

  List<TokenModel> data = [];

  void toggleIsSecure() {
    emit(state.copyWith(isSecure: !state.isSecure));
  }

  Future<List<TokenModel>> getBalanceOfAssetList({
    required int offset,
    int limit = 100,
    bool filterTokens = true,
  }) async {
    if (data.length < offset) return data;
    try {
      if (offset == 0) {
        emit(state.fetching());
      }

      final activeIndex = walletCubit.state.currentCryptoIndex;
      final walletAddress =
          walletCubit.state.cryptoAccount.data[activeIndex].walletAddress;

      final baseUrl = networkCubit.state.network.tzktUrl;

      final List<dynamic> tokensBalancesJsonArray = await client.get(
        '$baseUrl/v1/tokens/balances',
        queryParameters: <String, dynamic>{
          'account': walletAddress,
          'balance.ne': 1,
          'select':
              '''token.contract.address as contractAddress,token.id as id,token.tokenId as tokenId,token.metadata.symbol as symbol,token.metadata.name as name,balance,token.metadata.icon as icon,token.metadata.thumbnailUri as thumbnailUri,token.metadata.decimals as decimals,token.standard as standard''',
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
        final tezosToken = await _getXtzBalance(walletAddress);
        newData.insert(0, tezosToken);
        data = newData;
        if (allTokensCubit.state.contracts.isEmpty) {
          await allTokensCubit.init();
        } else {
          // ignore: unawaited_futures
          allTokensCubit.init();
        }
      } else {
        data.addAll(newData);
        // ignore: unawaited_futures
        allTokensCubit.init();
      }
      //get usd balance of tokens and update tokens
      if (allTokensCubit.state.contracts.isNotEmpty) {
        // Filter just selected tokens to show for user
        if (filterTokens) {
          final selectedContracts = allTokensCubit.state.selectedContracts;
          final contractsNotInserted = selectedContracts
              .where(
                (element) => !data
                    .map((e) => e.symbol)
                    .toList()
                    .contains(element.symbol),
              )
              .toList();

          data.addAll(
            allTokensCubit.state.contracts
                .where(
                  (element) => contractsNotInserted
                      .map((e) => e.symbol)
                      .contains(element.symbol),
                )
                .map(
                  (e) => TokenModel(
                    contractAddress: e.address,
                    name: e.name ?? '',
                    symbol: e.symbol,
                    balance: '0',
                    icon: e.thumbnailUri,
                    decimals: e.decimals.toString(),
                    id: -2,
                    standard: e.type,
                  ),
                ),
          );
        }

        for (int i = 0; i < data.length; i++) {
          //we know that the first element is XTZ token all the time
          if (i == 0 && allTokensCubit.state.xtzUsdValue != null) {
            data[i] = data[i].copyWith(
              tokenUSDPrice: allTokensCubit.state.xtzUsdValue,
              balanceUSDPrice: data[i].calculatedBalanceInDouble *
                  allTokensCubit.state.xtzUsdValue!,
            );
            continue;
          }
          try {
            final token = data[i];
            final contract = allTokensCubit.state.contracts.firstWhere(
              (element) => element.symbol == token.symbol,
            );
            data[i] = token.copyWith(
              icon: token.icon ?? contract.iconUrl,
              tokenUSDPrice: contract.usdValue,
              balanceUSDPrice:
                  token.calculatedBalanceInDouble * contract.usdValue,
            );
          } catch (e, s) {
            getLogger(runtimeType.toString()).e(
              'error in finding contract, error: $e, s: $s',
            );
          }
        }
        double totalBalanceInUSD = 0;
        for (final tokenElement in data) {
          totalBalanceInUSD += tokenElement.balanceUSDPrice;
        }
        data.sort((a, b) => b.balanceUSDPrice.compareTo(a.balanceUSDPrice));
        emit(
          state.copyWith(
            status: AppStatus.success,
            data: data,
            totalBalanceInUSD: totalBalanceInUSD,
          ),
        );
        return data;
      }
      data.sort((a, b) => b.balanceUSDPrice.compareTo(a.balanceUSDPrice));
      emit(
        state.copyWith(
          status: AppStatus.success,
          data: data,
        ),
      );

      return data;
    } catch (e, s) {
      getLogger(runtimeType.toString()).e('error in get tokens e: $e , s:$s');
      data.sort((a, b) => b.balanceUSDPrice.compareTo(a.balanceUSDPrice));
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

  Future<TokenModel> _getXtzBalance(
    String walletAddress,
  ) async {
    final baseUrl = networkCubit.state.network.tzktUrl;
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
      standard: 'fa1.2',
    );

    return token.copyWith(
      tokenUSDPrice: allTokensCubit.state.xtzUsdValue,
      balanceUSDPrice: allTokensCubit.state.xtzUsdValue != null
          ? token.calculatedBalanceInDouble *
              (allTokensCubit.state.xtzUsdValue!)
          : null,
    );
  }
}
