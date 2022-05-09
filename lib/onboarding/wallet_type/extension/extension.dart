import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart' show BuildContext;

extension WalletTypeX on WalletType {
  String stringValue(BuildContext context) {
    final l10n = context.l10n;
    if (this == WalletType.enterprise) {
      return l10n.enterpriseWallet;
    } else {
      return l10n.personalWallet;
    }
  }
}
