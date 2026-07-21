import 'package:altme/oidc4vp_transaction/domain/oidc4vp_transaction.dart';
import 'package:flutter/material.dart';

class SignaturePresentation extends StatelessWidget {
  const SignaturePresentation(this.signatureTransaction, {super.key});
  final SignatureTransaction signatureTransaction;

  @override
  Widget build(BuildContext context) {
    final uiHints =
        signatureTransaction.transactionJson['ui_hints'] ?? <String, dynamic>{};
    final purpose = uiHints['purpose'] as String? ?? '';
    final image = uiHints['icon_uri'] as String? ?? '';
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Image.network(
            image,
            height: 80,
            width: 80,
            errorBuilder: (context, error, stackTrace) {
              return const SizedBox.shrink();
            },
          ),
        ),
        Center(
          child: Text(
            purpose,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
