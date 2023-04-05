import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class KYCAgeCredentialWidget extends StatelessWidget {
  const KYCAgeCredentialWidget({
    super.key,
    required this.credentialModel,
  });

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final kycAgeResidenceCardModel = credentialModel
        .credentialPreview.credentialSubjectModel as KYCAgeCredentialModel;

    return CredentialBackground(
      credentialModel: credentialModel,
      padding: EdgeInsets.zero,
      child: AspectRatio(
        aspectRatio: Sizes.credentialAspectRatio,
        child: CustomMultiChildLayout(
          delegate: KYCAgeCredentialDelegate(position: Offset.zero),
          children: [
            LayoutId(
              id: 'name',
              child: FractionallySizedBox(
                widthFactor: 0.7,
                heightFactor: 0.2,
                child: MyText(
                  kycAgeResidenceCardModel.credentialSubjectType.title,
                  style: Theme.of(context).textTheme.credentialTitleCard,
                ),
              ),
            ),
            LayoutId(
              id: 'birthday',
              child: FractionallySizedBox(
                widthFactor: 0.8,
                heightFactor: 0.14,
                child: MyRichText(
                  text: TextSpan(
                    children: <InlineSpan>[
                      TextSpan(
                        text: '${l10n.birthdate}: ',
                        style: Theme.of(context)
                            .textTheme
                            .credentialFieldTitle
                            .copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                      ),
                      TextSpan(
                        text: birthDateFormater(
                          kycAgeResidenceCardModel.birthday!,
                        ),
                        style: Theme.of(context)
                            .textTheme
                            .credentialFieldDescription
                            .copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            LayoutId(
              id: 'documentType',
              child: FractionallySizedBox(
                widthFactor: 0.8,
                heightFactor: 0.14,
                child: MyRichText(
                  text: TextSpan(
                    children: <InlineSpan>[
                      TextSpan(
                        text: 'Document Type: ',
                        style: Theme.of(context)
                            .textTheme
                            .credentialFieldTitle
                            .copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                      ),
                      TextSpan(
                        text: kycAgeResidenceCardModel.documentType.toString(),
                        style: Theme.of(context)
                            .textTheme
                            .credentialFieldDescription
                            .copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            LayoutId(
              id: 'did',
              child: FractionallySizedBox(
                widthFactor: 0.88,
                heightFactor: 0.26,
                child: Container(
                  alignment: Alignment.bottomLeft,
                  child: MyText(
                    kycAgeResidenceCardModel.id.toString(),
                    maxLines: 2,
                    style: Theme.of(context).textTheme.polygonCardDetail,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class KYCAgeCredentialDelegate extends MultiChildLayoutDelegate {
  KYCAgeCredentialDelegate({this.position = Offset.zero});

  final Offset position;

  @override
  void performLayout(Size size) {
    if (hasChild('name')) {
      layoutChild('name', BoxConstraints.loose(size));
      positionChild('name', Offset(size.width * 0.06, size.height * 0.10));
    }
    if (hasChild('birthday')) {
      layoutChild('birthday', BoxConstraints.loose(size));
      positionChild('birthday', Offset(size.width * 0.06, size.height * 0.32));
    }
    if (hasChild('documentType')) {
      layoutChild('documentType', BoxConstraints.loose(size));
      positionChild(
        'documentType',
        Offset(size.width * 0.06, size.height * 0.48),
      );
    }
    if (hasChild('did')) {
      layoutChild('did', BoxConstraints.loose(size));
      positionChild(
        'did',
        Offset(size.width * 0.06, size.height * 0.65),
      );
    }
  }

  @override
  bool shouldRelayout(KYCAgeCredentialDelegate oldDelegate) {
    return oldDelegate.position != position;
  }
}
