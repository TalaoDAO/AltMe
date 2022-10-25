import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class BloometaPassDisplayInList extends StatelessWidget {
  const BloometaPassDisplayInList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return BloometaPassRecto(credentialModel: credentialModel);
  }
}

class BloometaPassDisplayInSelectionList extends StatelessWidget {
  const BloometaPassDisplayInSelectionList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return BloometaPassRecto(credentialModel: credentialModel);
  }
}

class BloometaPassDisplayDetail extends StatelessWidget {
  const BloometaPassDisplayDetail({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BloometaPassRecto(credentialModel: credentialModel),
      ],
    );
  }
}

class BloometaPassRecto extends Recto {
  const BloometaPassRecto({Key? key, required this.credentialModel})
      : super(key: key);
  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    final bloometaPassModel = credentialModel
        .credentialPreview.credentialSubjectModel as BloometaPassModel;
    final l10n = context.l10n;

    return CredentialImage(
      image: ImageStrings.bloometaPass,
      child: AspectRatio(
        aspectRatio: Sizes.credentialAspectRatio,
        child: CustomMultiChildLayout(
          delegate: BloometaPassDelegate(position: Offset.zero),
          children: [
            LayoutId(
              id: 'bloometaValue',
              child: FractionallySizedBox(
                widthFactor: 0.8,
                heightFactor: 0.20,
                child: MyText(
                  bloometaPassModel.offers?.benefit?.discount ?? '',
                  style: Theme.of(context).textTheme.title,
                ),
              ),
            ),
            LayoutId(
              id: 'bloometa',
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
