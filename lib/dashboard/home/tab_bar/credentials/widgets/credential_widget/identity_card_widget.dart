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
    final identityCardModel = credentialModel
        .credentialPreview.credentialSubjectModel as IdentityCardModel;
    final l10n = context.l10n;
    return CredentialImage(
      image: ImageStrings.identityCard,
      child: AspectRatio(
        aspectRatio: Sizes.credentialAspectRatio,
        child: CustomMultiChildLayout(
          delegate: IdentityPassRectoDelegate(position: Offset.zero),
          children: [
            LayoutId(
              id: 'provided-by',
              child: FractionallySizedBox(
                widthFactor: 0.75,
                heightFactor: 0.15,
                child: MyRichText(
                  text: TextSpan(
                    text: '${l10n.providedBy} ',
                    style: Theme.of(context).textTheme.subMessage,
                    children: [
                      TextSpan(
                        text: credentialModel.credentialPreview
                            .credentialSubjectModel.issuedBy?.name,
                        style: Theme.of(context).textTheme.title,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            LayoutId(
              id: 'fullName',
              child: FractionallySizedBox(
                widthFactor: 0.65,
                heightFactor: 0.15,
                child: MyText(
                  '${identityCardModel.givenName}'
                  ' ${identityCardModel.familyName}',
                  style: Theme.of(context).textTheme.title,
                ),
              ),
            ),
            LayoutId(
              id: 'issued-on',
              child: FractionallySizedBox(
                heightFactor: 0.12,
                widthFactor: 0.4,
                child: MyText(
                  l10n.issuedOn,
                  style: Theme.of(context).textTheme.subMessage,
                ),
              ),
            ),
            LayoutId(
              id: 'issued-on-value',
              child: FractionallySizedBox(
                heightFactor: 0.12,
                widthFactor: 0.4,
                child: MyText(
                  UiDate.formatDateForCredentialCard(
                    credentialModel.credentialPreview.issuanceDate,
                  ),
                  style: Theme.of(context).textTheme.title,
                ),
              ),
            ),
            LayoutId(
              id: 'expiration-date',
              child: FractionallySizedBox(
                heightFactor: 0.12,
                widthFactor: 0.4,
                child: MyText(
                  l10n.expirationDate,
                  style: Theme.of(context).textTheme.subMessage,
                ),
              ),
            ),
            LayoutId(
              id: 'expiration-date-value',
              child: FractionallySizedBox(
                heightFactor: 0.12,
                widthFactor: 0.4,
                child: MyText(
                  credentialModel.expirationDate == null
                      ? '--'
                      : UiDate.formatDateForCredentialCard(
                          credentialModel.expirationDate!,
                        ),
                  style: Theme.of(context).textTheme.title,
                ),
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
    if (hasChild('provided-by')) {
      layoutChild('provided-by', BoxConstraints.loose(size));
      positionChild(
        'provided-by',
        Offset(size.width * 0.06, size.height * 0.27),
      );
    }

    if (hasChild('fullName')) {
      layoutChild('fullName', BoxConstraints.loose(size));
      positionChild(
        'fullName',
        Offset(size.width * 0.06, size.height * 0.50),
      );
    }

    if (hasChild('issued-on')) {
      layoutChild('issued-on', BoxConstraints.loose(size));
      positionChild(
        'issued-on',
        Offset(size.width * 0.06, size.height * 0.70),
      );
    }
    if (hasChild('issued-on-value')) {
      layoutChild('issued-on-value', BoxConstraints.loose(size));
      positionChild(
        'issued-on-value',
        Offset(size.width * 0.06, size.height * 0.82),
      );
    }
    if (hasChild('expiration-date')) {
      layoutChild('expiration-date', BoxConstraints.loose(size));
      positionChild(
        'expiration-date',
        Offset(size.width * 0.5, size.height * 0.70),
      );
    }
    if (hasChild('expiration-date-value')) {
      layoutChild('expiration-date-value', BoxConstraints.loose(size));
      positionChild(
        'expiration-date-value',
        Offset(size.width * 0.5, size.height * 0.82),
      );
    }
  }

  @override
  bool shouldRelayout(IdentityPassRectoDelegate oldDelegate) {
    return oldDelegate.position != position;
  }
}
