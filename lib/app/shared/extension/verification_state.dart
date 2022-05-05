import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

extension VerifyExtension on VerificationState {
  String message(BuildContext context) {
    final l10n = context.l10n;
    switch (this) {
      case VerificationState.Unverified:
        return l10n.pending;
      case VerificationState.Verified:
        return l10n.verified;
      case VerificationState.VerifiedWithWarning:
        return l10n.verifiedWithWarning;
      case VerificationState.VerifiedWithError:
        return l10n.failedVerification;
    }
  }

  IconData get icon {
    switch (this) {
      case VerificationState.Unverified:
        return Icons.update;
      case VerificationState.Verified:
        return Icons.check_circle_outline;
      case VerificationState.VerifiedWithWarning:
        return Icons.warning_amber_outlined;
      case VerificationState.VerifiedWithError:
        return Icons.error_outline;
    }
  }

  Color get color {
    switch (this) {
      case VerificationState.Unverified:
        return Colors.orange;
      case VerificationState.Verified:
        return Colors.green;
      case VerificationState.VerifiedWithWarning:
        return Colors.orange;
      case VerificationState.VerifiedWithError:
        return Colors.red;
    }
  }
}
