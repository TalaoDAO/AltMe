part of 'transaction_data_cubit.dart';

enum TransactionDataStatus { idle, preparing, finished }

class TransactionDataState extends Equatable {
  const TransactionDataState({
    this.status = TransactionDataStatus.idle,
    required this.currentIndex,
    required this.currentTransaction,
    required this.transactions,
  });

  final TransactionDataStatus status;
  final int currentIndex;
  final Oidc4vpTransaction currentTransaction;
  final List<Oidc4vpTransaction> transactions;

  TransactionDataState copyWith({
    TransactionDataStatus? status,
    int? currentIndex,
    Oidc4vpTransaction? currentTransaction,
    List<Oidc4vpTransaction>? transactions,
  }) {
    return TransactionDataState(
      status: status ?? this.status,
      currentIndex: currentIndex ?? this.currentIndex,
      currentTransaction: currentTransaction ?? this.currentTransaction,
      transactions: transactions ?? this.transactions,
    );
  }

  @override
  List<Object?> get props => [
        status,
        currentIndex,
        currentTransaction,
        transactions,
      ];
}
