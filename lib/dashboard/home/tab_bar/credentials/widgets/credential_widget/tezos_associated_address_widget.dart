import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
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
    return TezosAssociatedAddressRecto(credentialModel: credentialModel);
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
    return TezosAssociatedAddressRecto(credentialModel: credentialModel);
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
    return TezosAssociatedAddressRecto(credentialModel: credentialModel);
  }
}

class TezosAssociatedAddressRecto extends Recto {
  const TezosAssociatedAddressRecto({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    final tezosAssociatedAddress = credentialModel.credentialPreview
        .credentialSubjectModel as TezosAssociatedAddressModel;
    return CredentialContainer(
      child: AspectRatio(
        aspectRatio: Sizes.credentialAspectRatio,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.credentialBackground,
            border: Border.all(
              color: Theme.of(context).colorScheme.associatedWalletBorder,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(Sizes.credentialBorderRadius),
          ),
          child: FractionallySizedBox(
            widthFactor: 0.9,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                FractionallySizedBox(
                  widthFactor: 0.75,
                  child: MyText(
                    context.l10n.proofOfOwnership,
                    style: Theme.of(context).textTheme.proofOfOwnership,
                  ),
                ),
                const Spacer(),
                FractionallySizedBox(
                  widthFactor: 0.8,
                  child: MyText(
                    tezosAssociatedAddress.accountName!,
                    style: Theme.of(context)
                        .textTheme
                        .tezosAssociatedAddressTitleCard,
                  ),
                ),
                const Spacer(),
                MyText(
                  tezosAssociatedAddress.associatedAddress?.isEmpty == true
                      ? ''
                      : tezosAssociatedAddress.associatedAddress.toString(),
                  style: Theme.of(context).textTheme.tezosAssociatedAddressData,
                  maxLines: 2,
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
