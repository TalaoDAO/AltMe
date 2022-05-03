// ignore_for_file: overridden_fields

import 'package:altme/app/shared/date/date.dart';
import 'package:altme/app/shared/widget/base/credential_field.dart';
import 'package:altme/credentials/models/author/author.dart';
import 'package:altme/credentials/models/credential_model/credential_model.dart';
import 'package:altme/credentials/models/credential_subject/credential_subject.dart';
import 'package:altme/credentials/widgets/credential_background.dart';
import 'package:altme/credentials/widgets/display_issuer.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/app_theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'resident_card.g.dart';

@JsonSerializable(explicitToJson: true)
class ResidentCard extends CredentialSubject {
  ResidentCard(
    this.id,
    this.gender,
    this.maritalStatus,
    this.type,
    this.birthPlace,
    this.nationality,
    this.address,
    this.identifier,
    this.familyName,
    this.image,
    this.issuedBy,
    this.birthDate,
    this.givenName,
  ) : super(id, type, issuedBy);

  factory ResidentCard.fromJson(Map<String, dynamic> json) =>
      _$ResidentCardFromJson(json);

  @override
  final String id;
  @JsonKey(defaultValue: '')
  final String gender;
  @JsonKey(defaultValue: '')
  final String maritalStatus;
  @override
  final String type;
  @JsonKey(defaultValue: '')
  final String birthPlace;
  @JsonKey(defaultValue: '')
  final String nationality;
  @JsonKey(defaultValue: '')
  final String address;
  @JsonKey(defaultValue: '')
  final String identifier;
  @JsonKey(defaultValue: '')
  final String familyName;
  @JsonKey(defaultValue: '')
  final String image;
  @override
  final Author issuedBy;
  @JsonKey(defaultValue: '')
  final String birthDate;
  @JsonKey(defaultValue: '')
  final String givenName;

  @override
  Map<String, dynamic> toJson() => _$ResidentCardToJson(this);

  @override
  Widget displayDetail(BuildContext context, CredentialModel item) {
    final l10n = context.l10n;

    return CredentialBackground(
      model: item,
      child: Column(
        children: [
          DisplayIssuer(issuer: issuedBy),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CredentialField(title: l10n.lastName, value: familyName),
              CredentialField(title: l10n.firstName, value: givenName),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Text(
                      '${l10n.gender}: ',
                      style: Theme.of(context).textTheme.credentialFieldTitle,
                    ),
                    Flexible(
                      child: genderDisplay(context),
                    ),
                  ],
                ),
              ),
              CredentialField(
                title: l10n.birthdate,
                value: UiDate.displayDate(
                  l10n,
                  birthDate,
                ),
              ),
              CredentialField(title: l10n.birthplace, value: birthPlace),
              CredentialField(title: l10n.address, value: address),
              CredentialField(title: l10n.maritalStatus, value: maritalStatus),
              CredentialField(title: l10n.identifier, value: identifier),
              CredentialField(title: l10n.nationality, value: nationality),
            ],
          ),
        ],
      ),
    );
  }

  Widget genderDisplay(BuildContext context) {
    Widget _genderIcon;
    switch (gender) {
      case 'male':
        _genderIcon =
            Icon(Icons.male, color: Theme.of(context).colorScheme.genderIcon);
        break;
      case 'female':
        _genderIcon =
            Icon(Icons.female, color: Theme.of(context).colorScheme.genderIcon);
        break;
      default:
        _genderIcon = Icon(
          Icons.transgender,
          color: Theme.of(context).colorScheme.genderIcon,
        );
    }
    return _genderIcon;
  }
}
