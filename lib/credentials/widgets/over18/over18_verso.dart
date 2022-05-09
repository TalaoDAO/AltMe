import 'package:altme/app/app.dart';
import 'package:altme/credentials/credential.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class Over18Verso extends Verso {
  const Over18Verso(this.item, {Key? key}) : super(key: key);
  final CredentialModel item;

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;
    final expirationDate = item.expirationDate;
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: const DecorationImage(
              fit: BoxFit.fitWidth,
              image: AssetImage(
                'assets/image/over18_verso.png',
              ))),
      child: AspectRatio(
        /// size from over18 recto picture
        aspectRatio: 584 / 317,
        child: SizedBox(
          height: 317,
          width: 584,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 24, left: 24),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                      height: 50,
                      child: ImageFromNetwork(
                        item.credentialPreview.credentialSubject.issuedBy.logo,
                        fit: BoxFit.cover,
                      )),
                ),
              ),
              if (expirationDate != null)
                TextWithOver18CardStyle(
                  value: '${localizations.expires}: ${UIDate.displayDate(
                    expirationDate,
                  )}',
                )
              else
                const SizedBox.shrink(),
              TextWithOver18CardStyle(
                value:
                    '${localizations.issuer}: ${item.credentialPreview.credentialSubject.issuedBy.name}',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
