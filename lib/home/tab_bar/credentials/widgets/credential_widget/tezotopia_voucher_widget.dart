import 'package:altme/app/app.dart';
import 'package:altme/home/home.dart';
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
    return Column(
      children: const [
        CardAnimation(
          recto: TezotopiaVoucherRecto(),
          verso: TezotopiaVoucherVerso(),
        ),
      ],
    );
  }
}

class TezotopiaVoucherRecto extends Recto {
  const TezotopiaVoucherRecto({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CredentialImage(
      image: ImageStrings.tezotopiaVoucher,
      child: AspectRatio(
        /// size from over18 recto picture
        aspectRatio: 584 / 317,
        child: CustomMultiChildLayout(
          delegate: TezotopiaVoucherVersoDelegate(position: Offset.zero),
        ),
      ),
    );
  }
}

class TezotopiaVoucherVerso extends Verso {
  const TezotopiaVoucherVerso({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CredentialImage(
      image: ImageStrings.tezotopiaVoucher,
      child: AspectRatio(
        /// size from over18 recto picture
        aspectRatio: 584 / 317,
        child: CustomMultiChildLayout(
          delegate: TezotopiaVoucherVersoDelegate(position: Offset.zero),
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
        Offset(size.width * 0.27, size.height * 0.95),
      );
    }
  }

  @override
  bool shouldRelayout(covariant TezotopiaVoucherDelegate oldDelegate) {
    return oldDelegate.position != position;
  }
}

class TezotopiaVoucherVersoDelegate extends MultiChildLayoutDelegate {
  TezotopiaVoucherVersoDelegate({this.position = Offset.zero});

  final Offset position;

  @override
  void performLayout(Size size) {
    if (hasChild('name')) {
      layoutChild('name', BoxConstraints.loose(size));
      positionChild('name', Offset(size.width * 0.06, size.height * 0.14));
    }
    if (hasChild('description')) {
      layoutChild('description', BoxConstraints.loose(size));
      positionChild(
        'description',
        Offset(size.width * 0.06, size.height * 0.33),
      );
    }

    if (hasChild('issuer')) {
      layoutChild('issuer', BoxConstraints.loose(size));
      positionChild('issuer', Offset(size.width * 0.06, size.height * 0.783));
    }
  }

  @override
  bool shouldRelayout(TezotopiaVoucherVersoDelegate oldDelegate) {
    return oldDelegate.position != position;
  }
}
