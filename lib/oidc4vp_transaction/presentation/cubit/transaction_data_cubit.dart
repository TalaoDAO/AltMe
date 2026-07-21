import 'package:altme/oidc4vp_transaction/domain/oidc4vp_transaction.dart';
import 'package:altme/oidc4vp_transaction/domain/transaction_data.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'transaction_data_state.dart';

class TransactionDataCubit extends Cubit<TransactionDataState> {
  TransactionDataCubit({required this.transactionData})
      : super(
          TransactionDataState(
            currentIndex: 0,
            currentTransaction: transactionData.transactions.first,
            transactions: transactionData.transactions,
          ),
        );

  final TransactionData transactionData;

  /// Updates the current transaction in the list with the provided [updated]
  /// value, increments the index, and sets the current transaction to the
  /// next one. If there is no next transaction, emits the [finished] state.
  Future<void> prepare({required Oidc4vpTransaction updated}) async {
    // Build an updated copy of the transactions list with the current item
    // replaced by the updated version.
    final updatedTransactions = List<Oidc4vpTransaction>.of(state.transactions);
    updatedTransactions[state.currentIndex] = updated;

    final nextIndex = state.currentIndex + 1;

    if (nextIndex >= updatedTransactions.length) {
      // No more transactions — emit the finished state.
      emit(
        state.copyWith(
          status: TransactionDataStatus.finished,
          transactions: updatedTransactions,
        ),
      );
    } else {
      // Advance to the next transaction.
      emit(
        state.copyWith(
          status: TransactionDataStatus.preparing,
          transactions: updatedTransactions,
          currentIndex: nextIndex,
          currentTransaction: updatedTransactions[nextIndex],
        ),
      );
    }
  }
}
