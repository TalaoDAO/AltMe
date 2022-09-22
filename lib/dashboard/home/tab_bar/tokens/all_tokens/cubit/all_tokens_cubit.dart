import 'dart:convert';
import 'package:altme/app/app.dart';
import 'package:altme/dashboard/home/home.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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

      final dynamic result = await client.get(Urls.tezToolPrices);
      final contracts = (result['contracts'] as List<dynamic>)
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
        ).i('returned selectedContracts from storage: $selectedContracts');
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
      selectedContracs.addAll(const [
        ContractModel(
          symbol: 'ENR',
          address: 'KT1GxxLmBC7tfx4Enpe5YLaCXppAKKfzNRYF',
          thumbnailUri: '',
          decimals: 9,
          name: 'Energy',
          currentPrice: 0,
          buyPrice: 0,
          sellPrice: 0,
          precision: 0,
          type: 'fa2',
          totalSupply: 0,
          qptTokenSupply: 0,
          usdValue: 0,
        ),
        ContractModel(
          symbol: 'UNO',
          address: 'KT1Cq3pyv6QEXugsAC2iyXr7ecFqN7fJVTnA',
          thumbnailUri: '',
          decimals: 9,
          name: 'Unobtanium',
          currentPrice: 0,
          buyPrice: 0,
          sellPrice: 0,
          precision: 0,
          type: 'fa2',
          totalSupply: 0,
          qptTokenSupply: 0,
          usdValue: 0,
        ),
        ContractModel(
          symbol: 'MCH',
          address: 'KT1JAgJC6FTJ9SzGGits8GVonCr8cfFp5HGV',
          thumbnailUri: '',
          decimals: 9,
          name: 'Machinery',
          currentPrice: 0,
          buyPrice: 0,
          sellPrice: 0,
          precision: 0,
          type: 'fa2',
          totalSupply: 0,
          qptTokenSupply: 0,
          usdValue: 0,
        ),
        ContractModel(
          symbol: 'MIN',
          address: 'KT1H5YwfF6nmFZavwzftddbcfxAXmbGhyDCY',
          thumbnailUri: '',
          decimals: 9,
          name: 'Minerals',
          currentPrice: 0,
          buyPrice: 0,
          sellPrice: 0,
          precision: 0,
          type: 'fa2',
          totalSupply: 0,
          qptTokenSupply: 0,
          usdValue: 0,
        ),
        ContractModel(
          symbol: 'GIF',
          address: 'KT1LuXT6jZPhUH1qCnSUqAzFedjoBwePLQnF',
          thumbnailUri: '',
          decimals: 9,
          name: 'GIF DAO',
          currentPrice: 0,
          buyPrice: 0,
          sellPrice: 0,
          precision: 0,
          type: 'fa2',
          totalSupply: 0,
          qptTokenSupply: 0,
          usdValue: 0,
        ),
        ContractModel(
          symbol: 'DOGA',
          address: 'KT1Ucg1fTZXBD8P426rTRXyu7YQUgYXV7RVu',
          thumbnailUri: '',
          decimals: 9,
          name: 'DOGAMI',
          currentPrice: 0,
          buyPrice: 0,
          sellPrice: 0,
          precision: 0,
          type: 'fa2',
          totalSupply: 0,
          qptTokenSupply: 0,
          usdValue: 0,
        ),
        ContractModel(
          symbol: 'kDAO',
          address: 'KT1NEa7CmaLaWgHNi6LkRi5Z1f4oHfdzRdGA',
          thumbnailUri: '',
          decimals: 9,
          name: 'Kolibri DAO',
          currentPrice: 0,
          buyPrice: 0,
          sellPrice: 0,
          precision: 0,
          type: 'fa2',
          totalSupply: 0,
          qptTokenSupply: 0,
          usdValue: 0,
        ),
        ContractModel(
          symbol: 'wBUSD',
          address: 'KT1UMAE2PBskeQayP5f2ZbGiVYF7h8bZ2gyp',
          thumbnailUri: '',
          decimals: 9,
          name: 'Wrapped BUSD',
          currentPrice: 0,
          buyPrice: 0,
          sellPrice: 0,
          precision: 0,
          type: 'fa2',
          totalSupply: 0,
          qptTokenSupply: 0,
          usdValue: 0,
        ),
      ]);
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
    if (state.selectedContracts
        .map((e) => e.address)
        .contains(contractModel.address)) {
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
        !state.selectedContracts
            .map((e) => e.address)
            .contains(contractModel.address)) {
      return;
    }
    emit(
      state.copyWith(
        selectedContracts: List.from(state.selectedContracts)
          ..removeWhere((e) => e.address == contractModel.address),
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
