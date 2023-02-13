import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class EUDiplomaCardWidget extends StatelessWidget {
  const EUDiplomaCardWidget({
    super.key,
    required this.credentialModel,
  });

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return CredentialImage(
      image: ImageStrings.euDiplomaCard,
      child: AspectRatio(
        aspectRatio: Sizes.credentialAspectRatio,
        child: CustomMultiChildLayout(
          delegate: EUDiplomaCardWidgetDelegate(position: Offset.zero),
          children: [
            LayoutId(
              id: 'issued-on',
              child: FractionallySizedBox(
                heightFactor: 0.10,
                widthFactor: 0.4,
                child: MyText(
                  l10n.issuedOn,
                  style: Theme.of(context).textTheme.identitiyBaseLightText,
                ),
              ),
            ),
            LayoutId(
              id: 'issued-on-value',
              child: FractionallySizedBox(
                heightFactor: 0.10,
                widthFactor: 0.4,
                child: MyText(
                  UiDate.formatDateForCredentialCard(
                    credentialModel.credentialPreview.issuanceDate,
                  ),
                  style: Theme.of(context).textTheme.identitiyBaseBoldText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EUDiplomaCardWidgetDelegate extends MultiChildLayoutDelegate {
  EUDiplomaCardWidgetDelegate({this.position = Offset.zero});

  final Offset position;

  @override
  void performLayout(Size size) {
    if (hasChild('issued-on')) {
      layoutChild('issued-on', BoxConstraints.loose(size));
      positionChild(
        'issued-on',
        Offset(size.width * 0.5, size.height * 0.70),
      );
    }
    if (hasChild('issued-on-value')) {
      layoutChild('issued-on-value', BoxConstraints.loose(size));
      positionChild(
        'issued-on-value',
        Offset(size.width * 0.5, size.height * 0.82),
      );
    }
  }

  @override
  bool shouldRelayout(EUDiplomaCardWidgetDelegate oldDelegate) {
    return oldDelegate.position != position;
  }
}
