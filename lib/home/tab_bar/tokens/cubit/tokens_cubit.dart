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
      final address =
          (await secureStorageProvider.get(SecureStorageKeys.walletAddress))!;
      final int balance = await client.get(
        '/v1/accounts/$address/balance',
      ) as int;
      final xtzToken = TokenModel(
        address,
        'Tezos',
        'XTZ',
        'assets/image/tezos.png',
        balance,
      );
      final data = List<TokenModel>.from(<TokenModel>[xtzToken]).toList();
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
}
