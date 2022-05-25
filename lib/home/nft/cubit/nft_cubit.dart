import 'package:altme/app/app.dart';
import 'package:altme/home/nft/models/models.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'nft_cubit.g.dart';
part 'nft_state.dart';

class NftCubit extends Cubit<NftState> {
  NftCubit({required this.client}) : super(const NftState());

  final DioClient client;

  Future<void> getTezosNftList() async {
    try {
      emit(state.loading());
      final List<dynamic> response = await client.get(
        '/v1/tokens/balances',
        queryParameters: <String, dynamic>{
          // TODO(all): remove hardcoded tezos nft contract and account address
          'token.contract': 'KT1RJ6PbjHpwc3M5rw5s2Nbmefwbuwbdxton',
          'account': 'tz1VPZyh4ZHjDDpgvznqQQXUCLcV7g91WGMz',
          'select':
              '''token.tokenId as id,token.metadata.name as name,token.metadata.displayUri as displayUri,balance''',
        },
      ) as List<dynamic>;
      // TODO(all): check the balance variable of NFTModel and get right value from api
      final List<NftModel> data = response
          .map((dynamic e) => NftModel.fromJson(e as Map<String, dynamic>))
          .toList();
      emit(state.success(data: data));
    } catch (e) {
      // TODO(all): handle error message localization and error message
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
