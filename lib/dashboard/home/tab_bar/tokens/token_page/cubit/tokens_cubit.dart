import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
  }) : super(const TokensState());

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
    emit(state.copyWith(offset: 0, totalBalanceInUSD: 0));
    await getTokens();
  }

  Future<void> fetchMoreTokens() async {
    final offset = state.offset + _limit;
    emit(state.copyWith(offset: offset));
    await getTokens();
  }

  Future<void> getTokens() async {
    if (state.offset == _offsetOfLoadedData) return;
    _offsetOfLoadedData = state.offset;
    if (data.length < state.offset) return;
    try {
      if (walletCubit.state.currentAccount == null) {
        final String? ssiKey =
            await secureStorageProvider.get(SecureStorageKeys.ssiKey);
        await walletCubit.initialize(ssiKey: ssiKey);
        if (walletCubit.state.cryptoAccount.data.isEmpty) {
          emit(state.populate(data: {}));
          return;
        }
      }
      final walletAddress = walletCubit.state.currentAccount!.walletAddress;
      final selectedAccountBlockchainType =
          walletCubit.state.currentAccount!.blockchainType;
      if (state.blockchainType != selectedAccountBlockchainType) {
        emit(state.reset(blockchainType: selectedAccountBlockchainType));
      }
      if (state.offset == 0) {
        emit(state.fetching());
      }

      if (selectedAccountBlockchainType == BlockchainType.tezos) {
        await getTokensOnTezos(
          walletAddress: walletAddress,
          tezosNetwork: networkCubit.state.network as TezosNetwork,
          limit: _limit,
          offset: state.offset,
        );
      } else {
        await getTokensOnEthereum(
          walletAddress: walletAddress,
          ethereumNetwork: networkCubit.state.network as EthereumNetwork,
          limit: _limit,
          offset: state.offset,
        );
      }
    } catch (e, s) {
      getLogger(runtimeType.toString()).e('error in get tokens e: $e , s:$s');
      data.sort((a, b) => b.balanceInUSD.compareTo(a.balanceInUSD));
      emit(state.copyWith(data: data.toSet()));
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

  Future<void> getTokensOnEthereum({
    required String walletAddress,
    required EthereumNetwork ethereumNetwork,
    required int limit,
    required int offset,
  }) async {
    if (offset > 0) {
      //because at this time pagination not supported for Ethereum tokens
      return;
    }
    await dotenv.load();
    final moralisApiKey = dotenv.get('MORALIS_API_KEY');

    final List<dynamic> tokensBalancesJsonArray = await client.get(
      '${Urls.moralisBaseUrl}/$walletAddress/erc20',
      queryParameters: <String, dynamic>{
        'chain': ethereumNetwork.chain,
      },
      headers: <String, dynamic>{
        'X-API-KEY': moralisApiKey,
      },
    ) as List<dynamic>;
    List<TokenModel> newData = [];
    if (tokensBalancesJsonArray.isNotEmpty) {
      newData = tokensBalancesJsonArray.map(
        (dynamic json) {
          final icon = (json['logo'] == null && json['symbol'] == 'TALAO')
              ? IconStrings.talaoIcon
              : json['logo'] as String?;
          return TokenModel(
            contractAddress: json['token_address'] as String,
            name: (json['name'] as String?) ?? '',
            symbol: (json['symbol'] as String?) ?? '',
            balance: (json['balance'] as String?) ?? '',
            decimals: ((json['decimals'] as int?) ?? 0).toString(),
            thumbnailUri: json['thumbnail'] as String?,
            standard: 'erc20',
            icon: icon,
            decimalsToShow: 2,
          );
        },
      ).toList();
    }

    if (offset == 0) {
      final ethereumBaseToken = await _getBaseTokenBalanceOnEth(
        walletAddress,
        ethereumNetwork.chain,
        ethereumNetwork,
      );
      if (ethereumBaseToken != null) {
        newData.insert(0, ethereumBaseToken);
      }
      data = newData;
    } else {
      data.addAll(newData);
    }

    data = await setUSDValues(data);
    double totalBalanceInUSD = 0;
    for (final tokenElement in data) {
      totalBalanceInUSD += tokenElement.balanceInUSD;
    }
    data.sort((a, b) => b.balanceInUSD.compareTo(a.balanceInUSD));

    emit(
      state.copyWith(
        status: AppStatus.success,
        data: data.toSet(),
        totalBalanceInUSD: totalBalanceInUSD,
      ),
    );
  }

  Future<List<TokenModel>> setUSDValues(List<TokenModel> tokens) async {
    try {
      final dynamic response = await client.get(
        '${Urls.cryptoCompareBaseUrl}/data/pricemulti?fsyms=${tokens.map((e) => e.symbol).toList().join(',')}&tsyms=USD',
      );
      for (var i = 0; i < tokens.length; i++) {
        final tokenUSDPrice = response[tokens[i].symbol]['USD'] as num?;
        if (tokenUSDPrice == null) {
          data[i] = tokens[i].copyWith(
            decimalsToShow: tokens[i].calculatedBalanceInDouble < 1.0 ? 5 : 2,
          );
        } else {
          tokens[i] = tokens[i].copyWith(
            tokenUSDPrice: tokenUSDPrice.toDouble(),
            balanceInUSD: tokenUSDPrice * tokens[i].calculatedBalanceInDouble,
            decimalsToShow: tokens[i].calculatedBalanceInDouble < 1.0 ? 5 : 2,
          );
        }
      }
      return tokens;
    } catch (e, s) {
      getLogger(toString()).e('error in setUSDValues, e: $e, s: $s');
      return tokens;
    }
  }

  Future<void> getTokensOnTezos({
    required String walletAddress,
    required TezosNetwork tezosNetwork,
    required int limit,
    required int offset,
  }) async {
    final baseUrl = tezosNetwork.apiUrl;

    final List<dynamic> tokensBalancesJsonArray = await client.get(
      '$baseUrl/v1/tokens/balances',
      queryParameters: <String, dynamic>{
        'account': walletAddress,
        'token.metadata.decimals.ne': '0',
        'token.metadata.artifactUri.null': true,
        'select':
            '''token.contract.address as contractAddress,token.tokenId as tokenId,token.metadata.symbol as symbol,token.metadata.name as name,balance,token.metadata.icon as icon,token.metadata.thumbnailUri as thumbnailUri,token.metadata.decimals as decimals,token.standard as standard''',
        'offset': offset,
        'limit': limit,
      },
    ) as List<dynamic>;
    List<TokenModel> newData = [];
    if (tokensBalancesJsonArray.isNotEmpty) {
      newData = tokensBalancesJsonArray.map(
        (dynamic json) {
          final token = TokenModel.fromJson(json as Map<String, dynamic>);
          return token.copyWith(
            decimalsToShow: token.calculatedBalanceInDouble < 1.0 ? 5 : 2,
          );
        },
      ).toList();
    }

    if (offset == 0) {
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
              (element) => contractsNotInsertedSymbols.contains(element.symbol),
            )
            .map(
              (e) => TokenModel(
                contractAddress: e.address,
                name: e.name ?? '',
                symbol: e.symbol,
                balance: '0',
                icon: e.thumbnailUri,
                decimals: e.decimals.toString(),
                standard: e.type,
                decimalsToShow: 2,
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
              balanceInUSD: token.calculatedBalanceInDouble * contract.usdValue,
              decimalsToShow: token.calculatedBalanceInDouble < 1.0 ? 5 : 2,
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
          data: data.toSet(),
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
          data: data.toSet(),
          totalBalanceInUSD: totalBalanceInUSD,
        ),
      );
    }
  }

  Future<TokenModel?> _getBaseTokenBalanceOnEth(
    String walletAddress,
    String chain,
    EthereumNetwork ethereumNetwork,
  ) async {
    try {
      await dotenv.load();
      final moralisApiKey = dotenv.get('MORALIS_API_KEY');
      final response = await client.get(
        '${Urls.moralisBaseUrl}/$walletAddress/balance',
        queryParameters: <String, dynamic>{
          'chain': chain,
        },
        headers: <String, dynamic>{
          'X-API-KEY': moralisApiKey,
        },
      ) as Map<String, dynamic>;

      return TokenModel(
        contractAddress: '',
        name: ethereumNetwork.mainTokenName,
        symbol: ethereumNetwork.mainTokenSymbol,
        icon: ethereumNetwork.mainTokenIcon,
        balance: response['balance'] as String,
        decimals: ethereumNetwork.mainTokenDecimal,
        standard: 'ERC20',
        decimalsToShow: 5,
      );
    } catch (e, s) {
      getLogger(toString()).e('error: $e, stack: $s');
      return null;
    }
  }

  Future<TokenModel> _getXtzBalance(
    String walletAddress,
  ) async {
    final baseUrl = networkCubit.state.network.apiUrl;
    final int balance =
        await client.get('$baseUrl/v1/accounts/$walletAddress/balance') as int;

    final token = TokenModel(
      contractAddress: '',
      name: 'Tezos',
      symbol: 'XTZ',
      icon: IconStrings.tezos,
      balance: balance.toString(),
      decimals: '6',
      standard: 'fa1.2',
      decimalsToShow: balance < 1 ? 5 : 2,
    );

    try {
      // get usd balance of xtz from teztools api
      final responseOfXTZUsdPrice = await client
          .get('${Urls.tezToolBase}/v1/xtz-price') as Map<String, dynamic>;
      final xtzUSDPrice = responseOfXTZUsdPrice['price'] as double;

      return token.copyWith(
        tokenUSDPrice: xtzUSDPrice,
        balanceInUSD: token.calculatedBalanceInDouble * xtzUSDPrice,
        decimalsToShow: token.calculatedBalanceInDouble < 1.0 ? 5 : 2,
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
