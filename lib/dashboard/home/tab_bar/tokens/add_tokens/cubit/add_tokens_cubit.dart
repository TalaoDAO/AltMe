import 'package:altme/app/app.dart';
import 'package:altme/dashboard/home/home.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'add_tokens_cubit.g.dart';
part 'add_tokens_state.dart';

class AddTokensCubit extends Cubit<AddTokensState> {
  AddTokensCubit({
    required this.client,
  }) : super(const AddTokensState());

  final DioClient client;

  Future<List<ContractModel>?> getAllContracts() async {
    try {
      emit(state.copyWith(status: AppStatus.loading));

      final dynamic result = await client.get(Urls.tezToolPrices);
      final contracts = (result['contracts'] as List<dynamic>)
          .map(
            (dynamic e) => ContractModel.fromJson(e as Map<String, dynamic>),
          )
          .toList();
      emit(state.copyWith(contracts: contracts, status: AppStatus.loading));
      return contracts;
    } catch (e, s) {
      emit(
        state.copyWith(
          status: AppStatus.error,
          message: const StateMessage.error(),
        ),
      );
      getLogger(runtimeType.toString())
          .e('error in getAllContracts(), e: $e, s:$s');
      return null;
    }
  }
}
