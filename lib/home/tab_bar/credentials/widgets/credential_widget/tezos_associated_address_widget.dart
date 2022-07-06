import 'package:altme/app/app.dart';
import 'package:altme/home/home.dart';
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
    return Column(
      children: [
        TezosAssociatedAddressRecto(
          credentialModel: credentialModel,
        ),
      ],
    );
  }
}

class TezosAssociatedAddressRecto extends Recto {
  const TezosAssociatedAddressRecto({Key? key, required this.credentialModel})
      : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    final tezosAssociatedAddress = credentialModel.credentialPreview
        .credentialSubjectModel as TezosAssociatedAddressModel;
    return CredentialImage(
      image: ImageStrings.associatedWalletFront,
      child: AspectRatio(
        aspectRatio: Sizes.credentialAspectRatio,
        child: CustomMultiChildLayout(
          delegate: TezosAssociatedAddressDelegate(position: Offset.zero),
          children: [
            LayoutId(
              id: 'address',
              child: FractionallySizedBox(
                widthFactor: 0.75,
                child: MyText(
                  // ignore: lines_longer_than_80_chars
                  '${tezosAssociatedAddress.associatedAddress?.isEmpty == true ? '' : tezosAssociatedAddress.associatedAddress}',
                  style: Theme.of(context).textTheme.tezosAssociatedAddressData,
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

class TezosAssociatedAddressDelegate extends MultiChildLayoutDelegate {
  TezosAssociatedAddressDelegate({this.position = Offset.zero});

  final Offset position;

  @override
  void performLayout(Size size) {
    if (hasChild('address')) {
      layoutChild('address', BoxConstraints.loose(size));
      positionChild('address', Offset(size.width * 0.15, size.height * 0.73));
    }
  }

  @override
  bool shouldRelayout(TezosAssociatedAddressDelegate oldDelegate) {
    return oldDelegate.position != position;
  }
}
