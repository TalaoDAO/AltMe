import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class BinanceAssociatedAddressWidget extends StatelessWidget {
  const BinanceAssociatedAddressWidget({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final associatedAddress = credentialModel.credentialPreview
        .credentialSubjectModel as BinanceAssociatedAddressModel;

    return MyBlockchainAccountBaseWidget(
      image: IconStrings.binance,
      name: l10n.binanceNetwork,
      walletAddress: associatedAddress.associatedAddress ?? '',
    );
  }
}
