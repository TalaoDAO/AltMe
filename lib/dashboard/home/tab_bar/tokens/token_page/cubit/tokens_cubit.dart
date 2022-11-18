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
    getTokens();
  }

  final SecureStorageProvider secureStorageProvider;
  final DioClient client;
  final WalletCubit walletCubit;
  final ManageNetworkCubit networkCubit;
  final AllTokensCubit allTokensCubit;

  List<TokenModel> data = [];
  final int _limit = 100;
  int _offsetOfLoadedData = -1;

  void toggleIsSecure() {
    emit(state.copyWith(isSecure: !state.isSecure));
  }

  Future<void> fetchFromZero() async {
    _offsetOfLoadedData = -1;
    emit(state.copyWith(offset: 0));
    await getTokens();
  }

  Future<void> fetchMoreTokens() async {
    final offset = state.offset + _limit;
    emit(state.copyWith(offset: offset));
    await getTokens();
  }

  Future<void> getTokens() async {
    final activeIndex = walletCubit.state.currentCryptoIndex;
    if (walletCubit.state.cryptoAccount.data[activeIndex].blockchainType ==
        BlockchainType.ethereum) {
      emit(state.copyWith(status: AppStatus.idle));
      return;
    }

    if (state.offset == _offsetOfLoadedData) return;
    _offsetOfLoadedData = state.offset;
    if (data.length < state.offset) return;
    try {
      if (state.offset == 0) {
        emit(state.fetching());
      }

      //final activeIndex = walletCubit.state.currentCryptoIndex;
      if (walletCubit.state.cryptoAccount.data.isEmpty) {
        final String? ssiKey =
            await secureStorageProvider.get(SecureStorageKeys.ssiKey);
        await walletCubit.initialize(ssiKey: ssiKey);
        if (walletCubit.state.cryptoAccount.data.isEmpty) {
          emit(state.populate(data: []));
          return;
        }
      }
      final walletAddress =
          walletCubit.state.cryptoAccount.data[activeIndex].walletAddress;

      final baseUrl = networkCubit.state.network.tzktUrl;

      final List<dynamic> tokensBalancesJsonArray = await client.get(
        '$baseUrl/v1/tokens/balances',
        queryParameters: <String, dynamic>{
          'account': walletAddress,
          'token.metadata.decimals.ne': '0',
          'token.metadata.artifactUri.null': true,
          'select':
              '''token.contract.address as contractAddress,token.id as id,token.tokenId as tokenId,token.metadata.symbol as symbol,token.metadata.name as name,balance,token.metadata.icon as icon,token.metadata.thumbnailUri as thumbnailUri,token.metadata.decimals as decimals,token.standard as standard''',
          'offset': state.offset,
          'limit': _limit,
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

      if (state.offset == 0) {
        final tezosToken = await _getXtzBalance(walletAddress);
        newData.insert(0, tezosToken);
        data = newData;
      } else {
        data.addAll(newData);
      }

      // get all contract(for usd balance of every tokens) if not loaded yet
      // or is empty
      if (allTokensCubit.state.contracts.isEmpty) {
        await allTokensCubit.init();
      } else {
        // ignore: unawaited_futures
        allTokensCubit.init();
      }

      //get usd balance of tokens and update tokens
      if (allTokensCubit.state.contracts.isNotEmpty) {
        // Filter just selected tokens to show for user
        final selectedContracts = allTokensCubit.state.selectedContracts;
        final loadedTokensSymbols = data.map((e) => e.symbol).toList();
        final contractsNotInserted = selectedContracts
            .where(
              (element) => !loadedTokensSymbols.contains(element.symbol),
            )
            .toList();

        final contractsNotInsertedSymbols =
            contractsNotInserted.map((e) => e.symbol);
        data.addAll(
          allTokensCubit.state.contracts
              .where(
                (element) =>
                    contractsNotInsertedSymbols.contains(element.symbol),
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

        for (int i = 0; i < data.length; i++) {
          if (i == 0) {
            //we know that the first element is XTZ token all the time
            //and we calculated the usd balanc of it when we got xtz token
            continue;
          }
          try {
            final token = data[i];
            final contract = allTokensCubit.state.contracts.firstWhereOrNull(
              (element) =>
                  element.symbol.toLowerCase() == token.symbol.toLowerCase(),
            );
            if (contract != null) {
              data[i] = token.copyWith(
                icon: token.icon ?? contract.iconUrl,
                tokenUSDPrice: contract.usdValue,
                balanceInUSD:
                    token.calculatedBalanceInDouble * contract.usdValue,
              );
            } else {
              getLogger(toString()).i(
                'not found any contract for token to read usd balance from it',
              );
            }
          } catch (e, s) {
            getLogger(toString()).e(
              'error in finding contract, error: $e, s: $s',
            );
          }
        }
        double totalBalanceInUSD = 0;
        for (final tokenElement in data) {
          totalBalanceInUSD += tokenElement.balanceInUSD;
        }
        data.sort((a, b) => b.balanceInUSD.compareTo(a.balanceInUSD));
        emit(
          state.copyWith(
            status: AppStatus.success,
            data: data,
            totalBalanceInUSD: totalBalanceInUSD,
          ),
        );
      } else {
        double totalBalanceInUSD = 0;
        for (final tokenElement in data) {
          totalBalanceInUSD += tokenElement.balanceInUSD;
        }
        data.sort((a, b) => b.balanceInUSD.compareTo(a.balanceInUSD));
        emit(
          state.copyWith(
            status: AppStatus.success,
            data: data,
            totalBalanceInUSD: totalBalanceInUSD,
          ),
        );
      }
    } catch (e, s) {
      getLogger(runtimeType.toString()).e('error in get tokens e: $e , s:$s');
      data.sort((a, b) => b.balanceInUSD.compareTo(a.balanceInUSD));
      emit(state.copyWith(data: data));
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

    try {
      // get usd balance of xtz from teztools api
      final responseOfXTZUsdPrice = await client
          .get('${Urls.tezToolBase}/v1/xtz-price') as Map<String, dynamic>;
      final xtzUSDPrice = responseOfXTZUsdPrice['price'] as double;

      return token.copyWith(
        tokenUSDPrice: xtzUSDPrice,
        balanceInUSD: token.calculatedBalanceInDouble * xtzUSDPrice,
      );
    } catch (e, s) {
      getLogger(toString()).e('unable to get usd balance of XTZ, e: $e, s: $s');
      return token;
    }
  }

  @override
  String toString() {
    return 'TokensCubit';
  }
}
