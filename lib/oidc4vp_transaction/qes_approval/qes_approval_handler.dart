import 'package:altme/l10n/l10n.dart';
import 'package:altme/oidc4vp_transaction/qes_approval/qes_approval_card.dart';
import 'package:altme/oidc4vp_transaction/qes_approval/qes_documents_review.dart';
import 'package:altme/oidc4vp_transaction/transaction_handler.dart';
import 'package:flutter/material.dart';
import 'package:oidc4vc/oidc4vc.dart';

/// A remote signing service's request to approve a qualified electronic
/// signature (CSC qes-approval).
class QesApprovalHandler extends TransactionHandler {
  const QesApprovalHandler();

  @override
  TransactionDataType get dataType => const QesApprovalTransactionType();

  @override
  Widget buildReview(
    BuildContext context,
    TransactionDataItem item, {
    required VoidCallback onContinue,
  }) => QesDocumentsReview(
    request: QesApprovalRequest.fromItem(item),
    onContinue: onContinue,
  );

  @override
  Widget buildConsent(BuildContext context, TransactionDataItem item) =>
      QesApprovalCard(request: QesApprovalRequest.fromItem(item));

  @override
  String confirmLabel(AppLocalizations l10n) => l10n.sign;
}
