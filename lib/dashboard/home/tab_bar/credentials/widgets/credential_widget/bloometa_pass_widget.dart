import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class BloometaPassWidget extends StatelessWidget {
  const BloometaPassWidget({super.key, required this.credentialModel});

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    // final bloometaPassModel = credentialModel
    //     .credentialPreview.credentialSubjectModel as BloometaPassModel;
    // final l10n = context.l10n;

    return CredentialImage(
      image: ImageStrings.bloometaPass,
      child: AspectRatio(
        aspectRatio: Sizes.credentialAspectRatio,
        child: CustomMultiChildLayout(
          delegate: BloometaPassDelegate(position: Offset.zero),
        ),
      ),
    );
  }
}

class BloometaPassDelegate extends MultiChildLayoutDelegate {
  BloometaPassDelegate({this.position = Offset.zero});

  final Offset position;

  @override
  void performLayout(Size size) {
    if (hasChild('bloometaValue')) {
      layoutChild('bloometaValue', BoxConstraints.loose(size));
      positionChild(
        'bloometaValue',
        Offset(size.width * 0.1, size.height * 0.55),
      );
    }
    if (hasChild('bloometa')) {
      layoutChild('bloometa', BoxConstraints.loose(size));
      positionChild(
        'bloometa',
        Offset(size.width * 0.1, size.height * 0.73),
      );
    }
  }

  @override
  bool shouldRelayout(covariant BloometaPassDelegate oldDelegate) {
    return oldDelegate.position != position;
  }
}
