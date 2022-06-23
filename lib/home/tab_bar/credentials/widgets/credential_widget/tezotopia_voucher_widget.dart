import 'package:altme/app/app.dart';
import 'package:altme/home/home.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class TezotopiaVoucherDisplayInList extends StatelessWidget {
  const TezotopiaVoucherDisplayInList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return const TezotopiaVoucherRecto();
  }
}

class TezotopiaVoucherDisplayInSelectionList extends StatelessWidget {
  const TezotopiaVoucherDisplayInSelectionList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return const TezotopiaVoucherRecto();
  }
}

class TezotopiaVoucherDisplayDetail extends StatelessWidget {
  const TezotopiaVoucherDisplayDetail({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return const TezotopiaVoucherRecto();
  }
}

class TezotopiaVoucherRecto extends Recto {
  const TezotopiaVoucherRecto({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CredentialImage(
      image: ImageStrings.tezotopiaVoucher,
      child: AspectRatio(
        aspectRatio: Sizes.credentialAspectRatio,
        child: CustomMultiChildLayout(
          delegate: TezotopiaVoucherDelegate(position: Offset.zero),
          children: [
            LayoutId(
              id: 'voucherValue',
              child: FractionallySizedBox(
                widthFactor: 0.5,
                child: Text(
                  '15%',
                  style: Theme.of(context).textTheme.voucherValueCard,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TezotopiaVoucherDelegate extends MultiChildLayoutDelegate {
  TezotopiaVoucherDelegate({this.position = Offset.zero});

  final Offset position;

  @override
  void performLayout(Size size) {
    if (hasChild('voucherValue')) {
      layoutChild('voucherValue', BoxConstraints.loose(size));
      positionChild(
        'voucherValue',
        Offset(size.width * 0.38, size.height * 0.63),
      );
    }
  }

  @override
  bool shouldRelayout(covariant TezotopiaVoucherDelegate oldDelegate) {
    return oldDelegate.position != position;
  }
}
