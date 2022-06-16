import 'package:altme/app/app.dart';
import 'package:altme/home/home.dart';
import 'package:flutter/material.dart';

class VoucherDisplayInList extends StatelessWidget {
  const VoucherDisplayInList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return const VoucherRecto();
  }
}

class VoucherDisplayInSelectionList extends StatelessWidget {
  const VoucherDisplayInSelectionList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return const VoucherRecto();
  }
}

class VoucherDisplayDetail extends StatelessWidget {
  const VoucherDisplayDetail({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        CardAnimation(
          recto: VoucherRecto(),
          verso: VoucherVerso(),
        ),
      ],
    );
  }
}

class VoucherRecto extends Recto {
  const VoucherRecto({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CredentialImage(
      image: ImageStrings.voucherFront,
      child: AspectRatio(
        /// size from over18 recto picture
        aspectRatio: 584 / 317,
        child: CustomMultiChildLayout(
          delegate: VoucherVersoDelegate(position: Offset.zero),
        ),
      ),
    );
  }
}

class VoucherVerso extends Verso {
  const VoucherVerso({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CredentialImage(
      image: ImageStrings.voucherBack,
      child: AspectRatio(
        /// size from over18 recto picture
        aspectRatio: 584 / 317,
        child: CustomMultiChildLayout(
          delegate: VoucherVersoDelegate(position: Offset.zero),
        ),
      ),
    );
  }
}

class VoucherDelegate extends MultiChildLayoutDelegate {
  VoucherDelegate({this.position = Offset.zero});

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
  bool shouldRelayout(covariant VoucherDelegate oldDelegate) {
    return oldDelegate.position != position;
  }
}

class VoucherVersoDelegate extends MultiChildLayoutDelegate {
  VoucherVersoDelegate({this.position = Offset.zero});

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
  bool shouldRelayout(VoucherVersoDelegate oldDelegate) {
    return oldDelegate.position != position;
  }
}
