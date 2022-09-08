import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class TezosAssociatedAddressDisplayInList extends StatelessWidget {
  const TezosAssociatedAddressDisplayInList({
    Key? key,
    required this.credentialModel,
    required this.displayInGrid,
  }) : super(key: key);

  final CredentialModel credentialModel;
  final bool displayInGrid;

  @override
  Widget build(BuildContext context) {
    return TezosAssociatedAddressRecto(
      credentialModel: credentialModel,
      largeSize: !displayInGrid,
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
      largeSize: true,
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
      largeSize: true,
    );
  }
}

class TezosAssociatedAddressRecto extends Recto {
  const TezosAssociatedAddressRecto({
    Key? key,
    required this.credentialModel,
    this.largeSize = false,
  }) : super(key: key);

  final bool largeSize;
  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tezosAssociatedAddress = credentialModel.credentialPreview
        .credentialSubjectModel as TezosAssociatedAddressModel;
    return CredentialContainer(
      child: AspectRatio(
        aspectRatio: Sizes.credentialAspectRatio,
        child: Container(
          padding: EdgeInsets.only(
            top: largeSize ? Sizes.space3XLarge : Sizes.spaceLarge,
            left: Sizes.space2XSmall,
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
                    style: largeSize
                        ? Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).colorScheme.titleColor,
                            )
                        : Theme.of(context).textTheme.caption2,
                  ),
                ),
                const Spacer(),
                FractionallySizedBox(
                  widthFactor: 0.8,
                  child: MyText(
                    tezosAssociatedAddress.accountName!,
                    style: largeSize
                        ? Theme.of(context).textTheme.headline6
                        : Theme.of(context).textTheme.subtitle2,
                  ),
                ),
                const Spacer(),
                MyText(
                  tezosAssociatedAddress.associatedAddress?.isEmpty == true
                      ? ''
                      : tezosAssociatedAddress.associatedAddress.toString(),
                  style: largeSize
                      ? Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.titleColor,
                          )
                      : Theme.of(context).textTheme.caption2,
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
