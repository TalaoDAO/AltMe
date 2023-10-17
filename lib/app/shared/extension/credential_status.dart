import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

extension CredentialStatusExtension on CredentialStatus {
  String message(BuildContext context) {
    final l10n = context.l10n;
    switch (this) {
      case CredentialStatus.active:
        return l10n.cardsActive;
      case CredentialStatus.suspended:
      case CredentialStatus.revoked:
      case CredentialStatus.expired:
      case CredentialStatus.notVerified:
        return l10n.cardsProblem;
      case CredentialStatus.pending:
        return l10n.cardsPending;
      case CredentialStatus.unknown:
        return l10n.unknown;
    }
  }

  IconData get icon {
    switch (this) {
      case CredentialStatus.active:
        return Icons.check_circle;
      case CredentialStatus.suspended:
      case CredentialStatus.revoked:
      case CredentialStatus.expired:
      case CredentialStatus.notVerified:
        return Icons.error_rounded;
      case CredentialStatus.pending:
      case CredentialStatus.unknown:
        return Icons.circle_outlined;
    }
  }

  Color color(BuildContext context) {
    switch (this) {
      case CredentialStatus.active:
        return Theme.of(context).colorScheme.activeColor;
      case CredentialStatus.suspended:
      case CredentialStatus.revoked:
      case CredentialStatus.expired:
      case CredentialStatus.notVerified:
        return Theme.of(context).colorScheme.inactiveColor;
      case CredentialStatus.pending:
        return Colors.orange;
      case CredentialStatus.unknown:
        return Colors.blue;
    }
  }

  String info(BuildContext context) {
    final l10n = context.l10n;
    switch (this) {
      case CredentialStatus.notVerified:
        return l10n.incorrectSignature;
      case CredentialStatus.suspended:
      case CredentialStatus.revoked:
        return l10n.revokedOrSuspendedCredential;
      case CredentialStatus.expired:
        return l10n.credentialExpired;
      case CredentialStatus.unknown:
      case CredentialStatus.pending:
      case CredentialStatus.active:
        return '';
    }
  }
}
