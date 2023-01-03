import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class Ecole42LearningAchievementWidget extends StatelessWidget {
  const Ecole42LearningAchievementWidget({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    final ecole42LearningAchievementModel = credentialModel.credentialPreview
        .credentialSubjectModel as Ecole42LearningAchievementModel;

    final l10n = context.l10n;
    final studentIdentity = '${ecole42LearningAchievementModel.givenName}'
        ' ${ecole42LearningAchievementModel.familyName},'
        ' born ${UiDate.formatStringDate(
      ecole42LearningAchievementModel.birthDate!,
    )}';
    final evidenceText =
        '''${credentialModel.credentialPreview.evidence.first.id.substring(0, 30)}...''';
    return Column(
      children: [
        AspectRatio(
          /// this size comes from law publication about job student card specs
          aspectRatio: 1240.0 / 1753.0,
          child: CredentialImage(
            image: ImageStrings.ecole42LearningAchievement,
            child: CustomMultiChildLayout(
              delegate: Ecole42LearningAchievementDelegate(
                position: Offset.zero,
              ),
              children: [
                LayoutId(
                  id: 'studentIdentity',
                  child: Row(
                    children: [
                      ImageCardText(
                        text: studentIdentity,
                        textStyle: Theme.of(context)
                            .textTheme
                            .ecole42LearningAchievementStudentIdentity,
                      ),
                    ],
                  ),
                ),
                LayoutId(
                  id: 'level',
                  child: Row(
                    children: [
                      ImageCardText(
                        text:
                            '''Level ${ecole42LearningAchievementModel.hasCredential!.level}''',
                        textStyle: Theme.of(context)
                            .textTheme
                            .ecole42LearningAchievementLevel,
                      ),
                    ],
                  ),
                ),
                LayoutId(
                  id: 'signature',
                  child: credentialModel.image != ''
                      ? Padding(
                          padding: const EdgeInsets.all(8),
                          child: SizedBox(
                            height:
                                80 * MediaQuery.of(context).size.aspectRatio,
                            child: CachedImageFromNetwork(
                              ecole42LearningAchievementModel
                                  .signatureLines!.image,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
        if (credentialModel.credentialPreview.evidence.first.id != '')
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Text(
                  '${l10n.evidenceLabel}: ',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                const SizedBox(width: 5),
                Flexible(
                  child: InkWell(
                    onTap: () async {
                      await LaunchUrl.launch(
                        credentialModel.credentialPreview.evidence.first.id,
                      );
                    },
                    child: Text(
                      evidenceText,
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            color: Theme.of(context).colorScheme.markDownA,
                            decoration: TextDecoration.underline,
                          ),
                      maxLines: 5,
                      overflow: TextOverflow.fade,
                      softWrap: true,
                    ),
                  ),
                ),
              ],
            ),
          )
      ],
    );
  }
}

class Ecole42LearningAchievementDelegate extends MultiChildLayoutDelegate {
  Ecole42LearningAchievementDelegate({this.position = Offset.zero});

  final Offset position;

  @override
  void performLayout(Size size) {
    if (hasChild('studentIdentity')) {
      layoutChild('studentIdentity', BoxConstraints.loose(size));
      positionChild(
        'studentIdentity',
        Offset(size.width * 0.17, size.height * 0.33),
      );
    }
    if (hasChild('signature')) {
      layoutChild('signature', BoxConstraints.loose(size));
      positionChild('signature', Offset(size.width * 0.5, size.height * 0.55));
    }
    if (hasChild('level')) {
      layoutChild('level', BoxConstraints.loose(size));
      positionChild('level', Offset(size.width * 0.605, size.height * 0.3685));
    }
  }

  @override
  bool shouldRelayout(
    covariant Ecole42LearningAchievementDelegate oldDelegate,
  ) {
    return oldDelegate.position != position;
  }
}
