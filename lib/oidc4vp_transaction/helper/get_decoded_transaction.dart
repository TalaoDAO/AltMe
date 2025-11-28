import 'package:altme/oidc4vp_transaction/oidc4vp_transaction.dart';
import 'package:altme/scan/cubit/scan_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

List<dynamic> getDecodedTransactions(BuildContext context) {
  final transactionInfo = context.read<ScanCubit>().state.transactionData;
  final List<dynamic> decodedTransactions = Oidc4vpTransaction(
    transactionData: transactionInfo!,
  ).decodeTransactions();
  return decodedTransactions;
}
