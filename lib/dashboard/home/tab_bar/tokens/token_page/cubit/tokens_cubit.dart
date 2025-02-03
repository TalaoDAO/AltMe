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
    required this.mnemonicNeedVerificationCubit,
    required this.secureStorageProvider,
  }) : super(const TokensState());

  final SecureStorageProvider secureStorageProvider;
  final DioClient client;
  final WalletCubit walletCubit;
  final ManageNetworkCubit networkCubit;
  final AllTokensCubit allTokensCubit;
  final MnemonicNeedVerificationCubit mnemonicNeedVerificationCubit;

  List<TokenModel> data = [];
  final int _limit = 100;
  int _offsetOfLoadedData = -1;
  List<dynamic>? _coinList;

  Future<void> checkIfItNeedsToVerifyMnemonic({
    required double totalBalanceInUSD,
  }) async {
    final hasVerifiedMnemonics = await secureStorageProvider.get(
      SecureStorageKeys.hasVerifiedMnemonics,
    );
    if (hasVerifiedMnemonics == 'yes') {
      mnemonicNeedVerificationCubit.needToVerifyMnemonic(needToVerify: false);
    } else {
      if (totalBalanceInUSD >= 100) {
        mnemonicNeedVerificationCubit.needToVerifyMnemonic(needToVerify: true);
      }
    }
  }

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
      } else if (selectedAccountBlockchainType == BlockchainType.etherlink) {
        await getTokensOnEtherlink(
          walletAddress: walletAddress,
          ethereumNetwork: networkCubit.state.network as EthereumNetwork,
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
            message: ResponseString
                .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
          ),
        ),
      );
    }
  }

  Future<void> getTokensOnEtherlink({
    required String walletAddress,
    required EthereumNetwork ethereumNetwork,
    required int limit,
    required int offset,
  }) async {
    if (offset > 0) {
      //because at this time pagination not supported for Ethereum tokens
      return;
    }
    final baseUrl = ethereumNetwork.apiUrl;

    List<dynamic> tokensBalancesJsonArray = [];

    try {
      tokensBalancesJsonArray = await client.get(
        '$baseUrl/v2/addresses/$walletAddress/token-balances',
        headers: <String, dynamic>{'Content-Type': 'application/json'},
      ) as List<dynamic>;
    } catch (e) {
      if (e is NetworkException &&
          e.message == NetworkError.NETWORK_ERROR_NOT_FOUND) {
        tokensBalancesJsonArray = [];
      } else {
        rethrow;
      }
    }

    List<TokenModel> newData = [];

    if (tokensBalancesJsonArray.isNotEmpty) {
      newData = tokensBalancesJsonArray.map(
        (dynamic json) {
          final icon = (json['token_instance']
              as Map<String, dynamic>)['metadata']['image_url'];
          return TokenModel(
            contractAddress: (json['token_instance']
                as Map<String, dynamic>)['owner']['hash'] as String,
            name:
                ((json['token'] as Map<String, dynamic>)['name'] as String?) ??
                    '',
            symbol: ((json['token'] as Map<String, dynamic>)['symbol']
                    as String?) ??
                '',
            balance: (json['value'] as String?) ?? '',
            decimals: ((json['token_instance'] as Map<String, dynamic>)['token']
                        ['decimals'] ??
                    0)
                .toString(),
            thumbnailUri: '',
            standard: 'erc20',
            icon: icon.toString(),
            decimalsToShow: 2,
          );
        },
      ).toList();
    }

    if (offset == 0) {
      final ethereumBaseToken = await _getBaseTokenBalanceOnEtherlink(
        walletAddress,
        ethereumNetwork,
      );

      if (ethereumBaseToken != null) {
        newData.insert(0, ethereumBaseToken);
      }
      data = newData;

      if (data.length == 1) {
        final emptyTokens = await getSomeEmptyCoins(ethereumNetwork.type);
        data.addAll(emptyTokens);
      }
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
    await checkIfItNeedsToVerifyMnemonic(
      totalBalanceInUSD: totalBalanceInUSD,
    );
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
      final ethereumBaseToken = await _getBaseTokenBalanceOnEthereum(
        walletAddress,
        ethereumNetwork.chain,
        ethereumNetwork,
      );
      if (ethereumBaseToken != null) {
        newData.insert(0, ethereumBaseToken);
      }
      data = newData;

      if (data.length == 1) {
        final emptyTokens = await getSomeEmptyCoins(ethereumNetwork.type);
        data.addAll(emptyTokens);
      }
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
    await checkIfItNeedsToVerifyMnemonic(
      totalBalanceInUSD: totalBalanceInUSD,
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

      // empty coins handled in different way
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

    double totalBalanceInUSD = 0;
    if (data.length > 1) {
      final tokenListSymbols = data.map((e) => e.symbol).toList();
      final coinsList = await _getAllCoinsList();
      final filteredCoinList = coinsList
          .where(
            (element) => tokenListSymbols.map((e) => e.toLowerCase()).contains(
                  element['symbol'].toString().toLowerCase(),
                ),
          )
          .toList();

      final coinsPrice = await _getSimplePriceForCoinIds(
        filteredCoinList.map((e) => e['id'] as String).toList(),
      );

      for (final coinItem in filteredCoinList) {
        final token = data.firstWhere(
          (element) =>
              element.symbol.toLowerCase() ==
              coinItem['symbol'].toString().toLowerCase(),
        );
        final indexOfToken = data.indexOf(token);
        final coinId = coinItem['id'] as String;
        final currentPrice = coinsPrice[coinId]['usd'] as double?;

        final updatedToken = token.copyWith(
          tokenUSDPrice: currentPrice,
          balanceInUSD: token.calculatedBalanceInDouble * (currentPrice ?? 0),
          decimalsToShow: token.calculatedBalanceInDouble < 1.0 ? 5 : 2,
        );
        data[indexOfToken] = updatedToken;
      }

      data = _updateToSelectedTezosTokens(data);

      for (final tokenElement in data) {
        totalBalanceInUSD += tokenElement.balanceInUSD;
      }
      data.sort((a, b) => b.balanceInUSD.compareTo(a.balanceInUSD));
    } else {
      data = _updateToSelectedTezosTokens(data);
    }

    emit(
      state.copyWith(
        status: AppStatus.success,
        data: data.toSet(),
        totalBalanceInUSD: totalBalanceInUSD,
      ),
    );
    await checkIfItNeedsToVerifyMnemonic(
      totalBalanceInUSD: totalBalanceInUSD,
    );
  }

  void updateTokenList() {
    if (state.blockchainType == BlockchainType.tezos) {
      data = _updateToSelectedTezosTokens(data);
      emit(
        state.copyWith(
          data: data.toSet(),
        ),
      );
    }
  }

  List<TokenModel> _updateToSelectedTezosTokens(
    List<TokenModel> tokenList,
  ) {
    if (allTokensCubit.state.contracts.isNotEmpty) {
      // Filter just selected tokens to show for user
      final selectedContracts = allTokensCubit.state.selectedContracts;
      final loadedTokensSymbols =
          tokenList.map((e) => e.symbol.toLowerCase()).toList();
      final contractsNotInserted = selectedContracts
          .where(
            (element) =>
                !loadedTokensSymbols.contains(element.symbol.toLowerCase()),
          )
          .toList();

      final contractsNotInsertedSymbols =
          contractsNotInserted.map((e) => e.symbol.toLowerCase());

      ///first remove old token which added before
      tokenList.removeWhere(
        (element) =>
            element.contractAddress.isEmpty &&
            element.balance == '0' &&
            element.decimals == '0' &&
            element.standard == 'fa1.2' &&
            element.symbol != 'XTZ',
      );

      ///then add new tokens which selected
      final newTokens = allTokensCubit.state.contracts
          .where(
            (element) => contractsNotInsertedSymbols.contains(
              element.symbol.toLowerCase(),
            ),
          )
          .map(
            (e) => TokenModel(
              contractAddress: '',
              name: e.name ?? '',
              symbol: e.symbol,
              balance: '0',
              icon: e.image,
              decimals: '0',
              standard: 'fa1.2',
              decimalsToShow: 2,
            ),
          );
      tokenList.addAll(newTokens);
    }
    return tokenList;
  }

  Future<List<dynamic>> _getAllCoinsList() async {
    try {
      if (_coinList != null && _coinList!.isNotEmpty) return _coinList!;
      await dotenv.load();
      final apiKey = dotenv.get('COIN_GECKO_API_KEY');
      _coinList = await client.get(
        '${Urls.coinGeckoBase}coins/list',
        queryParameters: {
          'x_cg_pro_api_key': apiKey,
        },
      ) as List<dynamic>;
      return _coinList!;
    } catch (_) {
      return [];
    }
  }

  Future<Map<String, dynamic>> _getSimplePriceForCoinIds(
    List<String> ids,
  ) async {
    try {
      await dotenv.load();
      final apiKey = dotenv.get('COIN_GECKO_API_KEY');
      final response = await client.get(
        '${Urls.coinGeckoBase}simple/price?ids=${ids.join(',')}&vs_currencies=usd',
        queryParameters: {
          'x_cg_pro_api_key': apiKey,
        },
      ) as dynamic;
      return response as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }

  Future<TokenModel?> _getBaseTokenBalanceOnEtherlink(
    String walletAddress,
    EthereumNetwork ethereumNetwork,
  ) async {
    try {
      final response = await client.get(
        '${ethereumNetwork.apiUrl}/v2/addresses/$walletAddress',
        headers: <String, dynamic>{'Content-Type': 'application/json'},
      ) as Map<String, dynamic>;

      final coinBalance = response['coin_balance'].toString().convertTo1e18;

      return TokenModel(
        contractAddress: '',
        name: 'Etherlink',
        symbol: 'XTZ',
        icon: ethereumNetwork.mainTokenIcon,
        balance: coinBalance.toString(),
        decimals: ethereumNetwork.mainTokenDecimal,
        standard: 'ERC20',
        decimalsToShow: 5,
      );
    } catch (e, s) {
      if (e is NetworkException &&
          e.message == NetworkError.NETWORK_ERROR_NOT_FOUND) {
        return TokenModel(
          contractAddress: '',
          name: 'Etherlink',
          symbol: 'XTZ',
          icon: ethereumNetwork.mainTokenIcon,
          balance: '0',
          decimals: ethereumNetwork.mainTokenDecimal,
          standard: 'ERC20',
          decimalsToShow: 5,
        );
      }

      getLogger(toString()).e('error: $e, stack: $s');
      return null;
    }
  }

  Future<TokenModel?> _getBaseTokenBalanceOnEthereum(
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

  Future<List<TokenModel>> getSomeEmptyCoins(
    BlockchainType blockchaintype,
  ) async {
    try {
      emit(state.copyWith(status: AppStatus.loading));
      await dotenv.load();
      final apiKey = dotenv.get('COIN_GECKO_API_KEY');

      final dynamic result = await client.get(
        '${Urls.coinGeckoBase}coins/markets',
        queryParameters: {
          'vs_currency': 'usd',
          'category': blockchaintype.category,
          'order': 'market_cap_desc',
          'per_page': 10,
          'page': 1,
          'sparkline': false,
          'locale': 'en',
          'x_cg_pro_api_key': apiKey,
        },
      );
      final contracts = (result as List<dynamic>)
          .map(
            (dynamic e) => ContractModel.fromJson(e as Map<String, dynamic>),
          )
          .toList();

      final tokens = <TokenModel>[];
      for (int i = 0; i < contracts.length; i++) {
        if (i == 10) break;
        final token = contracts[i];

        if (token.symbol.toUpperCase() == blockchaintype.symbol) continue;

        tokens.add(
          TokenModel(
            name: token.name.toString(),
            symbol: token.symbol,
            icon: token.image,
            balance: '0',
            contractAddress: '',
            decimals: '18',
          ),
        );
      }

      return tokens;
    } catch (e, s) {
      getLogger(runtimeType.toString())
          .e('error in getAllContracts(), e: $e, s:$s');
      return [];
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
      // get usd balance
      final xtzUSDPrice = await _getTezosCurrentPriceInUsd() ?? 0;

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

  Future<double?> _getTezosCurrentPriceInUsd() async {
    try {
      await dotenv.load();
      final apiKey = dotenv.get('COIN_GECKO_API_KEY');

      final responseOfXTZUsdPrice = await client.get(
        '${Urls.coinGeckoBase}simple/price?ids=tezos&vs_currencies=usd',
        queryParameters: {
          'x_cg_pro_api_key': apiKey,
        },
      ) as Map<String, dynamic>;
      return responseOfXTZUsdPrice['tezos']['usd'] as double;
    } catch (_) {
      return null;
    }
  }
}
