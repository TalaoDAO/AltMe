import 'package:altme/app/shared/widget/base/credential_field.dart';
import 'package:altme/app/shared/widget/cached_image_from_network.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/signature/signature.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DisplaySignatures extends StatelessWidget {
  const DisplaySignatures({
    super.key,
    required this.localizations,
    required this.signature,
  });

  final AppLocalizations localizations;
  final Signature signature;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CredentialField(title: localizations.signedBy, value: signature.name),
        if (signature.image != '')
          Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
              height: 100,
              child: CachedImageFromNetwork(signature.image),
            ),
          )
        else
          const SizedBox.shrink(),
      ],
    );
  }
}
