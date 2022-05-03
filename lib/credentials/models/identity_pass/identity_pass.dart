// ignore_for_file: overridden_fields

import 'package:altme/app/shared/date/date.dart';
import 'package:altme/app/shared/widget/base/credential_field.dart';
import 'package:altme/app/shared/widget/image_from_network.dart';
import 'package:altme/credentials/credential.dart';
import 'package:altme/credentials/models/identity_pass/identity_pass_recipient.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'identity_pass.g.dart';

@JsonSerializable(explicitToJson: true)
class IdentityPass extends CredentialSubject {
  IdentityPass(this.recipient, this.expires, this.issuedBy, this.id, this.type)
      : super(id, type, issuedBy);

  factory IdentityPass.fromJson(Map<String, dynamic> json) =>
      _$IdentityPassFromJson(json);

  final IdentityPassRecipient recipient;
  @JsonKey(defaultValue: '')
  final String expires;
  @override
  final Author issuedBy;
  @override
  final String id;
  @override
  final String type;

  @override
  Map<String, dynamic> toJson() => _$IdentityPassToJson(this);

  @override
  Widget displayDetail(BuildContext context, CredentialModel item) {
    final l10n = context.l10n;
    return CredentialBackground(
      model: item,
      child: Column(
        children: [
          if (expires != '')
            CredentialField(
              title: l10n.expires,
              value: expires,
            )
          else
            const SizedBox.shrink(),
          if (recipient.jobTitle != '')
            CredentialField(
              title: l10n.jobTitle,
              value: recipient.jobTitle,
            )
          else
            const SizedBox.shrink(),
          if (recipient.familyName != '')
            CredentialField(
              title: l10n.firstName,
              value: recipient.familyName,
            )
          else
            const SizedBox.shrink(),
          if (recipient.givenName != '')
            CredentialField(
              title: l10n.lastName,
              value: recipient.givenName,
            )
          else
            const SizedBox.shrink(),
          if (recipient.image != '')
            Padding(
              padding: const EdgeInsets.all(8),
              child: ImageFromNetwork(recipient.image),
            )
          else
            const SizedBox.shrink(),
          if (recipient.address != '')
            CredentialField(title: l10n.address, value: recipient.address)
          else
            const SizedBox.shrink(),
          if (recipient.birthDate != '')
            CredentialField(
              title: l10n.birthdate,
              value: UiDate.displayDate(l10n, recipient.birthDate),
            )
          else
            const SizedBox.shrink(),
          if (recipient.email != '')
            CredentialField(title: l10n.personalMail, value: recipient.email)
          else
            const SizedBox.shrink(),
          if (recipient.gender != '')
            CredentialField(title: l10n.gender, value: recipient.gender)
          else
            const SizedBox.shrink(),
          if (recipient.telephone != '')
            CredentialField(
              title: l10n.personalPhone,
              value: recipient.telephone,
            )
          else
            const SizedBox.shrink(),
          Padding(
            padding: const EdgeInsets.all(8),
            child: DisplayIssuer(
              issuer: issuedBy,
            ),
          )
        ],
      ),
    );
  }
}
