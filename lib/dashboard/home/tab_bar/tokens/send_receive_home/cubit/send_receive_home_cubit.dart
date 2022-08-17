import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'send_receive_home_cubit.g.dart';

part 'send_receive_home_state.dart';

class SendReceiveHomeCubit extends Cubit<SendReceiveHomeState> {
  SendReceiveHomeCubit({
    required this.client,
    required this.walletCubit,
  }) : super(const SendReceiveHomeState());

  final DioClient client;
  final WalletCubit walletCubit;

  Future<void> init({String baseUrl = ''}) async {
    try {
      emit(state.loading());
      final xtz = await getXtzBalance(
        baseUrl,
        walletCubit.state.currentAccount.walletAddress,
      );
      emit(state.copyWith(xtz: xtz));
      final operations = await _getOperations(baseUrl);
      emit(state.success(operations: operations));
    } catch (e, s) {
      emit(state.error(messageHandler: MessageHandler()));
      getLogger(runtimeType.toString()).e('error in init() e: $e, $s', e, s);
    }
  }

  Future<void> getOperations({String baseUrl = ''}) async {
    try {
      emit(state.loading());

      final operations = await _getOperations(baseUrl);

      emit(state.success(operations: operations));
    } catch (e, s) {
      emit(state.error(messageHandler: MessageHandler()));
      getLogger(runtimeType.toString())
          .e('error in getOperations() e: $e, $s', e, s);
    }
  }

  Future<List<OperationModel>> _getOperations(String baseUrl) async {
    final activeIndex = walletCubit.state.currentCryptoIndex;
    final walletAddress =
        walletCubit.state.cryptoAccount.data[activeIndex].walletAddress;

    final result = await client.get(
      '$baseUrl/v1/operations/transactions',
      queryParameters: <String, dynamic>{
        'anyof.sender.target': walletAddress,
        'amount.gt': 0,
      },
    ) as List<dynamic>;

    final operations = result
        .map(
          (dynamic e) => OperationModel.fromJson(e as Map<String, dynamic>),
        )
        .toList();
    return operations;
  }

  Future<TokenModel> getXtzBalance(String baseUrl, String walletAddress) async {
    final int balance =
        await client.get('$baseUrl/v1/accounts/$walletAddress/balance') as int;

    return TokenModel(
      '',
      'Tezos',
      'XTZ',
      'https://s2.coinmarketcap.com/static/img/coins/64x64/2011.png',
      '',
      balance.toString(),
      '6',
    );
  }
}
