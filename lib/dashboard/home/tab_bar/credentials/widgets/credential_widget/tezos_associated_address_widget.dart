import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class TezosAssociatedAddressWidget extends StatelessWidget {
  const TezosAssociatedAddressWidget({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tezosAssociatedAddress = credentialModel.credentialPreview
        .credentialSubjectModel as TezosAssociatedAddressModel;
    return CredentialImage(
      image: ImageStrings.paymentTezosCard,
      child: AspectRatio(
        aspectRatio: Sizes.credentialAspectRatio,
        child: CustomMultiChildLayout(
          delegate: TezosAssociatedAddressRectoDelegate(position: Offset.zero),
          children: [
            LayoutId(
              id: 'name',
              child: FractionallySizedBox(
                widthFactor: 0.8,
                heightFactor: 0.14,
                child: MyText(
                  l10n.tezosNetwork,
                  style: Theme.of(context).textTheme.subMessage.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
              ),
            ),
            LayoutId(
              id: 'accountName',
              child: FractionallySizedBox(
                widthFactor: 0.8,
                heightFactor: 0.16,
                child: MyText(
                  tezosAssociatedAddress.accountName!,
                  style: Theme.of(context).textTheme.title,
                ),
              ),
            ),
            LayoutId(
              id: 'walletAddress',
              child: FractionallySizedBox(
                widthFactor: 0.88,
                heightFactor: 0.26,
                child: MyText(
                  tezosAssociatedAddress.associatedAddress?.isEmpty == true
                      ? ''
                      : tezosAssociatedAddress.associatedAddress.toString(),
                  style: Theme.of(context).textTheme.subMessage.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                  minFontSize: 8,
                  maxLines: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TezosAssociatedAddressRectoDelegate extends MultiChildLayoutDelegate {
  TezosAssociatedAddressRectoDelegate({this.position = Offset.zero});

  final Offset position;

  @override
  void performLayout(Size size) {
    if (hasChild('name')) {
      layoutChild('name', BoxConstraints.loose(size));
      positionChild(
        'name',
        Offset(size.width * 0.06, size.height * 0.27),
      );
    }

    if (hasChild('accountName')) {
      layoutChild('accountName', BoxConstraints.loose(size));
      positionChild(
        'accountName',
        Offset(size.width * 0.06, size.height * 0.5),
      );
    }

    if (hasChild('walletAddress')) {
      layoutChild('walletAddress', BoxConstraints.loose(size));
      positionChild(
        'walletAddress',
        Offset(size.width * 0.06, size.height * 0.70),
      );
    }
  }

  @override
  bool shouldRelayout(TezosAssociatedAddressRectoDelegate oldDelegate) {
    return oldDelegate.position != position;
  }
}
