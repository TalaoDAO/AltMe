import 'package:altme/app/shared/widget/base/credential_field.dart';
import 'package:altme/app/shared/widget/image_from_network.dart';
import 'package:altme/home/tab_bar/credentials/models/signature/signature.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DisplaySignatures extends StatelessWidget {
  const DisplaySignatures({
    Key? key,
    required this.localizations,
    required this.item,
  }) : super(key: key);

  final AppLocalizations localizations;
  final Signature item;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CredentialField(title: localizations.signedBy, value: item.name),
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
