import 'package:altme/app/app.dart';
import 'package:altme/nft/cubit/nft_state.dart';
import 'package:altme/nft/models/index.dart';
import 'package:bloc/bloc.dart';

class NftCubit extends Cubit<NftState> {
  NftCubit({required this.client}) : super(NftState.loading());

  final DioClient client;

  Future<void> getTezosNftList() async {
    try {
      emit(NftState.loading());
      final List<dynamic> response = await client.get(
        '/v1/tokens/balances',
        queryParameters: <String, dynamic>{
          // TODO(all): remove hardcoded tezos nft contract and account address
          'token.contract': 'KT1RJ6PbjHpwc3M5rw5s2Nbmefwbuwbdxton',
          'account': 'tz1VPZyh4ZHjDDpgvznqQQXUCLcV7g91WGMz',
          'select':
              'token.tokenId as id,token.metadata.name as name,token.metadata.displayUri as displayUri,balance',
        },
      ) as List<dynamic>;
      final List<NftModel> data = response
          .map((dynamic e) => NftModel.fromJson(e as Map<String, dynamic>))
          .toList();
      emit(NftState.loaded(data));
    } catch (e, s) {
      // TODO(all): handle error message localization
      emit(NftState.error(e.toString()));
    }
  }
}
