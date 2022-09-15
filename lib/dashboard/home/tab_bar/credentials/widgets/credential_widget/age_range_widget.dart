import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class AgeRangeDisplayInList extends StatelessWidget {
  const AgeRangeDisplayInList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return AgeRangeRecto(credentialModel: credentialModel);
  }
}

class AgeRangeDisplayInSelectionList extends StatelessWidget {
  const AgeRangeDisplayInSelectionList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return AgeRangeRecto(credentialModel: credentialModel);
  }
}

class AgeRangeDisplayDetail extends StatelessWidget {
  const AgeRangeDisplayDetail({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AgeRangeRecto(credentialModel: credentialModel),
      ],
    );
  }
}

class AgeRangeRecto extends Recto {
  const AgeRangeRecto({Key? key, required this.credentialModel})
      : super(key: key);
  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final ageRangeModel = credentialModel
        .credentialPreview.credentialSubjectModel as AgeRangeModel;

    return CredentialImage(
      image: ImageStrings.ageRangeProof,
      child: AspectRatio(
        aspectRatio: Sizes.credentialAspectRatio,
        child: CustomMultiChildLayout(
          delegate: AgeRangeRectoDelegate(position: Offset.zero),
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
              id: 'age-range',
              child: FractionallySizedBox(
                widthFactor: 0.65,
                heightFactor: 0.15,
                child: MyText(
                  (ageRangeModel.ageRange != null &&
                          ageRangeModel.ageRange!.isNotEmpty)
                      ? '${ageRangeModel.ageRange} YO'
                      : '--',
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

class AgeRangeRectoDelegate extends MultiChildLayoutDelegate {
  AgeRangeRectoDelegate({this.position = Offset.zero});

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

    if (hasChild('age-range')) {
      layoutChild('age-range', BoxConstraints.loose(size));
      positionChild(
        'age-range',
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
  bool shouldRelayout(AgeRangeRectoDelegate oldDelegate) {
    return oldDelegate.position != position;
  }
}
