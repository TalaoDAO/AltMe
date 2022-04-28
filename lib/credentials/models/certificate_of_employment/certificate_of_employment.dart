import 'package:altme/app/app.dart';
import 'package:altme/credentials/models/author/author.dart';
import 'package:altme/credentials/models/certificate_of_employment/work_for.dart';
import 'package:altme/credentials/models/credential_model/credential_model.dart';
import 'package:altme/credentials/models/credential_subject/credential_subject.dart';
import 'package:altme/credentials/widgets/display_issuer.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'certificate_of_employment.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
//ignore: must_be_immutable
class CertificateOfEmployment extends CredentialSubject {
  CertificateOfEmployment(
    this.id,
    this.type,
    this.familyName,
    this.givenName,
    this.startDate,
    this.workFor,
    this.employmentType,
    this.jobTitle,
    this.baseSalary,
    this.issuedBy,
  ) : super(id, type, issuedBy);

  factory CertificateOfEmployment.fromJson(Map<String, dynamic> json) =>
      _$CertificateOfEmploymentFromJson(json);

  @override
  String id;
  @override
  String type;
  @JsonKey(defaultValue: '')
  String familyName;
  @JsonKey(defaultValue: '')
  String givenName;
  @JsonKey(defaultValue: '')
  String startDate;
  WorkFor workFor;
  @JsonKey(defaultValue: '')
  String employmentType;
  @JsonKey(defaultValue: '')
  String jobTitle;
  @JsonKey(defaultValue: '')
  String baseSalary;
  @override
  final Author issuedBy;

  @override
  Map<String, dynamic> toJson() => _$CertificateOfEmploymentToJson(this);

  @override
  Widget displayDetail(BuildContext context, CredentialModel item) {
    final l10n = context.l10n;

    return Column(
      children: [
        CredentialField(title: l10n.firstName, value: familyName),
        CredentialField(title: l10n.lastName, value: givenName),
        CredentialField(title: l10n.jobTitle, value: jobTitle),
        if (workFor.name != '')
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Text(
                  '${l10n.workFor}: ',
                  style: Theme.of(context).textTheme.credentialFieldTitle,
                ),
                Text(
                  workFor.name,
                  style: Theme.of(context).textTheme.credentialFieldDescription,
                ),
                const Spacer(),
                if (workFor.logo != '')
                  SizedBox(height: 30, child: ImageFromNetwork(workFor.logo))
                else
                  const SizedBox.shrink()
              ],
            ),
          )
        else
          const SizedBox.shrink(),
        CredentialField(
          title: l10n.startDate,
          value: UiDate.displayDate(l10n, startDate),
        ),
        CredentialField(title: l10n.employmentType, value: employmentType),
        CredentialField(title: l10n.baseSalary, value: baseSalary),
        Padding(
          padding: const EdgeInsets.all(8),
          child: DisplayIssuer(
            issuer: issuedBy,
          ),
        )
      ],
    );
  }
}
