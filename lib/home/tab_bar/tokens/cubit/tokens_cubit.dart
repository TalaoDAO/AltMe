import 'package:altme/app/app.dart';
import 'package:altme/home/home.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:secure_storage/secure_storage.dart';

part 'tokens_cubit.g.dart';

part 'tokens_state.dart';

class TokensCubit extends Cubit<TokensState> {
  TokensCubit({required this.client, required this.secureStorageProvider})
      : super(const TokensState()) {
    getBalanceOfAssetList();
  }

  final DioClient client;
  final SecureStorageProvider secureStorageProvider;

  Future<void> getBalanceOfAssetList() async {
    try {
      emit(state.fetching());
      final did = await secureStorageProvider.get(SecureStorageKeys.did);
      if (did?.isEmpty ?? true) {
        emit(state.populate(data: []));
        return;
      }
      final didKeyHelper = DidKeyHelper(did!);
      final address = didKeyHelper.getAddress();
      if (address?.isEmpty ?? true) {
        emit(state.populate(data: []));
        return;
      }

      final addressType = didKeyHelper.getAddressType();
      TokenModel? tokenModel;
      switch (addressType) {
        case AddressType.XTZ:
          tokenModel = await getBalanceOfTezosAddress(address!);
          break;
        case AddressType.ETH:
          tokenModel = await getBalanceOfEthAddress(address!);
          break;
        case AddressType.EBSI:
          // TODO: Handle this case.
          break;
        case AddressType.Unknown:
          // TODO: Handle this case.
          break;
      }

      final data =
          tokenModel == null ? <TokenModel>[] : <TokenModel>[tokenModel];
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

  Future<TokenModel> getBalanceOfTezosAddress(String tezosAddress) async {
    final int balance = await client.get(
      '${Urls.tezosNftBaseUrl}/v1/accounts/$tezosAddress/balance',
    ) as int;
    return TokenModel(
      tezosAddress,
      'Tezos',
      'XTZ',
      'assets/image/tezos.png',
      balance,
    );
  }

  Future<TokenModel> getBalanceOfEthAddress(String tezosAddress) async {
    // TODO(all): implement get balance for ETH address
    return TokenModel('contract', 'name', 'symbol', 'logoPath', 0);
  }
}
