import 'package:altme/app/shared/widget/base/credential_field.dart';
import 'package:altme/credentials/credential.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'self_issued.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class SelfIssued extends CredentialSubject {
  SelfIssued({
    required this.id,
    this.address,
    this.familyName,
    this.givenName,
    this.type = 'SelfIssued',
    this.telephone,
    this.email,
    this.workFor,
    this.companyWebsite,
    this.jobTitle,
  }) : super(id, type, const Author('', ''));

  factory SelfIssued.fromJson(Map<String, dynamic> json) =>
      _$SelfIssuedFromJson(json);

  @override
  final String id;
  @override
  final String type;
  final String? address;
  final String? familyName;
  final String? givenName;
  final String? telephone;
  final String? email;
  final String? workFor;
  final String? companyWebsite;
  final String? jobTitle;

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        if (givenName != null && givenName!.isNotEmpty) 'givenName': givenName,
        if (familyName != null && familyName!.isNotEmpty)
          'familyName': familyName,
        if (telephone != null && telephone!.isNotEmpty) 'telephone': telephone,
        if (address != null && address!.isNotEmpty) 'address': address,
        'type': type,
        if (email != null && email!.isNotEmpty) 'email': email,
        if (workFor != null && workFor!.isNotEmpty) 'workFor': workFor,
        if (companyWebsite != null && companyWebsite!.isNotEmpty)
          'companyWebsite': companyWebsite,
        if (jobTitle != null && jobTitle!.isNotEmpty) 'jobTitle': jobTitle,
      };

  @override
  Widget displayDetail(BuildContext context, CredentialModel item) {
    final localizations = context.l10n;
    return CredentialBackground(
      model: item,
      child: Column(
        children: [
          if (givenName?.isNotEmpty ?? false)
            CredentialField(title: localizations.firstName, value: givenName!)
          else
            const SizedBox.shrink(),
          if (familyName?.isNotEmpty ?? false)
            CredentialField(title: localizations.lastName, value: familyName!)
          else
            const SizedBox.shrink(),
          if (telephone?.isNotEmpty ?? false)
            CredentialField(
              title: localizations.personalPhone,
              value: telephone!,
            )
          else
            const SizedBox.shrink(),
          if (address?.isNotEmpty ?? false)
            CredentialField(title: localizations.address, value: address!)
          else
            const SizedBox.shrink(),
          if (email?.isNotEmpty ?? false)
            CredentialField(title: localizations.personalMail, value: email!)
          else
            const SizedBox.shrink(),
          if (workFor?.isNotEmpty ?? false)
            CredentialField(title: localizations.companyName, value: workFor!)
          else
            const SizedBox.shrink(),
          if (companyWebsite?.isNotEmpty ?? false)
            CredentialField(
              title: localizations.companyWebsite,
              value: companyWebsite!,
            )
          else
            const SizedBox.shrink(),
          if (jobTitle?.isNotEmpty ?? false)
            CredentialField(
              title: localizations.jobTitle,
              value: jobTitle!,
            )
          else
            const SizedBox.shrink(),
        ],
      ),
    );
  }
}
