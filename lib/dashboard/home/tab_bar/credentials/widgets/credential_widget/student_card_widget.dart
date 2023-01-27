import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class StudentCardWidget extends StatelessWidget {
  const StudentCardWidget({
    super.key,
    required this.credentialModel,
  });

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CardAnimation(
          recto: StudentCardRecto(credentialModel: credentialModel),
          verso: StudentCardVerso(credentialModel: credentialModel),
        ),
      ],
    );
  }
}

class StudentCardRecto extends Recto {
  const StudentCardRecto({super.key, required this.credentialModel});
  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    final studentCardModel = credentialModel
        .credentialPreview.credentialSubjectModel as StudentCardModel;

    return CredentialImage(
      image: ImageStrings.studentCardFront,
      child: AspectRatio(
        // aspectRatio: 572 / 315,
        aspectRatio: Sizes.credentialAspectRatio,
        child: CustomMultiChildLayout(
          delegate: StudentCardVersoDelegate(position: Offset.zero),
          children: [
            LayoutId(
              id: 'name',
              child: FractionallySizedBox(
                widthFactor: 0.6,
                alignment: Alignment.centerLeft,
                child: DisplayNameCard(
                  credentialModel: credentialModel,
                  style: Theme.of(context).textTheme.credentialTitleCard,
                ),
              ),
            ),
            LayoutId(
              id: 'school',
              child: FractionallySizedBox(
                widthFactor: 0.3,
                alignment: Alignment.centerLeft,
                child: MyText(
                  studentCardModel.issuedBy!.name,
                  style: Theme.of(context).textTheme.studentCardSchool,
                ),
              ),
            ),
            LayoutId(
              id: 'description',
              child: FractionallySizedBox(
                widthFactor: 0.7,
                heightFactor: 0.33,
                alignment: Alignment.centerLeft,
                child: DisplayDescriptionCard(
                  credentialModel: credentialModel,
                  style:
                      Theme.of(context).textTheme.credentialStudentCardTextCard,
                  maxLines: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StudentCardVerso extends Verso {
  const StudentCardVerso({
    super.key,
    required this.credentialModel,
  });

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final studentCardModel = credentialModel
        .credentialPreview.credentialSubjectModel as StudentCardModel;
    return CredentialImage(
      image: ImageStrings.studentCardBack,
      child: AspectRatio(
        aspectRatio: Sizes.credentialAspectRatio,
        child: CustomMultiChildLayout(
          delegate: StudentCardDelegate(position: Offset.zero),
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
                studentCardModel.issuedBy!.name,
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
                    text: studentCardModel.recipient!.familyName,
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
                    text: studentCardModel.recipient!.givenName,
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
                    text: UiDate.formatStringDate(
                      studentCardModel.recipient!.birthDate,
                    ),
                    textStyle: Theme.of(context).textTheme.studentCardData,
                  ),
                ],
              ),
            ),
            LayoutId(
              id: 'expires',
              child: Row(
                children: [
                  ImageCardText(
                    text: '${l10n.expires}: ',
                    textStyle: Theme.of(context)
                        .textTheme
                        .studentCardData
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  ImageCardText(
                    text: UiDate.formatStringDate(studentCardModel.expires!),
                    textStyle: Theme.of(context).textTheme.studentCardData,
                  ),
                ],
              ),
            ),
            LayoutId(
              id: 'signature',
              child: ImageCardText(
                text: '${l10n.signature}: ',
                textStyle: Theme.of(context)
                    .textTheme
                    .studentCardData
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            LayoutId(
              id: 'image',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedImageFromNetwork(
                  studentCardModel.recipient!.image,
                  fit: BoxFit.fill,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class StudentCardDelegate extends MultiChildLayoutDelegate {
  StudentCardDelegate({this.position = Offset.zero});

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
      positionChild('birthDate', Offset(size.width * 0.5, size.height * 0.53));
    }

    if (hasChild('expires')) {
      layoutChild('expires', BoxConstraints.loose(size));
      positionChild('expires', Offset(size.width * 0.5, size.height * 0.63));
    }

    if (hasChild('signature')) {
      layoutChild('signature', BoxConstraints.loose(size));
      positionChild('signature', Offset(size.width * 0.06, size.height * 0.8));
    }

    if (hasChild('image')) {
      layoutChild(
        'image',
        BoxConstraints.tightFor(
          width: size.width * 0.23,
          height: size.height * 0.42,
        ),
      );
      positionChild('image', Offset(size.width * 0.74, size.height * 0.06));
    }
  }

  @override
  bool shouldRelayout(StudentCardDelegate oldDelegate) {
    return oldDelegate.position != position;
  }
}

class StudentCardVersoDelegate extends MultiChildLayoutDelegate {
  StudentCardVersoDelegate({this.position = Offset.zero});

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
  bool shouldRelayout(StudentCardVersoDelegate oldDelegate) {
    return oldDelegate.position != position;
  }
}
