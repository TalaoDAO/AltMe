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
    return TezosAssociatedAddressRecto(
      credentialModel: credentialModel,
    );
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
    return TezosAssociatedAddressRecto(
      credentialModel: credentialModel,
    );
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
    return TezosAssociatedAddressRecto(
      credentialModel: credentialModel,
    );
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
    final l10n = context.l10n;
    final tezosAssociatedAddress = credentialModel.credentialPreview
        .credentialSubjectModel as TezosAssociatedAddressModel;
    return CredentialContainer(
      child: AspectRatio(
        aspectRatio: Sizes.credentialAspectRatio,
        child: LayoutBuilder(
          builder: (_, constraint) => Container(
            padding: EdgeInsets.only(
              top: constraint.biggest.height * 0.245,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.credentialBackground,
              image: const DecorationImage(
                image: AssetImage(
                  ImageStrings.paymentAssetCard,
                ),
                fit: BoxFit.fill,
              ),
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
                  FractionallySizedBox(
                    widthFactor: 0.8,
                    child: MyText(
                      l10n.tezosNetwork,
                      style: Theme.of(context).textTheme.caption2,
                    ),
                  ),
                  const Spacer(),
                  FractionallySizedBox(
                    widthFactor: 0.8,
                    child: MyText(
                      tezosAssociatedAddress.accountName!,
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ),
                  const Spacer(),
                  MyText(
                    tezosAssociatedAddress.associatedAddress?.isEmpty == true
                        ? ''
                        : tezosAssociatedAddress.associatedAddress.toString(),
                    style: Theme.of(context).textTheme.caption2,
                    minFontSize: 8,
                    maxLines: 2,
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
