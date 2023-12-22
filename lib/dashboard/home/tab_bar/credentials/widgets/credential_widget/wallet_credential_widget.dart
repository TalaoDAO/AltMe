import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WalletCredentialWidget extends StatelessWidget {
  const WalletCredentialWidget({
    super.key,
    required this.credentialModel,
  });

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return CredentialBaseWidget(
      cardBackgroundImagePath: ImageStrings.walletCertificate,
      issuerName: credentialModel
          .credentialPreview.credentialSubjectModel.issuedBy?.name,
      issuanceDate: UiDate.formatDateForCredentialCard(
        credentialModel.credentialPreview.issuanceDate,
      ),
      value: '',
      expirationDate: credentialModel.expirationDate == null
          ? '--'
          : UiDate.formatDateForCredentialCard(
              credentialModel.expirationDate!,
            ),
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
        if (context.read<ProfileCubit>().state.model.isDeveloperMode) ...[
          const SizedBox(height: 10),
          CredentialField(
            padding: EdgeInsets.zero,
            title: l10n.publicKeyOfWalletInstance,
            value: walletCredential.publicKey ?? '',
            titleColor: titleColor,
            valueColor: valueColor,
          ),
          const SizedBox(height: 10),
        ] else ...[
          const SizedBox(height: 10),
        ],
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
          value: UiDate.formatDateForCredentialCard(
            credentialModel.credentialPreview.issuanceDate,
          ),
          titleColor: titleColor,
          valueColor: valueColor,
        ),
        const SizedBox(height: 10),
        CredentialField(
          padding: EdgeInsets.zero,
          title: l10n.expirationDate,
          value: UiDate.formatDateForCredentialCard(
            credentialModel.credentialPreview.expirationDate,
          ),
          titleColor: titleColor,
          valueColor: valueColor,
        ),
      ],
    );
  }
}
