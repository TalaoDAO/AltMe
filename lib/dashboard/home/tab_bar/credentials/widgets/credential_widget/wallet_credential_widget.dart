import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class WalletCredentialWidget extends StatelessWidget {
  const WalletCredentialWidget({
    super.key,
    required this.credentialModel,
  });

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CredentialImage(
          image: isAndroid
              ? ImageStrings.walletCertificateAndroid
              : ImageStrings.walletCertificateiOS,
          child: const AspectRatio(
            aspectRatio: Sizes.credentialAspectRatio,
          ),
        ),
      ],
    );
  }
}

class WalletCredentialetailsWidget extends StatelessWidget {
  const WalletCredentialetailsWidget({
    super.key,
    required this.credentialModel,
  });

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final titleColor = Theme.of(context).colorScheme.titleColor;
    final valueColor = Theme.of(context).colorScheme.valueColor;

    final walletCredential = credentialModel
        .credentialPreview.credentialSubjectModel as WalletCredentialModel;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CredentialField(
          padding: EdgeInsets.zero,
          title: l10n.publicKeyOfWalletInstance,
          value: walletCredential.publicKey ?? '',
          titleColor: titleColor,
          valueColor: valueColor,
        ),
        const SizedBox(height: 10),
        CredentialField(
          padding: EdgeInsets.zero,
          title: l10n.walletInstanceKey,
          value: walletCredential.walletInstanceKey ?? '',
          titleColor: titleColor,
          valueColor: valueColor,
        ),
        const SizedBox(height: 10),
        CredentialField(
          padding: EdgeInsets.zero,
          title: l10n.issuanceDate,
          value: UiDate.fromMillisecondsSinceEpoch(
            credentialModel.credentialPreview.issuanceDate,
          ),
          titleColor: titleColor,
          valueColor: valueColor,
        ),
        const SizedBox(height: 10),
        CredentialField(
          padding: EdgeInsets.zero,
          title: l10n.expirationDate,
          value: UiDate.fromMillisecondsSinceEpoch(
            credentialModel.credentialPreview.expirationDate,
          ),
          titleColor: titleColor,
          valueColor: valueColor,
        ),
      ],
    );
  }
}
