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
        return l10n.cardsProblem;
      case CredentialStatus.pending:
        return l10n.cardsPending;
    }
  }

  IconData get icon {
    switch (this) {
      case CredentialStatus.active:
        return Icons.check_circle;
      case CredentialStatus.suspended:
        return Icons.error_rounded;
      case CredentialStatus.pending:
        return Icons.circle_outlined;
    }
  }

  Color color(BuildContext context) {
    switch (this) {
      case CredentialStatus.active:
        return Theme.of(context).colorScheme.activeColor;
      case CredentialStatus.suspended:
        return Theme.of(context).colorScheme.inactiveColor;
      case CredentialStatus.pending:
        return Colors.orange;
    }
  }
}
