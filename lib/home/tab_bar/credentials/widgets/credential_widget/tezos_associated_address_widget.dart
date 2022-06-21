import 'package:altme/app/app.dart';
import 'package:altme/home/home.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class TezosAssociatedAddressDisplayInList extends StatelessWidget {
  const TezosAssociatedAddressDisplayInList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return const TezosAssociatedAddressRecto();
  }
}

class TezosAssociatedAddressDisplayInSelectionList extends StatelessWidget {
  const TezosAssociatedAddressDisplayInSelectionList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return const TezosAssociatedAddressRecto();
  }
}

class TezosAssociatedAddressDisplayDetail extends StatelessWidget {
  const TezosAssociatedAddressDisplayDetail({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CardAnimation(
          recto: const TezosAssociatedAddressRecto(),
          verso: TezosAssociatedAddressVerso(credentialModel: credentialModel),
        ),
      ],
    );
  }
}

class TezosAssociatedAddressRecto extends Recto {
  const TezosAssociatedAddressRecto({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AspectRatio(
      aspectRatio: Sizes.credentialAspectRatio,
      child: CredentialImage(
        image: ImageStrings.associatedWalletFront,
        child: SizedBox.shrink(),
      ),
    );
  }
}

class TezosAssociatedAddressVerso extends Verso {
  const TezosAssociatedAddressVerso({Key? key, required this.credentialModel})
      : super(key: key);
  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final TezosAssociatedAddress = credentialModel.credentialPreview
        .credentialSubjectModel as TezosAssociatedAddressModel;
    final expirationDate = credentialModel.expirationDate;
    final issuerName = TezosAssociatedAddress.issuedBy!.name;

    return CredentialImage(
      image: ImageStrings.associatedWalletBack,
      child: AspectRatio(
        aspectRatio: Sizes.credentialAspectRatio,
        child: Padding(
          padding: const EdgeInsets.all(Sizes.spaceNormal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (TezosAssociatedAddress.issuedBy?.logo.isNotEmpty ?? false)
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    height: 50,
                    child: ImageFromNetwork(
                      TezosAssociatedAddress.issuedBy!.logo,
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
