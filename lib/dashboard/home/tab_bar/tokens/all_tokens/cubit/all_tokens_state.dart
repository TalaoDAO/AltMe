part of 'all_tokens_cubit.dart';

@JsonSerializable()
class AllTokensState extends Equatable {
  const AllTokensState({
    this.status = AppStatus.init,
    this.message,
    this.contracts = const [],
    this.filteredContracts = const [],
    this.selectedContracts = const [],
  });

  final AppStatus status;
  final StateMessage? message;
  final List<ContractModel> contracts;
  final List<ContractModel> filteredContracts;
  final List<ContractModel> selectedContracts;

  AllTokensState copyWith({
    AppStatus? status,
    StateMessage? message,
    List<ContractModel>? contracts,
    List<ContractModel>? filteredContracts,
    List<ContractModel>? selectedContracts,
  }) {
    final state = AllTokensState(
      status: status ?? this.status,
      message: message ?? this.message,
      contracts: contracts ?? this.contracts,
      filteredContracts: filteredContracts ?? this.filteredContracts,
      selectedContracts: selectedContracts ?? this.selectedContracts,
    );
    return state;
  }

  bool containContract({required ContractModel contractModel}) {
    final contains = selectedContracts.any(
      (element) => element == contractModel,
    );
    return contains;
  }

  @override
  List<Object?> get props => [
    status,
    message,
    contracts,
    selectedContracts,
    filteredContracts,
  ];
}
