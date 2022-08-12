import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
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
    return TezotopiaVoucherRecto(credentialModel);
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
    return TezotopiaVoucherRecto(credentialModel);
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
    return TezotopiaVoucherRecto(credentialModel);
  }
}

class TezotopiaVoucherRecto extends Recto {
  const TezotopiaVoucherRecto(
    this.credentialModel, {
    Key? key,
  }) : super(
          key: key,
        );
  final CredentialModel credentialModel;
  @override
  Widget build(BuildContext context) {
    final tezotopiaVoucherModel = credentialModel
        .credentialPreview.credentialSubjectModel as TezotopiaVoucherModel;

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
                widthFactor: 0.3,
                child: MyText(
                  tezotopiaVoucherModel.offers?.benefit!.discount ?? '',
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
