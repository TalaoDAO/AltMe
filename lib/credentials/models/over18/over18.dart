// ignore_for_file: overridden_fields

import 'package:altme/app/app.dart';
import 'package:altme/app/shared/date/date.dart';
import 'package:altme/app/shared/widget/image_from_network.dart';
import 'package:altme/credentials/credential.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'over18.g.dart';

@JsonSerializable(explicitToJson: true)
class Over18 extends CredentialSubject {
  Over18(this.id, this.type, this.issuedBy) : super(id, type, issuedBy);

  factory Over18.fromJson(Map<String, dynamic> json) => _$Over18FromJson(json);

  @override
  final String id;
  @override
  final String type;
  @override
  final Author issuedBy;

  @override
  Map<String, dynamic> toJson() => _$Over18ToJson(this);

  @override
  Widget displayInList(BuildContext context, CredentialModel item) {
    return const CredentialContainer(child: Over18Recto());
  }

  @override
  Widget displayInSelectionList(BuildContext context, CredentialModel item) {
    return const CredentialContainer(child: Over18Recto());
  }

  @override
  Widget displayDetail(BuildContext context, CredentialModel item) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 584 / 317,
          child: SizedBox(
            height: 317,
            width: 584,
            child: CardAnimation(
              recto: const Over18Recto(),
              verso: Over18Verso(item),
            ),
          ),
        ),
      ],
    );
  }
}

class Over18Verso extends Verso {
  const Over18Verso(this.item, {Key? key}) : super(key: key);
  final CredentialModel item;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final expirationDate = item.expirationDate;
    final issuerName = item.credentialPreview.credentialSubject.issuedBy.name;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          fit: BoxFit.fitWidth,
          image: AssetImage(ImageStrings.over18Front),
        ),
      ),
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
      ),
    );
  }
}

class Over18Recto extends Recto {
  const Over18Recto({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          fit: BoxFit.fitWidth,
          image: AssetImage(ImageStrings.over18Back),
        ),
      ),
      child: const AspectRatio(
        /// size from over18 recto picture
        aspectRatio: 584 / 317,
        child: SizedBox(
          height: 317,
          width: 584,
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
