import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:flutter/material.dart';

class CredentialManifestCard extends StatelessWidget {
  const CredentialManifestCard({
    super.key,
    required this.credentialModel,
    required this.showBgDecoration,
    required this.outputDescriptor,
  });

  final CredentialModel credentialModel;
  final OutputDescriptor outputDescriptor;
  final bool showBgDecoration;

  @override
  Widget build(BuildContext context) {
    final textColor = credentialModel.isVerifiableDiplomaType
        ? Colors.white
        : getColorFromCredential(outputDescriptor.styles?.text, Colors.black);

    final backgroundColor = getColorFromCredential(
      outputDescriptor.styles?.background,
      Colors.white,
    )!;

    final l10n = context.l10n;

    return CredentialContainer(
      child: AspectRatio(
        aspectRatio: Sizes.credentialAspectRatio,
        child: DecoratedBox(
          decoration: BaseBoxDecoration(
            borderRadius: BorderRadius.circular(Sizes.credentialBorderRadius),
            color: backgroundColor,
            gradient: credentialModel.isVerifiableDiplomaType
                ? const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xff0B67C5),
                      Color(0xff200072),
                    ],
                  )
                : null,
            shapeColor: Theme.of(context).colorScheme.documentShape,
            value: 1,
            anchors: showBgDecoration
                ? const <Alignment>[Alignment.bottomRight]
                : const <Alignment>[],
          ),
          child: CustomMultiChildLayout(
            delegate: CredentialBaseWidgetDelegate(position: Offset.zero),
            children: [
              if (outputDescriptor.display?.title != null)
                LayoutId(
                  id: 'title',
                  child: FractionallySizedBox(
                    widthFactor: 0.7,
                    heightFactor: 0.19,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: DisplayTitleWidget(
                        displayMapping: outputDescriptor.display?.title,
                        credentialModel: credentialModel,
                        textStyle: textColor == null
                            ? Theme.of(context)
                                .textTheme
                                .credentialBaseTitleText
                            : Theme.of(context)
                                .textTheme
                                .credentialBaseTitleText
                                .copyWith(color: textColor),
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
              if (outputDescriptor.display?.subtitle != null)
                LayoutId(
                  id: 'value',
                  child: FractionallySizedBox(
                    widthFactor: 0.8,
                    heightFactor: 0.15,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: DisplayTitleWidget(
                        displayMapping: outputDescriptor.display?.subtitle,
                        credentialModel: credentialModel,
                        textStyle: textColor == null
                            ? Theme.of(context).textTheme.credentialBaseBoldText
                            : Theme.of(context)
                                .textTheme
                                .credentialBaseBoldText
                                .copyWith(color: textColor),
                      ),
                    ),
                  ),
                ),
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
                      style:
                          Theme.of(context).textTheme.credentialBaseLightText,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
