import 'package:altme/app/app.dart';
import 'package:altme/home/credentials/credential.dart';
import 'package:altme/l10n/l10n.dart';
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
        AspectRatio(
          aspectRatio: 584 / 317,
          child: SizedBox(
            height: 317,
            width: 584,
            child: CardAnimation(
              recto: EmailPassRecto(credentialModel: credentialModel),
              verso: EmailPassVerso(credentialModel: credentialModel),
            ),
          ),
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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          fit: BoxFit.fitWidth,
          image: AssetImage(ImageStrings.emailPassFront),
        ),
      ),
      child: AspectRatio(
        /// size from over18 recto picture
        aspectRatio: 584 / 317,
        child: SizedBox(
          height: 317,
          width: 584,
          child: CustomMultiChildLayout(
            delegate: EmailPassVersoDelegate(position: Offset.zero),
            children: [
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
                    style: Theme.of(context).textTheme.credentialTextCard,
                  ),
                ),
              ),
              LayoutId(
                id: 'issuer',
                child: Row(
                  children: [
                    SizedBox(
                      height: 30,
                      child: ImageFromNetwork(
                        credentialModel.credentialPreview.credentialSubjectModel
                            .issuedBy!.logo,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
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
    final l10n = context.l10n;
    final emailPassModel = credentialModel
        .credentialPreview.credentialSubjectModel as EmailPassModel;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          fit: BoxFit.fitWidth,
          image: AssetImage(ImageStrings.emailPassBack),
        ),
      ),
      child: AspectRatio(
        /// size from over18 recto picture
        aspectRatio: 584 / 317,
        child: SizedBox(
          height: 317,
          width: 584,
          child: CustomMultiChildLayout(
            delegate: EmailPassVersoDelegate(position: Offset.zero),
            children: [
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
                    style: Theme.of(context).textTheme.credentialTextCard,
                  ),
                ),
              ),
              LayoutId(
                id: 'issuer',
                child: Row(
                  children: [
                    SizedBox(
                      height: 30,
                      child: ImageFromNetwork(
                        credentialModel.credentialPreview.credentialSubjectModel
                            .issuedBy!.logo,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Row(
                      children: [
                        Text(
                          '${l10n.personalMail}: ',
                          style: Theme.of(context)
                              .textTheme
                              .credentialTextCard
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          emailPassModel.email!,
                          style: Theme.of(context).textTheme.credentialTextCard,
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
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
