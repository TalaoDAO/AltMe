import 'package:altme/app/app.dart';
import 'package:altme/credentials/credential.dart';
import 'package:flutter/material.dart';

class EmailPassDetailsWidget extends StatelessWidget {
  final CredentialModel credentialModel;
  final EmailPassModel emailPassModel;

  const EmailPassDetailsWidget(
      {Key? key, required this.credentialModel, required this.emailPassModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 584 / 317,
          child: SizedBox(
            height: 317,
            width: 584,
            child: CardAnimationWidget(
              recto: EmailPassRecto(credentialModel),
              verso: EmailPassVerso(
                emailPassModel: emailPassModel,
                credentialModel: credentialModel,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
