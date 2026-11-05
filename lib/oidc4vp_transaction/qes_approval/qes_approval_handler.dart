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
  Widget? buildReview(
    BuildContext context,
    TransactionDataItem item, {
    required VoidCallback onContinue,
  }) {
    final request = QesApprovalRequest.fromItem(item);
    // Without a document to load there is nothing to read: go on to the
    // signature.
    if (request.documentInfos.every((document) => document.href == null)) {
      return null;
    }
    return QesDocumentsReview(request: request, onContinue: onContinue);
  }

  @override
  Widget buildConsent(BuildContext context, TransactionDataItem item) =>
      QesApprovalCard(request: QesApprovalRequest.fromItem(item));

  @override
  String confirmLabel(AppLocalizations l10n) => l10n.sign;
}
