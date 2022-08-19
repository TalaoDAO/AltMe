part of 'add_tokens_cubit.dart';

@JsonSerializable()
class AddTokensState extends Equatable {
  
  const AddTokensState({
    this.status = AppStatus.init,
    this.message,
    this.contracts = const [],
  });

  final AppStatus status;
  final StateMessage? message;
  final List<ContractModel> contracts;

  AddTokensState copyWith({
    AppStatus? status,
    StateMessage? message,
    List<ContractModel>? contracts,
  }) {
    return AddTokensState(
      status: status ?? this.status,
      message: message ?? this.message,
      contracts: contracts ?? this.contracts,
    );
  }

  @override
  List<Object?> get props => [
        status,
        message,
        contracts,
      ];
}
