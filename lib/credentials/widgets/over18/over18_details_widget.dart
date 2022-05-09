import 'package:altme/app/app.dart';
import 'package:altme/credentials/credential.dart';
import 'package:flutter/material.dart';

class Over18DetailsWidget extends StatelessWidget {
  final CredentialModel credentialModel;

  const Over18DetailsWidget({Key? key, required this.credentialModel})
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
                  recto: const Over18Recto(), verso: Over18Verso(credentialModel)),
            )),
      ],
    );
  }
}
