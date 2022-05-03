// ignore_for_file: overridden_fields

import 'package:altme/app/shared/widget/base/credential_field.dart';
import 'package:altme/credentials/models/author/author.dart';
import 'package:altme/credentials/models/credential_model/credential_model.dart';
import 'package:altme/credentials/models/credential_subject/credential_subject.dart';
import 'package:altme/credentials/widgets/credential_background.dart';
import 'package:altme/credentials/widgets/display_issuer.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'phone_pass.g.dart';

@JsonSerializable(explicitToJson: true)
class PhonePass extends CredentialSubject {
  PhonePass(this.expires, this.phone, this.id, this.type, this.issuedBy)
      : super(id, type, issuedBy);

  factory PhonePass.fromJson(Map<String, dynamic> json) =>
      _$PhonePassFromJson(json);

  @JsonKey(defaultValue: '')
  final String expires;
  @JsonKey(defaultValue: '')
  final String phone;
  @override
  final String id;
  @override
  final String type;
  @override
  final Author issuedBy;

  @override
  Map<String, dynamic> toJson() => _$PhonePassToJson(this);

  @override
  Widget displayDetail(BuildContext context, CredentialModel item) {
    final l10n = context.l10n;

    return CredentialBackground(
      model: item,
      child: Column(
        children: [
          CredentialField(title: l10n.personalPhone, value: phone),
          Padding(
            padding: const EdgeInsets.all(8),
            child: DisplayIssuer(
              issuer: issuedBy,
            ),
          ),
        ],
      ),
    );
  }
}
