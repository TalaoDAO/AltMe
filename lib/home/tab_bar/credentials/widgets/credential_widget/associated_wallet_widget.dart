import 'package:altme/app/app.dart';
import 'package:altme/home/home.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class AssociatedWalletDisplayInList extends StatelessWidget {
  const AssociatedWalletDisplayInList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return const AssociatedWalletRecto();
  }
}

class AssociatedWalletDisplayInSelectionList extends StatelessWidget {
  const AssociatedWalletDisplayInSelectionList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return const AssociatedWalletRecto();
  }
}

class AssociatedWalletDisplayDetail extends StatelessWidget {
  const AssociatedWalletDisplayDetail({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CardAnimation(
          recto: const AssociatedWalletRecto(),
          verso: AssociatedWalletVerso(credentialModel: credentialModel),
        ),
      ],
    );
  }
}

class AssociatedWalletRecto extends Recto {
  const AssociatedWalletRecto({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AspectRatio(
      /// size from recto picture
      aspectRatio: 584 / 317,
      child: CredentialImage(
        image: ImageStrings.associatedWalletFront,
        child: SizedBox.shrink(),
      ),
    );
  }
}

class AssociatedWalletVerso extends Verso {
  const AssociatedWalletVerso({Key? key, required this.credentialModel})
      : super(key: key);
  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final associatedWallet = credentialModel
        .credentialPreview.credentialSubjectModel as AssociatedWalletModel;
    final expirationDate = credentialModel.expirationDate;
    final issuerName = associatedWallet.issuedBy!.name;

    return CredentialImage(
      image: ImageStrings.associatedWalletBack,
      child: AspectRatio(
        /// size from recto picture
        aspectRatio: 584 / 317,
        child: Padding(
          padding: const EdgeInsets.all(Sizes.spaceNormal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (associatedWallet.issuedBy?.logo.isNotEmpty ?? false)
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    height: 50,
                    child: ImageFromNetwork(
                      associatedWallet.issuedBy!.logo,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              DisplayNameCard(
                credentialModel: credentialModel,
                style: Theme.of(context).textTheme.associatedWalletTitleCard,
              ),
              const SizedBox(height: Sizes.spaceSmall),
              DisplayDescriptionCard(
                credentialModel: credentialModel,
                style: Theme.of(context).textTheme.credentialDescription,
              ),
              const SizedBox(height: Sizes.spaceSmall),
              if (expirationDate != null)
                Text(
                  '${l10n.expires}: ${UiDate.displayDate(
                    l10n,
                    expirationDate,
                  )}',
                  style: Theme.of(context).textTheme.associatedWalletData,
                ),
              Text(
                '${l10n.issuer}: $issuerName',
                style: Theme.of(context).textTheme.associatedWalletData,
              )
            ],
          ),
        ),
      ),
    );
  }
}
