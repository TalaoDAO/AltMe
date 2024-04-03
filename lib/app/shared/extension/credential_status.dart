import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

extension CredentialStatusExtension on CredentialStatus {
  String message(BuildContext context) {
    final l10n = context.l10n;
    switch (this) {
      case CredentialStatus.active:
        return l10n.cardIsValid;
      case CredentialStatus.expired:
        return l10n.cardIsExpired;
      case CredentialStatus.invalidSignature:
        return l10n.signatureIsInvalid;
      case CredentialStatus.pending:
        return l10n.cardsPending;
      case CredentialStatus.unknown:
        return l10n.unknown;
      case CredentialStatus.invalidStatus:
        return l10n.statusIsInvalid;
      case CredentialStatus.noStatus:
        return '';
    }
  }

  IconData get icon {
    switch (this) {
      case CredentialStatus.active:
        return Icons.check_circle;
      case CredentialStatus.invalidStatus:
      case CredentialStatus.expired:
      case CredentialStatus.pending:
      case CredentialStatus.unknown:
      case CredentialStatus.invalidSignature:
      case CredentialStatus.noStatus:
        return Icons.circle_outlined;
    }
  }

  Color color(BuildContext context) {
    switch (this) {
      case CredentialStatus.active:
        return Theme.of(context).colorScheme.activeColor;
      case CredentialStatus.invalidStatus:
      case CredentialStatus.expired:
      case CredentialStatus.pending:
      case CredentialStatus.unknown:
      case CredentialStatus.invalidSignature:
      case CredentialStatus.noStatus:
        return Theme.of(context).colorScheme.inactiveColor;
    }
  }
}
