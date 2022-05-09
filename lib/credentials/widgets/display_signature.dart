import 'package:altme/app/app.dart';
import 'package:altme/credentials/credential.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class DisplaySignatures extends StatelessWidget {
  const DisplaySignatures({
    Key? key,
    required this.item,
  }) : super(key: key);

  final SignatureModel item;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CredentialField(title: context.l10n.signedBy, value: item.name),
        if (item.image != '')
          Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
              height: 100,
              child: ImageFromNetwork(item.image),
            ),
          )
        else
          const SizedBox.shrink(),
      ],
    );
  }
}
