import 'package:altme/oidc4vp_transaction/domain/oidc4vp_transaction.dart';
import 'package:altme/oidc4vp_transaction/presentation/cubit/transaction_data_cubit.dart';
import 'package:altme/oidc4vp_transaction/presentation/signature_transaction/signature_presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionPresentation extends StatelessWidget {
  const TransactionPresentation({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionDataCubit, TransactionDataState>(
      builder: (context, state) {
        return switch (state.currentTransaction) {
          final SignatureTransaction signatureTransaction =>
            SignaturePresentation(signatureTransaction),
        };
      },
    );
  }
}
