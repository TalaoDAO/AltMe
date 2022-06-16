import 'package:altme/app/app.dart';
import 'package:altme/home/home.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class Over18DisplayInList extends StatelessWidget {
  const Over18DisplayInList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return const Over18Recto();
  }
}

class Over18DisplayInSelectionList extends StatelessWidget {
  const Over18DisplayInSelectionList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return const Over18Recto();
  }
}

class Over18DisplayDetail extends StatelessWidget {
  const Over18DisplayDetail({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CardAnimation(
          recto: const Over18Recto(),
          verso: Over18Verso(credentialModel: credentialModel),
        ),
      ],
    );
  }
}

class Over18Recto extends Recto {
  const Over18Recto({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CredentialImage(
      image: ImageStrings.over18Back,
      child: AspectRatio(
        aspectRatio: 584 / 317,
        child: SizedBox.shrink(),
      ),
    );
  }
}

class Over18Verso extends Verso {
  const Over18Verso({Key? key, required this.credentialModel})
      : super(key: key);
  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final over18Model =
        credentialModel.credentialPreview.credentialSubjectModel as Over18Model;
    final expirationDate = credentialModel.expirationDate;
    final issuerName = over18Model.issuedBy!.name;

    return CredentialImage(
      image: ImageStrings.over18Front,
      child: AspectRatio(
        /// size from over18 recto picture
        aspectRatio: 584 / 317,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 24, left: 24),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  height: 40,
                  child: ImageFromNetwork(
                    over18Model.issuedBy!.logo,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            if (expirationDate != null)
              TextWithOver18CardStyle(
                value: '${l10n.expires}: ${UiDate.displayDate(
                  l10n,
                  expirationDate,
                )}',
              )
            else
              const SizedBox.shrink(),
            TextWithOver18CardStyle(
              value: '${l10n.issuer}: $issuerName',
            ),
          ],
        ),
      ),
    );
  }
}

class TextWithOver18CardStyle extends StatelessWidget {
  const TextWithOver18CardStyle({
    Key? key,
    required this.value,
  }) : super(key: key);

  final String value;

  @override
  Widget build(BuildContext context) {
    if (value != '') {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Text(value, style: Theme.of(context).textTheme.over18),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
