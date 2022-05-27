import 'package:altme/app/app.dart';
import 'package:altme/home/home.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class LearningAchievementDisplayInList extends StatelessWidget {
  const LearningAchievementDisplayInList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return LearningAchievementRecto(credentialModel: credentialModel);
  }
}

class LearningAchievementDisplayInSelectionList extends StatelessWidget {
  const LearningAchievementDisplayInSelectionList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return LearningAchievementRecto(credentialModel: credentialModel);
  }
}

class LearningAchievementDisplayDetail extends StatelessWidget {
  const LearningAchievementDisplayDetail({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 572 / 315,
          child: SizedBox(
            height: 315,
            width: 572,
            child: CardAnimation(
              recto: LearningAchievementRecto(credentialModel: credentialModel),
              verso: LearningAchievementVerso(credentialModel: credentialModel),
            ),
          ),
        ),
      ],
    );
  }
}

class LearningAchievementRecto extends Recto {
  const LearningAchievementRecto({Key? key, required this.credentialModel})
      : super(key: key);
  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return CredentialContainer(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fitWidth,
            image: AssetImage(ImageStrings.learningAchievementFront),
          ),
        ),
        child: AspectRatio(
          /// size from over18 recto picture
          aspectRatio: 572 / 315,
          child: SizedBox(
            height: 315,
            width: 572,
            child: CustomMultiChildLayout(
              delegate: LearningAchievementVersoDelegate(position: Offset.zero),
              children: [
                LayoutId(
                  id: 'school',
                  child: Text(
                    credentialModel.credentialPreview.credentialSubjectModel
                        .issuedBy!.name,
                    overflow: TextOverflow.fade,
                    style: Theme.of(context).textTheme.studentCardSchool,
                  ),
                ),
                LayoutId(
                  id: 'name',
                  child: DisplayNameCard(
                    credentialModel: credentialModel,
                    style: Theme.of(context).textTheme.credentialTitleCard,
                  ),
                ),
                LayoutId(
                  id: 'description',
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: 250 * MediaQuery.of(context).size.aspectRatio,
                    ),
                    child: DisplayDescriptionCard(
                      credentialModel: credentialModel,
                      style: Theme.of(context)
                          .textTheme
                          .credentialStudentCardTextCard,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LearningAchievementVerso extends Verso {
  const LearningAchievementVerso({Key? key, required this.credentialModel})
      : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final learningAchievementModel = credentialModel
        .credentialPreview.credentialSubjectModel as LearningAchievementModel;

    return CredentialContainer(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fitWidth,
            image: AssetImage(ImageStrings.learningAchievementBack),
          ),
        ),
        child: AspectRatio(
          /// this size comes from law publication about job student card specs
          aspectRatio: 572 / 315,
          child: SizedBox(
            height: 315,
            width: 572,
            child: CustomMultiChildLayout(
              delegate: LearningAchievementDelegate(position: Offset.zero),
              children: [
                LayoutId(
                  id: 'name',
                  child: DisplayNameCard(
                    credentialModel: credentialModel,
                    style: Theme.of(context).textTheme.credentialTitleCard,
                  ),
                ),
                LayoutId(
                  id: 'school',
                  child: Text(
                    learningAchievementModel.issuedBy!.name,
                    overflow: TextOverflow.fade,
                    style: Theme.of(context).textTheme.studentCardSchool,
                  ),
                ),
                LayoutId(
                  id: 'familyName',
                  child: Row(
                    children: [
                      ImageCardText(
                        text: '${l10n.personalLastName}: ',
                        textStyle: Theme.of(context)
                            .textTheme
                            .studentCardData
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      ImageCardText(
                        text: learningAchievementModel.familyName!,
                        textStyle: Theme.of(context).textTheme.studentCardData,
                      ),
                    ],
                  ),
                ),
                LayoutId(
                  id: 'givenName',
                  child: Row(
                    children: [
                      ImageCardText(
                        text: '${l10n.personalFirstName}: ',
                        textStyle: Theme.of(context)
                            .textTheme
                            .studentCardData
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      ImageCardText(
                        text: learningAchievementModel.givenName!,
                        textStyle: Theme.of(context).textTheme.studentCardData,
                      ),
                    ],
                  ),
                ),
                LayoutId(
                  id: 'birthDate',
                  child: Row(
                    children: [
                      ImageCardText(
                        text: '${l10n.birthdate}: ',
                        textStyle: Theme.of(context)
                            .textTheme
                            .studentCardData
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      ImageCardText(
                        text: UiDate.displayDate(
                          l10n,
                          learningAchievementModel.birthDate!,
                        ),
                        textStyle: Theme.of(context).textTheme.studentCardData,
                      ),
                    ],
                  ),
                ),
                LayoutId(
                  id: 'hasCredential',
                  child: Row(
                    children: [
                      ImageCardText(
                        text:
                            '''${learningAchievementModel.hasCredential!.title}: ''',
                        textStyle: Theme.of(context)
                            .textTheme
                            .studentCardData
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      ImageCardText(
                        text:
                            learningAchievementModel.hasCredential!.description,
                        textStyle: Theme.of(context).textTheme.studentCardData,
                      ),
                    ],
                  ),
                ),
                LayoutId(
                  id: 'proof',
                  child: Row(
                    children: [
                      ImageCardText(
                        text: '${l10n.proof}: ',
                        textStyle: Theme.of(context)
                            .textTheme
                            .studentCardData
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      InkWell(
                        onTap: () async {
                          await LaunchUrl.launch(
                            credentialModel.credentialPreview.evidence.first.id,
                          );
                        },
                        child: ImageCardText(
                          text: credentialModel
                              .credentialPreview.evidence.first.id,
                          textStyle:
                              Theme.of(context).textTheme.studentCardData,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LearningAchievementDelegate extends MultiChildLayoutDelegate {
  LearningAchievementDelegate({this.position = Offset.zero});

  final Offset position;

  @override
  void performLayout(Size size) {
    if (hasChild('name')) {
      layoutChild('name', BoxConstraints.loose(size));
      positionChild('name', Offset(size.width * 0.06, size.height * 0.16));
    }
    if (hasChild('school')) {
      layoutChild('school', BoxConstraints.loose(size));
      positionChild('school', Offset(size.width * 0.06, size.height * 0.33));
    }

    if (hasChild('familyName')) {
      layoutChild('familyName', BoxConstraints.loose(size));
      positionChild(
        'familyName',
        Offset(size.width * 0.06, size.height * 0.63),
      );
    }
    if (hasChild('givenName')) {
      layoutChild('givenName', BoxConstraints.loose(size));
      positionChild('givenName', Offset(size.width * 0.06, size.height * 0.53));
    }

    if (hasChild('birthDate')) {
      layoutChild('birthDate', BoxConstraints.loose(size));
      positionChild('birthDate', Offset(size.width * 0.45, size.height * 0.53));
    }

    if (hasChild('hasCredential')) {
      layoutChild('hasCredential', BoxConstraints.loose(size));
      positionChild(
        'hasCredential',
        Offset(size.width * 0.45, size.height * 0.63),
      );
    }

    if (hasChild('proof')) {
      layoutChild('proof', BoxConstraints.loose(size));
      positionChild('proof', Offset(size.width * 0.06, size.height * 0.8));
    }
  }

  @override
  bool shouldRelayout(LearningAchievementDelegate oldDelegate) {
    return oldDelegate.position != position;
  }
}

class LearningAchievementVersoDelegate extends MultiChildLayoutDelegate {
  LearningAchievementVersoDelegate({this.position = Offset.zero});

  final Offset position;

  @override
  void performLayout(Size size) {
    if (hasChild('name')) {
      layoutChild('name', BoxConstraints.loose(size));
      positionChild('name', Offset(size.width * 0.06, size.height * 0.16));
    }
    if (hasChild('school')) {
      layoutChild('school', BoxConstraints.loose(size));
      positionChild('school', Offset(size.width * 0.06, size.height * 0.33));
    }
    if (hasChild('description')) {
      layoutChild('description', BoxConstraints.loose(size));
      positionChild(
        'description',
        Offset(size.width * 0.06, size.height * 0.49),
      );
    }
  }

  @override
  bool shouldRelayout(LearningAchievementVersoDelegate oldDelegate) {
    return oldDelegate.position != position;
  }
}
