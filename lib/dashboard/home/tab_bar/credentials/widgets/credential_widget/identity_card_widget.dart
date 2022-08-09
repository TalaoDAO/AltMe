import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/app_theme/app_theme.dart';
import 'package:flutter/material.dart';

class IdentityCardDisplayInList extends StatelessWidget {
  const IdentityCardDisplayInList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return IdentityCardRecto(credentialModel: credentialModel);
  }
}

class IdentityCardDisplayInSelectionList extends StatelessWidget {
  const IdentityCardDisplayInSelectionList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return IdentityCardRecto(credentialModel: credentialModel);
  }
}

class IdentityCardDisplayDetail extends StatelessWidget {
  const IdentityCardDisplayDetail({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return IdentityCardRecto(credentialModel: credentialModel);
  }
}

class IdentityCardRecto extends StatelessWidget {
  const IdentityCardRecto({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return CredentialImage(
      image: ImageStrings.identityCard,
      child: AspectRatio(
        aspectRatio: Sizes.credentialAspectRatio,
        child: CustomMultiChildLayout(
          delegate: IdentityPassRectoDelegate(position: Offset.zero),
          children: [
            LayoutId(
              id: 'issuanceDate',
              child: ImageCardText(
                text: UiDate.displayDate(
                  l10n,
                  credentialModel.credentialPreview.issuanceDate,
                ),
                textStyle: Theme.of(context).textTheme.identityCardData,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IdentityPassRectoDelegate extends MultiChildLayoutDelegate {
  IdentityPassRectoDelegate({this.position = Offset.zero});

  final Offset position;

  @override
  void performLayout(Size size) {
    if (hasChild('issuanceDate')) {
      layoutChild('issuanceDate', BoxConstraints.loose(size));
      positionChild(
        'issuanceDate',
        Offset(size.width * 0.35, size.height * 0.77),
      );
    }
  }

  @override
  bool shouldRelayout(IdentityPassRectoDelegate oldDelegate) {
    return oldDelegate.position != position;
  }
}
