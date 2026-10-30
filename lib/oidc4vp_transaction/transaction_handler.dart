import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:oidc4vc/oidc4vc.dart';

/// How the wallet handles one `transaction_data` type in an OpenID4VP 1.0
/// presentation: its protocol rules ([dataType]) and what the user sees
/// before approving. The presentation flow never names a type: an app
/// supports one by registering its handler in `Parameters.transactionHandlers`.
abstract class TransactionHandler {
  const TransactionHandler();

  TransactionDataType get dataType;

  /// What the user approves, shown above the credentials of the request.
  Widget buildConsent(BuildContext context, TransactionDataItem item);

  /// The label of the button that sends the presentation.
  String confirmLabel(AppLocalizations l10n);
}

/// The [TransactionHandler]s of an app.
class TransactionHandlers {
  const TransactionHandlers(this._handlers);

  final List<TransactionHandler> _handlers;

  /// The protocol rules of the supported types.
  TransactionDataTypes get dataTypes =>
      TransactionDataTypes(_handlers.map((handler) => handler.dataType));

  /// The handler of [item], whose type [dataTypes] accepted.
  TransactionHandler of(TransactionDataItem item) =>
      _handlers.firstWhere((handler) => handler.dataType.type == item.type);
}
