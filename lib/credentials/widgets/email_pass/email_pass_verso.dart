import 'package:altme/app/app.dart';
import 'package:altme/credentials/credential.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class EmailPassVerso extends Verso {
  const EmailPassVerso(
      {required this.emailPassModel, required this.credentialModel, Key? key})
      : super(key: key);

  final EmailPassModel emailPassModel;
  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          fit: BoxFit.fitWidth,
          image: AssetImage(
            'assets/image/email_pass_verso.png',
          ),
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
                child: DisplayNameCard(credentialModel),
              ),
              LayoutId(
                id: 'description',
                child: Padding(
                  padding: EdgeInsets.only(
                      right: 250 * MediaQuery.of(context).size.aspectRatio),
                  child: DisplayDescriptionCard(credentialModel),
                ),
              ),
              LayoutId(
                id: 'issuer',
                child: Row(
                  children: [
                    SizedBox(
                      height: 30,
                      child: ImageFromNetwork(
                        emailPassModel.issuedBy.logo,
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
                          emailPassModel.email,
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
