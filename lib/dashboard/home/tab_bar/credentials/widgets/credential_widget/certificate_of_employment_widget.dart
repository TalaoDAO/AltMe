import 'package:altme/app/app.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/credential.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class CertificateOfEmploymentWidget extends StatelessWidget {
  const CertificateOfEmploymentWidget({
    super.key,
    required this.credentialModel,
  });

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CardAnimation(
          recto: CertificateOfEmploymentRecto(credentialModel: credentialModel),
          verso: CertificateOfEmploymentVerso(
            credentialModel: credentialModel,
          ),
        ),
      ],
    );
  }
}

class CertificateOfEmploymentRecto extends Recto {
  const CertificateOfEmploymentRecto({
    super.key,
    required this.credentialModel,
  });
  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return CredentialImage(
      image: ImageStrings.employmentCertificateFront,
      child: AspectRatio(
        aspectRatio: Sizes.credentialAspectRatio,
        child: FractionallySizedBox(
          widthFactor: 0.7,
          alignment: Alignment.centerLeft,
          child: CustomMultiChildLayout(
            delegate: CertificateOfEmploymentModelRectoDelegate(
              position: Offset.zero,
            ),
            children: [
              LayoutId(
                id: 'name',
                child: DisplayNameCard(
                  credentialModel: credentialModel,
                  style: Theme.of(context)
                      .textTheme
                      .certificateOfEmploymentTitleCard,
                ),
              ),
              LayoutId(
                id: 'description',
                child: DisplayDescriptionCard(
                  credentialModel: credentialModel,
                  style: Theme.of(context).textTheme.credentialDescription,
                  maxLines: 4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CertificateOfEmploymentVerso extends Verso {
  const CertificateOfEmploymentVerso({
    required this.credentialModel,
    super.key,
  });

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final certificateOfEmploymentModel = credentialModel.credentialPreview
        .credentialSubjectModel as CertificateOfEmploymentModel;

    return CredentialImage(
      image: ImageStrings.employmentCertificateBack,
      child: AspectRatio(
        aspectRatio: Sizes.credentialAspectRatio,
        child: CustomMultiChildLayout(
          delegate: CertificateOfEmploymentModelVersoDelegate(
            position: Offset.zero,
          ),
          children: [
            LayoutId(
              id: 'name',
              child: FractionallySizedBox(
                widthFactor: 0.7,
                child: DisplayNameCard(
                  credentialModel: credentialModel,
                  style: Theme.of(context)
                      .textTheme
                      .certificateOfEmploymentTitleCard,
                ),
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
                        .certificateOfEmploymentData
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  ImageCardText(
                    text: certificateOfEmploymentModel.familyName!,
                    textStyle:
                        Theme.of(context).textTheme.certificateOfEmploymentData,
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
                        .certificateOfEmploymentData
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  ImageCardText(
                    text: certificateOfEmploymentModel.givenName!,
                    textStyle:
                        Theme.of(context).textTheme.certificateOfEmploymentData,
                  ),
                ],
              ),
            ),
            LayoutId(
              id: 'workFor',
              child: Row(
                children: [
                  ImageCardText(
                    text: '${l10n.workFor}: ',
                    textStyle: Theme.of(context)
                        .textTheme
                        .certificateOfEmploymentData
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  ImageCardText(
                    text: certificateOfEmploymentModel.workFor!.name,
                    textStyle:
                        Theme.of(context).textTheme.certificateOfEmploymentData,
                  ),
                  const SizedBox(width: 20),
                  if (certificateOfEmploymentModel.workFor!.logo != '')
                    SizedBox(
                      height: 17,
                      child: CachedImageFromNetwork(
                        certificateOfEmploymentModel.workFor!.logo,
                      ),
                    )
                  else
                    const SizedBox.shrink()
                ],
              ),
            ),
            LayoutId(
              id: 'startDate',
              child: Row(
                children: [
                  ImageCardText(
                    text: '${l10n.startDate}: ',
                    textStyle: Theme.of(context)
                        .textTheme
                        .certificateOfEmploymentData
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  ImageCardText(
                    text: UiDate.formatStringDate(
                      certificateOfEmploymentModel.startDate!,
                    ),
                    textStyle:
                        Theme.of(context).textTheme.certificateOfEmploymentData,
                  ),
                ],
              ),
            ),
            LayoutId(
              id: 'jobTitle',
              child: Row(
                children: [
                  ImageCardText(
                    text: '${l10n.jobTitle}: ',
                    textStyle: Theme.of(context)
                        .textTheme
                        .certificateOfEmploymentData
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  ImageCardText(
                    text: certificateOfEmploymentModel.jobTitle!,
                    textStyle:
                        Theme.of(context).textTheme.certificateOfEmploymentData,
                  ),
                ],
              ),
            ),
            LayoutId(
              id: 'employmentType',
              child: Row(
                children: [
                  ImageCardText(
                    text: '${l10n.employmentType}: ',
                    textStyle: Theme.of(context)
                        .textTheme
                        .certificateOfEmploymentData
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  ImageCardText(
                    text: certificateOfEmploymentModel.employmentType!,
                    textStyle:
                        Theme.of(context).textTheme.certificateOfEmploymentData,
                  ),
                ],
              ),
            ),
            LayoutId(
              id: 'baseSalary',
              child: Row(
                children: [
                  ImageCardText(
                    text: '${l10n.baseSalary}: ',
                    textStyle: Theme.of(context)
                        .textTheme
                        .certificateOfEmploymentData
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  ImageCardText(
                    text: certificateOfEmploymentModel.baseSalary!,
                    textStyle:
                        Theme.of(context).textTheme.certificateOfEmploymentData,
                  ),
                ],
              ),
            ),
            LayoutId(
              id: 'issuanceDate',
              child: Row(
                children: [
                  ImageCardText(
                    text: '${l10n.issuanceDate}: ',
                    textStyle: Theme.of(context)
                        .textTheme
                        .certificateOfEmploymentData
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  ImageCardText(
                    text: UiDate.formatStringDate(
                      credentialModel.credentialPreview.issuanceDate,
                    ),
                    textStyle:
                        Theme.of(context).textTheme.certificateOfEmploymentData,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CertificateOfEmploymentModelVersoDelegate
    extends MultiChildLayoutDelegate {
  CertificateOfEmploymentModelVersoDelegate({this.position = Offset.zero});

  final Offset position;

  @override
  void performLayout(Size size) {
    if (hasChild('name')) {
      layoutChild('name', BoxConstraints.loose(size));
      positionChild('name', Offset(size.width * 0.06, size.height * 0.12));
    }
    if (hasChild('familyName')) {
      layoutChild('familyName', BoxConstraints.loose(size));
      positionChild(
        'familyName',
        Offset(size.width * 0.06, size.height * 0.34),
      );
    }
    if (hasChild('givenName')) {
      layoutChild('givenName', BoxConstraints.loose(size));
      positionChild('givenName', Offset(size.width * 0.06, size.height * 0.25));
    }

    if (hasChild('jobTitle')) {
      layoutChild('jobTitle', BoxConstraints.loose(size));
      positionChild('jobTitle', Offset(size.width * 0.06, size.height * 0.43));
    }
    if (hasChild('workFor')) {
      layoutChild('workFor', BoxConstraints.loose(size));
      positionChild('workFor', Offset(size.width * 0.06, size.height * 0.52));
    }

    if (hasChild('startDate')) {
      layoutChild('startDate', BoxConstraints.loose(size));
      positionChild('startDate', Offset(size.width * 0.06, size.height * 0.61));
    }

    if (hasChild('employmentType')) {
      layoutChild('employmentType', BoxConstraints.loose(size));
      positionChild(
        'employmentType',
        Offset(size.width * 0.06, size.height * 0.70),
      );
    }
    if (hasChild('baseSalary')) {
      layoutChild('baseSalary', BoxConstraints.loose(size));
      positionChild(
        'baseSalary',
        Offset(size.width * 0.06, size.height * 0.79),
      );
    }
    if (hasChild('issuanceDate')) {
      layoutChild('issuanceDate', BoxConstraints.loose(size));
      positionChild(
        'issuanceDate',
        Offset(size.width * 0.06, size.height * 0.88),
      );
    }
  }

  @override
  bool shouldRelayout(CertificateOfEmploymentModelVersoDelegate oldDelegate) {
    return oldDelegate.position != position;
  }
}

class CertificateOfEmploymentModelRectoDelegate
    extends MultiChildLayoutDelegate {
  CertificateOfEmploymentModelRectoDelegate({this.position = Offset.zero});

  final Offset position;

  @override
  void performLayout(Size size) {
    if (hasChild('name')) {
      layoutChild('name', BoxConstraints.loose(size));
      positionChild('name', Offset(size.width * 0.06, size.height * 0.14));
    }
    if (hasChild('description')) {
      layoutChild('description', BoxConstraints.loose(size));
      positionChild(
        'description',
        Offset(size.width * 0.06, size.height * 0.33),
      );
    }
  }

  @override
  bool shouldRelayout(CertificateOfEmploymentModelRectoDelegate oldDelegate) {
    return oldDelegate.position != position;
  }
}
