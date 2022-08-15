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

  Future<void> getOperations({String baseUrl = ''}) async {
    try {
      emit(state.loading());

      final activeIndex = walletCubit.state.currentCryptoIndex;
      final walletAddress =
          walletCubit.state.cryptoAccount.data[activeIndex].walletAddress;

      final result =
          await client.get('$baseUrl/v1/accounts/$walletAddress/operations')
              as List<dynamic>;

      final operations = result
          .map(
            (dynamic e) => OperationModel.fromJson(e as Map<String, dynamic>),
          )
          .toList();

      emit(state.success(operations: operations));
    } catch (e, s) {
      emit(state.error(messageHandler: MessageHandler()));
      getLogger(runtimeType.toString())
          .e('error in getOperations() e: $e, $s', e, s);
    }
  }
}
