import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class AragoLearningAchievementWidget extends StatelessWidget {
  const AragoLearningAchievementWidget({
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
    return const CredentialImage(image: ImageStrings.learningAchievementBack);
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
