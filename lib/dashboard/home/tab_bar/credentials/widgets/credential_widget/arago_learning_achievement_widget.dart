import 'package:arago_wallet/app/app.dart';
import 'package:arago_wallet/dashboard/dashboard.dart';
import 'package:arago_wallet/theme/theme.dart';
import 'package:flutter/material.dart';

class AragoLearningAchievementDisplayInList extends StatelessWidget {
  const AragoLearningAchievementDisplayInList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return AragoLearningAchievementRecto(credentialModel: credentialModel);
  }
}

class AragoLearningAchievementDisplayInSelectionList extends StatelessWidget {
  const AragoLearningAchievementDisplayInSelectionList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return AragoLearningAchievementRecto(credentialModel: credentialModel);
  }
}

class AragoLearningAchievementDisplayDetail extends StatelessWidget {
  const AragoLearningAchievementDisplayDetail({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CardAnimation(
          recto:
              AragoLearningAchievementRecto(credentialModel: credentialModel),
          verso:
              AragoLearningAchievementVerso(credentialModel: credentialModel),
        ),
      ],
    );
  }
}

class AragoLearningAchievementRecto extends Recto {
  const AragoLearningAchievementRecto({Key? key, required this.credentialModel})
      : super(key: key);
  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return CredentialImage(
      image: ImageStrings.aragoLearningAchievementFront,
      child: AspectRatio(
        aspectRatio: Sizes.credentialAspectRatio,
        child: FractionallySizedBox(
          widthFactor: 0.7,
          alignment: Alignment.centerLeft,
          child: CustomMultiChildLayout(
            delegate:
                AragoLearningAchievementVersoDelegate(position: Offset.zero),
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
                child: MyText(
                  credentialModel
                      .credentialPreview.credentialSubjectModel.issuedBy!.name,
                  style: Theme.of(context).textTheme.studentCardSchool,
                ),
              ),
              LayoutId(
                id: 'description',
                child: DisplayDescriptionCard(
                  credentialModel: credentialModel,
                  style:
                      Theme.of(context).textTheme.credentialStudentCardTextCard,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AragoLearningAchievementVerso extends Verso {
  const AragoLearningAchievementVerso({Key? key, required this.credentialModel})
      : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    // final l10n = context.l10n;
    // final learningAchievementModel = credentialModel
    //     .credentialPreview.credentialSubjectModel as LearningAchievementModel;

    return const CredentialImage(
      image: ImageStrings.learningAchievementBack,
      // child: AspectRatio(
      //   aspectRatio: Sizes.credentialAspectRatio,
      //   child: CustomMultiChildLayout(
      //     delegate: LearningAchievementDelegate(position: Offset.zero),
      //     children: [
      //       LayoutId(
      //         id: 'name',
      //         child: DisplayNameCard(
      //           credentialModel: credentialModel,
      //           style: Theme.of(context).textTheme.credentialTitleCard,
      //         ),
      //       ),
      //       LayoutId(
      //         id: 'school',
      //         child: MyText(
      //           learningAchievementModel.issuedBy!.name,
      //           overflow: TextOverflow.fade,
      //           style: Theme.of(context).textTheme.studentCardSchool,
      //         ),
      //       ),
      //       LayoutId(
      //         id: 'familyName',
      //         child: Row(
      //           children: [
      //             ImageCardText(
      //               text: '${l10n.personalLastName}: ',
      //               textStyle: Theme.of(context)
      //                   .textTheme
      //                   .studentCardData
      //                   .copyWith(fontWeight: FontWeight.bold),
      //             ),
      //             ImageCardText(
      //               text: learningAchievementModel.familyName!,
      //               textStyle: Theme.of(context).textTheme.studentCardData,
      //             ),
      //           ],
      //         ),
      //       ),
      //       LayoutId(
      //         id: 'givenName',
      //         child: Row(
      //           children: [
      //             ImageCardText(
      //               text: '${l10n.personalFirstName}: ',
      //               textStyle: Theme.of(context)
      //                   .textTheme
      //                   .studentCardData
      //                   .copyWith(fontWeight: FontWeight.bold),
      //             ),
      //             ImageCardText(
      //               text: learningAchievementModel.givenName!,
      //               textStyle: Theme.of(context).textTheme.studentCardData,
      //             ),
      //           ],
      //         ),
      //       ),
      //       LayoutId(
      //         id: 'birthDate',
      //         child: Row(
      //           children: [
      //             ImageCardText(
      //               text: '${l10n.birthdate}: ',
      //               textStyle: Theme.of(context)
      //                   .textTheme
      //                   .studentCardData
      //                   .copyWith(fontWeight: FontWeight.bold),
      //             ),
      //             ImageCardText(
      //               text: UiDate.formatStringDate(
      //                 learningAchievementModel.birthDate!,
      //               ),
      //               textStyle: Theme.of(context).textTheme.studentCardData,
      //             ),
      //           ],
      //         ),
      //       ),
      //       LayoutId(
      //         id: 'hasCredential',
      //         child: Row(
      //           children: [
      //             ImageCardText(
      //               text:
      //                   '''${learningAchievementModel.hasCredential!.title}: ''',
      //               textStyle: Theme.of(context)
      //                   .textTheme
      //                   .studentCardData
      //                   .copyWith(fontWeight: FontWeight.bold),
      //             ),
      //             ImageCardText(
      //               text: learningAchievementModel.hasCredential!.description,
      //               textStyle: Theme.of(context).textTheme.studentCardData,
      //             ),
      //           ],
      //         ),
      //       ),
      //       LayoutId(
      //         id: 'proof',
      //         child: Row(
      //           children: [
      //             ImageCardText(
      //               text: '${l10n.proof}: ',
      //               textStyle: Theme.of(context)
      //                   .textTheme
      //                   .studentCardData
      //                   .copyWith(fontWeight: FontWeight.bold),
      //             ),
      //             InkWell(
      //               onTap: () async {
      //                 await LaunchUrl.launch(
      //                   credentialModel.credentialPreview.evidence.first.id,
      //                 );
      //               },
      //               child: ImageCardText(
      //                 text: credentialModel.credentialPreview.evidence.first.id,
      //                 textStyle: Theme.of(context).textTheme.studentCardData,
      //               ),
      //             )
      //           ],
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}

class AragoLearningAchievementDelegate extends MultiChildLayoutDelegate {
  AragoLearningAchievementDelegate({this.position = Offset.zero});

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
  bool shouldRelayout(AragoLearningAchievementDelegate oldDelegate) {
    return oldDelegate.position != position;
  }
}

class AragoLearningAchievementVersoDelegate extends MultiChildLayoutDelegate {
  AragoLearningAchievementVersoDelegate({this.position = Offset.zero});

  final Offset position;

  @override
  void performLayout(Size size) {
    if (hasChild('name')) {
      layoutChild('name', BoxConstraints.loose(size));
      positionChild('name', Offset(size.width * 0.06, size.height * 0.10));
    }
    if (hasChild('school')) {
      layoutChild('school', BoxConstraints.loose(size));
      positionChild('school', Offset(size.width * 0.06, size.height * 0.32));
    }
    if (hasChild('description')) {
      layoutChild('description', BoxConstraints.loose(size));
      positionChild(
        'description',
        Offset(size.width * 0.06, size.height * 0.53),
      );
    }
  }

  @override
  bool shouldRelayout(AragoLearningAchievementVersoDelegate oldDelegate) {
    return oldDelegate.position != position;
  }
}
