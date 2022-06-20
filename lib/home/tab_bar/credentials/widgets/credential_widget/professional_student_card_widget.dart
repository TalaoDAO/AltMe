import 'package:altme/app/app.dart';
import 'package:altme/home/home.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class ProfessionalStudentCardDisplayInList extends StatelessWidget {
  const ProfessionalStudentCardDisplayInList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return DefaultCredentialSubjectDisplayInList(
      credentialModel: credentialModel,
    );
  }
}

class ProfessionalStudentCardDisplayInSelectionList extends StatelessWidget {
  const ProfessionalStudentCardDisplayInSelectionList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return DefaultCredentialSubjectDisplayInSelectionList(
      credentialModel: credentialModel,
    );
  }
}

class ProfessionalStudentCardDisplayDetail extends StatelessWidget {
  const ProfessionalStudentCardDisplayDetail({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    final professionalStudentCardModel = credentialModel.credentialPreview
        .credentialSubjectModel as ProfessionalStudentCardModel;
    return Column(
      children: [
        CardAnimation(
          recto: JobStudentCardRecto(
            professionalStudentCardModel: professionalStudentCardModel,
          ),
          verso: const JobStudentCardVerso(),
        ),
      ],
    );
  }
}

class JobStudentCardRecto extends Recto {
  const JobStudentCardRecto({
    Key? key,
    required this.professionalStudentCardModel,
  }) : super(key: key);

  final ProfessionalStudentCardModel professionalStudentCardModel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return CredentialImage(
      image: ImageStrings.professionalStudentCardFront,
      child: AspectRatio(
        aspectRatio: Sizes.credentialAspectRatio,
        child: CustomMultiChildLayout(
          delegate: ProfessionalStudentCardDelegate(position: Offset.zero),
          children: [
            LayoutId(
              id: 'familyName',
              child: ImageCardText(
                text: professionalStudentCardModel.recipient!.familyName,
              ),
            ),
            LayoutId(
              id: 'givenName',
              child: ImageCardText(
                text: professionalStudentCardModel.recipient!.givenName,
              ),
            ),
            LayoutId(
              id: 'birthDate',
              child: ImageCardText(
                text: UiDate.displayDate(
                  l10n,
                  professionalStudentCardModel.recipient!.birthDate,
                ),
              ),
            ),
            LayoutId(
              id: 'expires',
              child: ImageCardText(
                text: UiDate.displayDate(
                  l10n,
                  professionalStudentCardModel.expires!,
                ),
              ),
            ),
            LayoutId(
              id: 'signature',
              // TODO(all): Missing field
              child: const ImageCardText(text: ''),
            ),
            LayoutId(
              id: 'image',
              child: ImageFromNetwork(
                professionalStudentCardModel.recipient!.image,
                fit: BoxFit.cover,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class JobStudentCardVerso extends Verso {
  const JobStudentCardVerso({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CredentialImage(
      image: ImageStrings.professionalStudentCardBack,
      child: AspectRatio(
        aspectRatio: Sizes.credentialAspectRatio,
        child: SizedBox.shrink(),
      ),
    );
  }
}

class ProfessionalStudentCardDelegate extends MultiChildLayoutDelegate {
  ProfessionalStudentCardDelegate({this.position = Offset.zero});

  final Offset position;

  @override
  void performLayout(Size size) {
    if (hasChild('familyName')) {
      layoutChild('familyName', BoxConstraints.loose(size));
      positionChild(
        'familyName',
        Offset(size.width * 0.15, size.height * 0.285),
      );
    }
    if (hasChild('givenName')) {
      layoutChild('givenName', BoxConstraints.loose(size));
      positionChild('givenName', Offset(size.width * 0.2, size.height * 0.375));
    }

    if (hasChild('birthDate')) {
      layoutChild('birthDate', BoxConstraints.loose(size));
      positionChild('birthDate', Offset(size.width * 0.2, size.height * 0.47));
    }

    if (hasChild('expires')) {
      layoutChild('expires', BoxConstraints.loose(size));
      positionChild('expires', Offset(size.width * 0.22, size.height * 0.56));
    }

    if (hasChild('signature')) {
      layoutChild('signature', BoxConstraints.loose(size));
      positionChild('signature', Offset(size.width * 0.11, size.height * 0.75));
    }

    if (hasChild('image')) {
      layoutChild(
        'image',
        BoxConstraints.tightFor(
          width: size.width * 0.27,
          height: size.height * 0.577,
        ),
      );
      positionChild('image', Offset(size.width * 0.684, size.height * 0.065));
    }
  }

  @override
  bool shouldRelayout(ProfessionalStudentCardDelegate oldDelegate) {
    return oldDelegate.position != position;
  }
}
