import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';

import 'package:flutter/material.dart';

class DefaultDisplayDescriptor extends StatelessWidget {
  const DefaultDisplayDescriptor({
    super.key,
    this.showBgDecoration = true,
    required this.credentialModel,
    required this.descriptionMaxLine,
    required this.isDiscover,
    this.displyalDescription = true,
  });

  final CredentialModel credentialModel;
  final int descriptionMaxLine;
  final bool showBgDecoration;
  final bool displyalDescription;
  final bool isDiscover;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = credentialModel.display?.backgroundColor;
    final backgroundImage = credentialModel.display?.backgroundImage?.url ??
        credentialModel.display?.backgroundImage?.uri;
    final altText = credentialModel.display?.backgroundImage?.altText ??
        credentialModel.display?.backgroundImage?.altText;

    return (backgroundImage != null && backgroundImage != '')
        ? Semantics(
            label: altText,
            child: AspectRatio(
              aspectRatio: Sizes.credentialAspectRatio,
              child: CredentialUrlImage(
                url: backgroundImage,
                child: DefaultCardBody(
                  credentialModel: credentialModel,
                  descriptionMaxLine: descriptionMaxLine,
                  displyalDescription: displyalDescription,
                ),
              ),
            ),
          )
        : backgroundColor != null
            ? CredentialBackground(
                credentialModel: credentialModel,
                showBgDecoration: showBgDecoration,
                padding: EdgeInsets.zero,
                child: AspectRatio(
                  aspectRatio: Sizes.credentialAspectRatio,
                  child: Stack(
                    children: [
                      DefaultCardBody(
                        credentialModel: credentialModel,
                        descriptionMaxLine: descriptionMaxLine,
                        displyalDescription: displyalDescription,
                      ),
                      if (isDiscover) Image.asset(ImageStrings.blankGetCard),
                    ],
                  ),
                ),
              )
            : CredentialImage(
                image: ImageStrings.defaultCard,
                child: AspectRatio(
                  aspectRatio: Sizes.credentialAspectRatio,
                  child: DefaultCardBody(
                    credentialModel: credentialModel,
                    descriptionMaxLine: descriptionMaxLine,
                    displyalDescription: displyalDescription,
                  ),
                ),
              );
  }
}

class DefaultCardBody extends StatelessWidget {
  const DefaultCardBody({
    super.key,
    required this.credentialModel,
    required this.descriptionMaxLine,
    this.showBgDecoration = true,
    this.displyalDescription = true,
  });

  final CredentialModel credentialModel;
  final int descriptionMaxLine;
  final bool showBgDecoration;

  final bool displyalDescription;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textColor = credentialModel.display?.textColor != null
        ? Color(
            int.parse(
              'FF${credentialModel.display?.textColor!.replaceAll('#', '')}',
              radix: 16,
            ),
          )
        : null;

    final logo = credentialModel.display?.logo?.url ??
        credentialModel.display?.logo?.uri;

    return CustomMultiChildLayout(
      delegate: CredentialBaseWidgetDelegate(position: Offset.zero),
      children: [
        LayoutId(
          id: 'title',
          child: FractionallySizedBox(
            widthFactor: 0.8,
            heightFactor: 0.19,
            child: Row(
              children: [
                if (logo != null && logo != '') ...[
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: CachedImageFromNetwork(
                        logo,
                        fit: BoxFit.contain,
                        bgColor: Colors.transparent,
                        errorMessage: '',
                        showLoading: false,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
                Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: DisplayNameCard(
                      credentialModel: credentialModel,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(color: textColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (credentialModel
                    .credentialPreview.credentialSubjectModel.issuedBy?.name !=
                null &&
            credentialModel.credentialPreview.credentialSubjectModel.issuedBy!
                .name.isNotEmpty)
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
                          .bodyMedium!
                          .copyWith(color: textColor),
                    ),
                    TextSpan(
                      text: credentialModel.credentialPreview
                          .credentialSubjectModel.issuedBy?.name,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: textColor),
                    ),
                  ],
                ),
              ),
            ),
          ),
        if (displyalDescription)
          LayoutId(
            id: 'value',
            child: FractionallySizedBox(
              widthFactor: 0.8,
              heightFactor: 0.15,
              child: Container(
                alignment: Alignment.centerLeft,
                child: DisplayDescriptionCard(
                  credentialModel: credentialModel,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: textColor),
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
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: textColor),
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
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: textColor),
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
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: textColor),
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
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: textColor),
              ),
            ),
          ),
      ],
    );
  }
}
