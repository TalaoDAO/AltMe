import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class WalletCredentialWidget extends StatelessWidget {
  const WalletCredentialWidget({
    super.key,
    required this.credentialModel,
  });

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    final WalletCredential = credentialModel
        .credentialPreview.credentialSubjectModel as WalletCredentialModel;
    return CredentialImage(
      image: WalletCredential.systemName == 'iOS'
          ? ImageStrings.walletCertificateiOS
          : ImageStrings.walletCertificateAndroid,
      child: const AspectRatio(
        aspectRatio: Sizes.credentialAspectRatio,
      ),
    );
  }
}
