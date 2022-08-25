import 'dart:convert';
import 'package:altme/app/app.dart';
import 'package:altme/dashboard/home/home.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:secure_storage/secure_storage.dart';

part 'add_tokens_cubit.g.dart';
part 'add_tokens_state.dart';

class AddTokensCubit extends Cubit<AddTokensState> {
  AddTokensCubit({
    required this.client,
    required this.secureStorageProvider,
  }) : super(const AddTokensState());

  final DioClient client;
  final SecureStorageProvider secureStorageProvider;

  Future<void> init() async {
    await getAllContracts();
    await getSelectedContracts();
  }

  Future<List<ContractModel>?> getAllContracts() async {
    try {
      emit(state.copyWith(status: AppStatus.loading));

      final dynamic result = await client.get(Urls.tezToolPrices);
      final contracts = (result['contracts'] as List<dynamic>)
          .map(
            (dynamic e) => ContractModel.fromJson(e as Map<String, dynamic>),
          )
          .toList();
      emit(state.copyWith(contracts: contracts, status: AppStatus.populate));
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

  Future<List<String>> getSelectedContracts() async {
    try {
      final result =
          await secureStorageProvider.get(SecureStorageKeys.selectedContracts);
      if (result == null) {
        return [];
      } else {
        final json = jsonDecode(result) as List<dynamic>;
        final selectedContracts = json.map((dynamic e) => e as String).toList();
        emit(state.copyWith(selectedContracts: selectedContracts));
        getLogger(
          runtimeType.toString(),
        ).i('returned selectedContracts from storage: $selectedContracts');
        return selectedContracts;
      }
    } catch (e, s) {
      getLogger(
        runtimeType.toString(),
      ).e('error in get contracts from secureStorage, e: $e, s: $s');
      return [];
    }
  }

  void addContract({required String contractAddress}) {
    if (state.selectedContracts.contains(contractAddress)) {
      return;
    }
    emit(
      state.copyWith(
        selectedContracts: [
          ...state.selectedContracts,
          contractAddress,
        ],
      ),
    );
  }

  void removeContract({required String contractAddress}) {
    if (state.selectedContracts.isEmpty ||
        !state.selectedContracts.contains(contractAddress)) {
      return;
    }
    emit(
      state.copyWith(
        selectedContracts: List.from(state.selectedContracts)
          ..remove(contractAddress),
      ),
    );
  }

  Future<void> saveSelectedContracts() async {
    try {
      emit(state.copyWith(status: AppStatus.fetching));
      await secureStorageProvider.set(
        SecureStorageKeys.selectedContracts,
        jsonEncode(state.selectedContracts),
      );
      emit(state.copyWith(status: AppStatus.success));
      getLogger(runtimeType.toString())
          .i('saved selected contracts: ${state.selectedContracts}');
    } catch (e, s) {
      getLogger(runtimeType.toString())
          .e('error in save contracts, e: $e, s: $s');
    }
  }
}
