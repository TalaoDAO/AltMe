import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class DefaultDisplayDescriptor extends StatelessWidget {
  const DefaultDisplayDescriptor({
    super.key,
    required this.credentialModel,
    required this.descriptionMaxLine,
    this.showBgDecoration = true,
  });

  final CredentialModel credentialModel;
  final int descriptionMaxLine;
  final bool showBgDecoration;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return CredentialImage(
      image: ImageStrings.defaultCard,
      child: AspectRatio(
        aspectRatio: Sizes.credentialAspectRatio,
        child: CustomMultiChildLayout(
          delegate: CredentialBaseWidgetDelegate(position: Offset.zero),
          children: [
            LayoutId(
              id: 'title',
              child: FractionallySizedBox(
                widthFactor: 0.7,
                heightFactor: 0.19,
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: DisplayNameCard(
                    credentialModel: credentialModel,
                    style: Theme.of(context).textTheme.credentialBaseTitleText,
                  ),
                ),
              ),
            ),
            if (credentialModel.credentialPreview.credentialSubjectModel
                        .issuedBy?.name !=
                    null &&
                credentialModel.credentialPreview.credentialSubjectModel
                    .issuedBy!.name.isNotEmpty)
              LayoutId(
                id: 'provided-by',
                child: FractionallySizedBox(
                  widthFactor: 0.75,
                  heightFactor: 0.11,
                  child: MyRichText(
                    text: TextSpan(
                      children: <InlineSpan>[
                        TextSpan(
                          text: '${l10n.providedBy} ',
                          style: Theme.of(context)
                              .textTheme
                              .credentialBaseLightText,
                        ),
                        TextSpan(
                          text: credentialModel.credentialPreview
                              .credentialSubjectModel.issuedBy?.name,
                          style: Theme.of(context)
                              .textTheme
                              .credentialBaseBoldText,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            LayoutId(
              id: 'value',
              child: FractionallySizedBox(
                widthFactor: 0.8,
                heightFactor: 0.15,
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: DisplayDescriptionCard(
                    credentialModel: credentialModel,
                    style: Theme.of(context).textTheme.credentialBaseBoldText,
                    maxLines: descriptionMaxLine,
                  ),
                ),
              ),
            ),
            if (credentialModel.credentialPreview.issuanceDate != '')
              LayoutId(
                id: 'issued-on',
                child: FractionallySizedBox(
                  heightFactor: 0.10,
                  widthFactor: 0.4,
                  child: MyText(
                    l10n.issuedOn,
                    style: Theme.of(context).textTheme.credentialBaseBoldText,
                  ),
                ),
              ),
            if (credentialModel.credentialPreview.issuanceDate != '')
              LayoutId(
                id: 'issued-on-value',
                child: FractionallySizedBox(
                  heightFactor: 0.10,
                  widthFactor: 0.4,
                  child: MyText(
                    UiDate.formatDateForCredentialCard(
                      credentialModel.credentialPreview.issuanceDate,
                    ),
                    style: Theme.of(context).textTheme.credentialBaseLightText,
                  ),
                ),
              ),
            if (credentialModel.expirationDate != null)
              LayoutId(
                id: 'expiration-date',
                child: FractionallySizedBox(
                  heightFactor: 0.10,
                  widthFactor: 0.4,
                  child: MyText(
                    l10n.expirationDate,
                    style: Theme.of(context).textTheme.credentialBaseBoldText,
                  ),
                ),
              ),
            if (credentialModel.expirationDate != null)
              LayoutId(
                id: 'expiration-date-value',
                child: FractionallySizedBox(
                  heightFactor: 0.10,
                  widthFactor: 0.4,
                  child: MyText(
                    UiDate.formatDateForCredentialCard(
                      credentialModel.expirationDate!,
                    ),
                    style: Theme.of(context).textTheme.credentialBaseLightText,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
