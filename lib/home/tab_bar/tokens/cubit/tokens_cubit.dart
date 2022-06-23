import 'package:altme/app/app.dart';
import 'package:altme/home/home.dart';
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
    required this.secureStorageProvider,
    required this.walletCubit,
  }) : super(const TokensState()) {
    getBalanceOfAssetList();
  }

  final DioClient client;
  final SecureStorageProvider secureStorageProvider;
  final WalletCubit walletCubit;

  Future<void> getBalanceOfAssetList() async {
    try {
      emit(state.fetching());
      final activeIndex = walletCubit.state.currentIndex;
      final walletAddress = await secureStorageProvider
          .get('${SecureStorageKeys.walletAddresss}/$activeIndex');
      final List<dynamic> tokensBalancesJsonArray = await client.get(
        '/v1/tokens/balances',
        queryParameters: <String, dynamic>{
          'account': walletAddress,
          'token.contract.in':
              '''KT1GRSvLoikDsXujKgZPsGLX8k8VvR2Tq95b,KT193D4vozYnhGJQVtw7CoxxqphqUEEwK6Vb,KT1M81KrJr6TxYLkZkVqcpSTNKGoya8XytWT,KT1Xobej4mc6XgEjDoJoHtTKgbD1ELMvcQuL,KT1K9gCRgaLRFKTErYt1wVxA3Frb9FjasjTV,KT1LN4LPSqTMS7Sd2CJw4bbDGRkMv2t68Fy9,KT1SjXiUX63QvdNMcM2m492f7kuf8JxXRLp4,KT1Ha4yFVeyzw6KRAdkzq6TxDHB97KG4pZe8''',
          'select':
              '''token.contract.address as contractAddress,token.tokenId as tokenId,token.metadata.symbol as symbol,token.metadata.name as name,balance,token.metadata.icon as icon,token.metadata.thumbnailUri as thumbnailUri''',
        },
      ) as List<dynamic>;

      if (tokensBalancesJsonArray.isNotEmpty) {
        final data = tokensBalancesJsonArray
            .map(
              (dynamic json) =>
                  TokenModel.fromJson(json as Map<String, dynamic>),
            )
            .toList();

        emit(state.populate(data: data));
      } else {
        emit(state.populate(data: []));
      }
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
