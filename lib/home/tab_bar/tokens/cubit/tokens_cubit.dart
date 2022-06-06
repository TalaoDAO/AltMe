import 'package:altme/app/app.dart';
import 'package:altme/home/home.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tokens_cubit.g.dart';

part 'tokens_state.dart';

class TokensCubit extends Cubit<TokensState> {
  TokensCubit({required this.client}) : super(const TokensState());

  final DioClient client;

  Future<void> getBalanceOfAssetList() async {
    try {
      emit(state.loading());
      final int balance = await client.get(
        // TODO(all): remove hardcoded Tezos address in the path of api
        '/v1/accounts/tz1dKRZVcmJBVNvaAueUmqX42vVEaLb2MbA6/balance',
      ) as int;
      final xtzToken = TokenModel(
        'tz1dKRZVcmJBVNvaAueUmqX42vVEaLb2MbA6',
        'Tezos',
        'XTZ',
        'assets/image/tezos.png',
        balance,
      );
      final data = List<TokenModel>.from(<TokenModel>[xtzToken]).toList();
      emit(state.success(data: data));
    } catch (e) {
      if (isClosed) return;
      emit(
        state.error(
          messageHandler: ResponseMessage(
            ResponseString.RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
          ),
        ),
      );
    }
  }
}
