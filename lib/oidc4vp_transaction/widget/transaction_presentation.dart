import 'package:altme/oidc4vp_transaction/helper/get_decoded_transaction.dart';
import 'package:flutter/material.dart';

class TransactionPresentation extends StatelessWidget {
  const TransactionPresentation({super.key});

  @override
  Widget build(BuildContext context) {
    final List<dynamic> decodedTransactions = getDecodedTransactions(context);

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: decodedTransactions.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final tx = decodedTransactions[index];
        final uiHints = tx['ui_hints'] ?? <String, dynamic>{};
        final title = uiHints['title'] as String? ?? '';
        final subtitle = uiHints['subtitle'] as String? ?? '';
        final purpose = uiHints['purpose'] as String? ?? '';
        return ListTile(
          title: Text(title),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text(subtitle), Text('Purpose: $purpose')],
          ),
        );
      },
    );
  }
}
