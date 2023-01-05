import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class TezotopiaMemberShipWidget extends StatelessWidget {
  const TezotopiaMemberShipWidget({Key? key, required this.credentialModel})
      : super(key: key);
  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    // final tezotopiaMembershipModel = credentialModel
    //    .credentialPreview.credentialSubjectModel as TezotopiaMembershipModel;
    final l10n = context.l10n;

    return CredentialImage(
      image: ImageStrings.tezotopiaMemberShip,
      child: AspectRatio(
        aspectRatio: Sizes.credentialAspectRatio,
        child: CustomMultiChildLayout(
          delegate: TezotopiaMembershipDelegate(position: Offset.zero),
          children: [
            LayoutId(
              id: 'membershipValue',
              child: FractionallySizedBox(
                widthFactor: 0.8,
                heightFactor: 0.20,
                child: MyText(
                  '${l10n.membership} '
                  //'${tezotopiaMembershipModel.offers?.benefit?.discount??''}',
                  ,
                  style: Theme.of(context).textTheme.title,
                ),
              ),
            ),
            LayoutId(
              id: 'tozotopia',
              child: FractionallySizedBox(
                widthFactor: 0.4,
                heightFactor: 0.14,
                child: MyText(
                  l10n.tezotopia,
                  style: Theme.of(context).textTheme.subMessage.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TezotopiaMembershipDelegate extends MultiChildLayoutDelegate {
  TezotopiaMembershipDelegate({this.position = Offset.zero});

  final Offset position;

  @override
  void performLayout(Size size) {
    if (hasChild('membershipValue')) {
      layoutChild('membershipValue', BoxConstraints.loose(size));
      positionChild(
        'membershipValue',
        Offset(size.width * 0.1, size.height * 0.55),
      );
    }
    if (hasChild('tozotopia')) {
      layoutChild('tozotopia', BoxConstraints.loose(size));
      positionChild(
        'tozotopia',
        Offset(size.width * 0.1, size.height * 0.73),
      );
    }
  }

  @override
  bool shouldRelayout(covariant TezotopiaMembershipDelegate oldDelegate) {
    return oldDelegate.position != position;
  }
}
