import 'dart:convert';
import 'package:altme/app/app.dart';
import 'package:altme/dashboard/home/home.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:secure_storage/secure_storage.dart';

part 'all_tokens_cubit.g.dart';
part 'all_tokens_state.dart';

class AllTokensCubit extends Cubit<AllTokensState> {
  AllTokensCubit({
    required this.client,
    required this.secureStorageProvider,
  }) : super(const AllTokensState());

  final DioClient client;
  final SecureStorageProvider secureStorageProvider;

  Future<void> init() async {
    await getAllContracts();
    await getSelectedContracts();
  }

  Future<List<ContractModel>?> getAllContracts() async {
    try {
      emit(state.copyWith(status: AppStatus.loading));
      await dotenv.load();
      final apiKey = dotenv.get('COIN_GECKO_API_KEY');

      final dynamic result = await client.get(
        '/coins/markets',
        queryParameters: {
          'vs_currency': 'usd',
          'category': 'tezos-ecosystem',
          'order': 'market_cap_desc',
          'per_page': 1000,
          'page': 1,
          'sparkline': false,
          'locale': 'en',
          'x_cg_pro_api_key': apiKey,
        },
      );
      final contracts = (result as List<dynamic>)
          .map(
            (dynamic e) => ContractModel.fromJson(e as Map<String, dynamic>),
          )
          .toList();
      emit(
        state.copyWith(
          contracts: contracts,
          filteredContracts: contracts,
          status: AppStatus.populate,
        ),
      );
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

  void filterTokens({String? value}) {
    if (value == null || value.isEmpty) {
      emit(state.copyWith(filteredContracts: state.contracts));
    } else {
      final filteredContracts = state.contracts
          .where(
            (element) =>
                (element.name?.toLowerCase().contains(value.toLowerCase()) ??
                    false) ||
                element.symbol.toLowerCase().contains(value.toLowerCase()),
          )
          .toList();
      emit(state.copyWith(filteredContracts: filteredContracts));
    }
  }

  Future<List<ContractModel>> getSelectedContracts() async {
    try {
      final result =
          await secureStorageProvider.get(SecureStorageKeys.selectedContracts);
      if (result == null) {
        final data = await setDefaultSelectedContractIfFirstTime([]);
        emit(state.copyWith(selectedContracts: data));
        return data;
      } else {
        final json = jsonDecode(result) as List<dynamic>;
        final selectedContracts = json
            .map(
              (dynamic e) => ContractModel.fromJson(e as Map<String, dynamic>),
            )
            .toList();
        final data =
            await setDefaultSelectedContractIfFirstTime(selectedContracts);
        emit(state.copyWith(selectedContracts: data));
        getLogger(
          'Tokens cubit',
        ).i(
          'returned selectedContracts from storage'
          ' lenght: ${selectedContracts.length}',
        );
        return data;
      }
    } catch (e, s) {
      emit(state.copyWith(selectedContracts: []));
      getLogger(
        runtimeType.toString(),
      ).e('error in get contracts from secureStorage, e: $e, s: $s');
      return setDefaultSelectedContractIfFirstTime([]);
    }
  }

  Future<List<ContractModel>> setDefaultSelectedContractIfFirstTime(
    List<ContractModel> selectedContracs,
  ) async {
    final isFirstSelectedTokenContracts = (await secureStorageProvider
            .get(SecureStorageKeys.isFirstSelectedTokenContracts)) ??
        true.toString();
    if (isFirstSelectedTokenContracts == 'true') {
      await secureStorageProvider.set(
        SecureStorageKeys.isFirstSelectedTokenContracts,
        false.toString(),
      );

      for (int i = 0; i < state.contracts.length; i++) {
        if (i == 6) break;
        final token = state.contracts[i];

        if (token.symbol.toUpperCase() == 'XTZ') continue;

        selectedContracs.add(
          ContractModel(
            name: token.name.toString(),
            symbol: token.symbol,
            image: token.image,
            currentPrice: 0,
            id: '',
          ),
        );
      }

      await secureStorageProvider.set(
        SecureStorageKeys.selectedContracts,
        jsonEncode(selectedContracs.map((e) => e.toJson()).toList()),
      );
      return selectedContracs;
    } else {
      return selectedContracs;
    }
  }

  void addContract({required ContractModel contractModel}) {
    if (state.selectedContracts.map((e) => e.id).contains(contractModel.id)) {
      return;
    }
    emit(
      state.copyWith(
        selectedContracts: [
          ...state.selectedContracts,
          contractModel,
        ],
      ),
    );
  }

  void removeContract({required ContractModel contractModel}) {
    if (state.selectedContracts.isEmpty ||
        !state.selectedContracts.map((e) => e.id).contains(contractModel.id)) {
      return;
    }
    emit(
      state.copyWith(
        selectedContracts: List.from(state.selectedContracts)
          ..removeWhere((e) => e.id == contractModel.id),
      ),
    );
  }

  Future<void> saveSelectedContracts() async {
    try {
      emit(state.copyWith(status: AppStatus.fetching));
      await secureStorageProvider.set(
        SecureStorageKeys.selectedContracts,
        jsonEncode(state.selectedContracts.map((e) => e.toJson()).toList()),
      );
      emit(state.copyWith(status: AppStatus.success));
      getLogger('Tokens cubit')
          .i('saved selected contracts: ${state.selectedContracts}');
    } catch (e, s) {
      getLogger(runtimeType.toString())
          .e('error in save contracts, e: $e, s: $s');
    }
  }
}
