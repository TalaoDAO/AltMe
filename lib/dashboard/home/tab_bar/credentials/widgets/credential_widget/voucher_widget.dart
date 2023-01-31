import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class VoucherWidget extends StatelessWidget {
  const VoucherWidget({
    super.key,
    required this.credentialModel,
  });

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
  const VoucherRecto({super.key});

  @override
  Widget build(BuildContext context) {
    return CredentialImage(
      image: ImageStrings.voucherFront,
      child: AspectRatio(
        aspectRatio: Sizes.credentialAspectRatio,
        child: CustomMultiChildLayout(
          delegate: VoucherVersoDelegate(position: Offset.zero),
        ),
      ),
    );
  }
}

class VoucherVerso extends Verso {
  const VoucherVerso({super.key});

  @override
  Widget build(BuildContext context) {
    return CredentialImage(
      image: ImageStrings.voucherBack,
      child: AspectRatio(
        aspectRatio: Sizes.credentialAspectRatio,
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
