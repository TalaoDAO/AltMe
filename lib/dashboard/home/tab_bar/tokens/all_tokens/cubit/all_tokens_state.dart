part of 'all_tokens_cubit.dart';

@JsonSerializable()
class AllTokensState extends Equatable {
  const AllTokensState({
    this.status = AppStatus.init,
    this.message,
    this.contracts = const [],
    this.filteredContracts = const [],
    this.selectedContracts = const [],
    this.xtzUsdValue,
  });

  final AppStatus status;
  final StateMessage? message;
  final double? xtzUsdValue;
  final List<ContractModel> contracts;
  final List<ContractModel> filteredContracts;
  final List<String> selectedContracts;

  AllTokensState copyWith({
    AppStatus? status,
    StateMessage? message,
    List<ContractModel>? contracts,
    List<ContractModel>? filteredContracts,
    List<String>? selectedContracts,
    double? xtzUsdValue,
  }) {
    return AllTokensState(
      status: status ?? this.status,
      message: message ?? this.message,
      contracts: contracts ?? this.contracts,
      xtzUsdValue: xtzUsdValue ?? this.xtzUsdValue,
      filteredContracts: filteredContracts ?? this.filteredContracts,
      selectedContracts: selectedContracts ?? this.selectedContracts,
    );
  }

  @override
  List<Object?> get props => [
        status,
        message,
        contracts,
        selectedContracts,
        filteredContracts,
        xtzUsdValue,
      ];
}
