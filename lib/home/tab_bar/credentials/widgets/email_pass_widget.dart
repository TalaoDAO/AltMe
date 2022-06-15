import 'package:altme/app/app.dart';
import 'package:altme/home/home.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class EmailPassDisplayInList extends StatelessWidget {
  const EmailPassDisplayInList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return EmailPassRecto(credentialModel: credentialModel);
  }
}

class EmailPassDisplayInSelectionList extends StatelessWidget {
  const EmailPassDisplayInSelectionList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return EmailPassRecto(credentialModel: credentialModel);
  }
}

class EmailPassDisplayDetail extends StatelessWidget {
  const EmailPassDisplayDetail({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CardAnimation(
          recto: EmailPassRecto(credentialModel: credentialModel),
          verso: EmailPassVerso(credentialModel: credentialModel),
        ),
      ],
    );
  }
}

class EmailPassRecto extends Recto {
  const EmailPassRecto({Key? key, required this.credentialModel})
      : super(key: key);
  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return CredentialImage(
      image: ImageStrings.emailPassFront,
      child: AspectRatio(
        aspectRatio: 584 / 317,
        child: CustomMultiChildLayout(
          delegate: EmailPassVersoDelegate(position: Offset.zero),
          children: [
            LayoutId(
              id: 'name',
              child: FractionallySizedBox(
                widthFactor: 0.5,
                child: DisplayNameCard(
                  credentialModel: credentialModel,
                  style: Theme.of(context).textTheme.credentialTitleCard,
                ),
              ),
            ),
            LayoutId(
              id: 'description',
              child: FractionallySizedBox(
                widthFactor: 0.65,
                heightFactor: 0.45,
                child: DisplayDescriptionCard(
                  credentialModel: credentialModel,
                  style: Theme.of(context).textTheme.credentialTextCard,
                ),
              ),
            ),
            LayoutId(
              id: 'issuer',
              child: Row(
                children: [
                  FractionallySizedBox(
                    heightFactor: 0.15,
                    child: ImageFromNetwork(
                      credentialModel.credentialPreview.credentialSubjectModel
                          .issuedBy!.logo,
                      fit: BoxFit.fill,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class EmailPassVerso extends Verso {
  const EmailPassVerso({Key? key, required this.credentialModel})
      : super(key: key);
  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    final emailPassModel = credentialModel
        .credentialPreview.credentialSubjectModel as EmailPassModel;
    return CredentialImage(
      image: ImageStrings.emailPassBack,
      child: AspectRatio(
        aspectRatio: 584 / 317,
        child: CustomMultiChildLayout(
          delegate: EmailPassVersoDelegate(position: Offset.zero),
          children: [
            LayoutId(
              id: 'name',
              child: FractionallySizedBox(
                widthFactor: 0.5,
                child: DisplayNameCard(
                  credentialModel: credentialModel,
                  style: Theme.of(context).textTheme.credentialTitleCard,
                ),
              ),
            ),
            LayoutId(
              id: 'description',
              child: FractionallySizedBox(
                widthFactor: 0.65,
                child: DisplayDescriptionCard(
                  credentialModel: credentialModel,
                  style: Theme.of(context).textTheme.credentialTextCard,
                ),
              ),
            ),
            LayoutId(
              id: 'issuer',
              child: Row(
                children: [
                  FractionallySizedBox(
                    heightFactor: 0.15,
                    child: ImageFromNetwork(
                      credentialModel.credentialPreview.credentialSubjectModel
                          .issuedBy!.logo,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    emailPassModel.email!,
                    style: Theme.of(context).textTheme.credentialTextCard,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class EmailPassVersoDelegate extends MultiChildLayoutDelegate {
  EmailPassVersoDelegate({this.position = Offset.zero});

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

    if (hasChild('issuer')) {
      layoutChild('issuer', BoxConstraints.loose(size));
      positionChild('issuer', Offset(size.width * 0.06, size.height * 0.783));
    }
  }

  @override
  bool shouldRelayout(EmailPassVersoDelegate oldDelegate) {
    return oldDelegate.position != position;
  }
}
