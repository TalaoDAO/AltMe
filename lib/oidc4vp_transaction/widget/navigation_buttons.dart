import 'package:altme/oidc4vp_transaction/domain/oidc4vp_transaction.dart';
import 'package:altme/oidc4vp_transaction/presentation/cubit/transaction_data_cubit.dart';
import 'package:altme/oidc4vp_transaction/presentation/payment_transaction/payment_accept_button.dart';
import 'package:altme/oidc4vp_transaction/presentation/signature_transaction/signature_accept_button.dart';
import 'package:altme/oidc4vp_transaction/widget/refuse_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavigationButtons extends StatelessWidget {
  const NavigationButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 143,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: BlocBuilder<TransactionDataCubit, TransactionDataState>(
              builder: (context, state) {
                final currentTransaction = state.currentTransaction;
                switch (currentTransaction) {
                  case final PaymentTransaction paymentTransaction:
                   return PaymentAcceptButton(paymentTransaction);
                  case final SignatureTransaction signatureTransaction:
                    return SignatureAcceptButton(
                      signatureTransaction,
                    );
                }
              },
            ),
          ),
          const Padding(padding: EdgeInsets.all(8), child: RefuseButton()),
        ],
      ),
    );
  }
}

