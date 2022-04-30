import 'package:altme/app/app.dart';
import 'package:altme/credentials/credential.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:url_launcher/url_launcher.dart';


part 'credential_subject.g.dart';

@JsonSerializable(explicitToJson: true)
class CredentialSubject {
  CredentialSubject(this.id, this.type, this.issuedBy);

  factory CredentialSubject.fromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      // case 'ResidentCard':
      //   return ResidentCard.fromJson(json);
      // case 'SelfIssued':
      //   return SelfIssued.fromJson(json);
      // case 'IdentityPass':
      //   return IdentityPass.fromJson(json);
      // case 'Voucher':
      //   return Voucher.fromJson(json);
      // case 'Ecole42LearningAchievement':
      //   return Ecole42LearningAchievement.fromJson(json);
      // case 'LoyaltyCard':
      //   return LoyaltyCard.fromJson(json);
      // case 'Over18':
      //   return Over18.fromJson(json);
      // case 'ProfessionalStudentCard':
      //   return ProfessionalStudentCard.fromJson(json);
      // case 'StudentCard':
      //   return StudentCard.fromJson(json);
      case 'CertificateOfEmployment':
        return CertificateOfEmployment.fromJson(json);
      // case 'EmailPass':
      //   return EmailPass.fromJson(json);
      // case 'PhonePass':
      //   return PhonePass.fromJson(json);
      // case 'ProfessionalExperienceAssessment':
      //   return ProfessionalExperienceAssessment.fromJson(json);
      // case 'ProfessionalSkillAssessment':
      //   return ProfessionalSkillAssessment.fromJson(json);
      // case 'LearningAchievement':
      //   return LearningAchievement.fromJson(json);
    }
    return DefaultCredentialSubject.fromJson(json);
  }

  final String id;
  final String type;
  @JsonKey(fromJson: fromJsonAuthor)
  final Author issuedBy;

  Color get backgroundColor {
    Color _backgroundColor;
    switch (type) {
      case 'ResidentCard':
        _backgroundColor = Colors.white;
        break;
      case 'SelfIssued':
        _backgroundColor = const Color(0xffEFF0F6);
        break;
      case 'IdentityPass':
        _backgroundColor = const Color(0xffCAFFBF);
        break;
      case 'Voucher':
        _backgroundColor = const Color(0xffCAFFBF);
        break;
      case 'LoyaltyCard':
        _backgroundColor = const Color(0xffCAFFBF);
        break;
      case 'Over18':
        _backgroundColor = const Color(0xffCAFFBF);
        break;
      case 'ProfessionalStudentCard':
        _backgroundColor = const Color(0xffCAFFBF);
        break;
      case 'CertificateOfEmployment':
        _backgroundColor = const Color(0xFF9BF6FF);
        break;
      case 'EmailPass':
        _backgroundColor = const Color(0xFFffD6A5);
        break;
      case 'PhonePass':
        _backgroundColor = const Color(0xFFffD6A5);
        break;
      case 'ProfessionalExperienceAssessment':
        _backgroundColor = const Color(0xFFFFADAD);
        break;
      case 'ProfessionalSkillAssessment':
        _backgroundColor = const Color(0xffCAFFBF);
        break;
      case 'LearningAchievement':
        _backgroundColor = const Color(0xFFFFADAD);
        break;
      default:
        _backgroundColor = Colors.black;
    }
    return _backgroundColor;
  }

  Icon get icon {
    Icon _icon;
    switch (type) {
      case 'ResidentCard':
        _icon = const Icon(Icons.home);
        break;
      case 'IdentityPass':
        _icon = const Icon(Icons.perm_identity);
        break;
      case 'Voucher':
        _icon = const Icon(Icons.gamepad);
        break;
      case 'LoyaltyCard':
        _icon = const Icon(Icons.loyalty);
        break;
      case 'Over18':
        _icon = const Icon(Icons.accessible_rounded);
        break;
      case 'ProfessionalStudentCard':
        _icon = const Icon(Icons.perm_identity);
        break;
      case 'CertificateOfEmployment':
        _icon = const Icon(Icons.work);
        break;
      case 'EmailPass':
        _icon = const Icon(Icons.mail);
        break;
      case 'PhonePass':
        _icon = const Icon(Icons.phone);
        break;
      case 'ProfessionalExperienceAssessment':
        _icon = const Icon(Icons.add_road_outlined);
        break;
      case 'ProfessionalSkillAssessment':
        _icon = const Icon(Icons.assessment_outlined);
        break;
      case 'LearningAchievement':
        _icon = const Icon(Icons.star_rate_outlined);
        break;
      default:
        _icon = const Icon(Icons.fact_check_outlined);
    }
    return _icon;
  }

  Widget displayInList(BuildContext context, CredentialModel item) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: displayName(context, item),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: SizedBox(height: 48, child: displayDescription(context, item)),
        ),
        DisplayIssuer(issuer: item.credentialPreview.credentialSubject.issuedBy)
      ],
    );
  }

  Widget displayInSelectionList(BuildContext context, CredentialModel item) {
    return CredentialContainer(
      child: Container(
        // margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BaseBoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: item.backgroundColor,
          shapeColor: Theme.of(context).colorScheme.documentShape,
          value: 1,
          anchors: const <Alignment>[
            Alignment.bottomRight,
          ],
        ),
        child: Material(
          color: Theme.of(context).colorScheme.transparent,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: displayName(context, item),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: SizedBox(
                    height: 48,
                    child: displayDescription(context, item),
                  ),
                ),
                DisplayIssuer(
                  issuer: item.credentialPreview.credentialSubject.issuedBy,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget displayDetail(BuildContext context, CredentialModel item) {
    final l10n = context.l10n;
    final _issuanceDate = item.credentialPreview.issuanceDate;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: displayName(context, item),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: displayDescription(context, item),
        ),
        item.credentialPreview.credentialSubject.displayDetail(context, item),
        if (item.credentialPreview.credentialSubject is CertificateOfEmployment)
          CredentialField(
            title: l10n.issuanceDate,
            value: UiDate.displayDate(l10n, _issuanceDate),
          )
        else
          const SizedBox.shrink(),
        if (item.credentialPreview.evidence.first.id != '')
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Text(
                  '${l10n.evidenceLabel}: ',
                  style: Theme.of(context).textTheme.credentialFieldTitle,
                ),
                Flexible(
                  child: InkWell(
                    onTap: () =>
                        _launchURL(item.credentialPreview.evidence.first.id),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Text(
                            item.credentialPreview.evidence.first.id,
                            style: Theme.of(context)
                                .textTheme
                                .credentialFieldDescription,
                            maxLines: 5,
                            overflow: TextOverflow.fade,
                            softWrap: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          const SizedBox.shrink()
      ],
    );
  }

  Map<String, dynamic> toJson() => _$CredentialSubjectToJson(this);

  static Author fromJsonAuthor(dynamic json) {
    if (json == null || json == '') {
      return const Author('', '');
    }
    return Author.fromJson(json as Map<String, dynamic>);
  }

  String getName(BuildContext context, CredentialModel item) {
    final l10n = context.l10n;

    var _nameValue =
        GetTranslation.getTranslation(item.credentialPreview.name, l10n);
    if (_nameValue == '') {
      _nameValue = item.display.nameFallback;
    }
    if (_nameValue == '') {
      _nameValue = item.credentialPreview.type.last;
    }

    return _nameValue;
  }

  String getDescription(BuildContext context, CredentialModel item) {
    final l10n = context.l10n;

    var _nameValue =
        GetTranslation.getTranslation(item.credentialPreview.description, l10n);
    if (_nameValue == '') {
      _nameValue = item.display.descriptionFallback;
    }

    return _nameValue;
  }

  Widget displayName(BuildContext context, CredentialModel item) {
    final nameValue = getName(context, item);
    return Text(
      nameValue,
      maxLines: 1,
      overflow: TextOverflow.clip,
      style: Theme.of(context).textTheme.credentialTitle,
    );
  }

  Widget displayDescription(BuildContext context, CredentialModel item) {
    final nameValue = getDescription(context, item);
    return Text(
      nameValue,
      overflow: TextOverflow.fade,
      style: Theme.of(context).textTheme.credentialDescription,
    );
  }

  Future<void> _launchURL(String _url) async =>
      await canLaunchUrl(Uri.parse(_url))
          ? await launchUrl(Uri.parse(_url))
          : throw Exception('Could not launch $_url');
}
