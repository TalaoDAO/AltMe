// ignore_for_file: overridden_fields

import 'package:altme/app/shared/shared.dart';
import 'package:altme/credentials/credential.dart';
import 'package:altme/credentials/models/ecole_42_learning_achievement/has_credential_ecole_42.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:url_launcher/url_launcher.dart';

part 'ecole_42_learning_achievement.g.dart';

@JsonSerializable(explicitToJson: true)
class Ecole42LearningAchievement extends CredentialSubject {
  Ecole42LearningAchievement(
    this.id,
    this.type,
    this.issuedBy,
    this.givenName,
    this.signatureLines,
    this.birthDate,
    this.familyName,
    this.hasCredential,
  ) : super(id, type, issuedBy);

  factory Ecole42LearningAchievement.fromJson(Map<String, dynamic> json) =>
      _$Ecole42LearningAchievementFromJson(json);

  @override
  final String id;
  @override
  final String type;
  @JsonKey(defaultValue: '')
  final String givenName;
  @JsonKey(fromJson: _signatureLinesFromJson)
  final Signature signatureLines;
  @JsonKey(defaultValue: '')
  final String birthDate;

  @JsonKey(fromJson: _hasCreddentialEcole42FromJson)
  HasCredentialEcole42 hasCredential;
  @JsonKey(defaultValue: '')
  final String familyName;
  @override
  final Author issuedBy;

  @override
  Map<String, dynamic> toJson() => _$Ecole42LearningAchievementToJson(this);

  @override
  Widget displayDetail(BuildContext context, CredentialModel item) {
    const _height = 1753.0;
    const _width = 1240.0;
    const _aspectRatio = _width / _height;
    final l10n = context.l10n;
    final studentIdentity = '$givenName $familyName, born ${UiDate.displayDate(
      l10n,
      birthDate,
    )}';
    final evidenceText =
        '${item.credentialPreview.evidence.first.id.substring(0, 30)}...';
    return Column(
      children: [
        AspectRatio(
          /// this size comes from law publication about job student card specs
          aspectRatio: _aspectRatio,
          child: SizedBox(
            height: _height,
            width: _width,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                  fit: BoxFit.fitWidth,
                  image: AssetImage(ImageStrings.ecole42LearningAchievement),
                ),
              ),
              child: AspectRatio(
                /// random size, copy from professional student card
                aspectRatio: _aspectRatio,
                child: SizedBox(
                  height: _height,
                  width: _width,
                  child: CustomMultiChildLayout(
                    delegate: Ecole42LearningAchievementDelegate(
                      position: Offset.zero,
                    ),
                    children: [
                      LayoutId(
                        id: 'studentIdentity',
                        child: Row(
                          children: [
                            ImageCardText(
                              text: studentIdentity,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .ecole42LearningAchievementStudentIdentity,
                            ),
                          ],
                        ),
                      ),
                      LayoutId(
                        id: 'level',
                        child: Row(
                          children: [
                            ImageCardText(
                              text: 'Level ${hasCredential.level}',
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .ecole42LearningAchievementLevel,
                            ),
                          ],
                        ),
                      ),
                      LayoutId(
                        id: 'signature',
                        child: item.image != ''
                            ? Padding(
                                padding: const EdgeInsets.all(8),
                                child: SizedBox(
                                  height: 80 *
                                      MediaQuery.of(context).size.aspectRatio,
                                  child: ImageFromNetwork(
                                    signatureLines.image,
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        if (item.credentialPreview.evidence.first.id != '')
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Text(
                  '${l10n.evidenceLabel}: ',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                const SizedBox(width: 5),
                Flexible(
                  child: InkWell(
                    onTap: () =>
                        _launchURL(item.credentialPreview.evidence.first.id),
                    child: Text(
                      evidenceText,
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            color: Theme.of(context).colorScheme.markDownA,
                            decoration: TextDecoration.underline,
                          ),
                      maxLines: 5,
                      overflow: TextOverflow.fade,
                      softWrap: true,
                    ),
                  ),
                ),
              ],
            ),
          )
      ],
    );
  }

  Future<void> _launchURL(String _url) async =>
      await canLaunchUrl(Uri.parse(_url))
          ? await launchUrl(Uri.parse(_url))
          : throw Exception('Could not launch $_url');

  static Signature _signatureLinesFromJson(dynamic json) {
    if (json == null || json == '') {
      return Signature.emptySignature();
    }
    return Signature.fromJson(json as Map<String, dynamic>);
  }

  static HasCredentialEcole42 _hasCreddentialEcole42FromJson(dynamic json) {
    if (json == null || json == '') {
      return HasCredentialEcole42.emptyCredential();
    }
    return HasCredentialEcole42.fromJson(json as Map<String, dynamic>);
  }
}

class Ecole42LearningAchievementDelegate extends MultiChildLayoutDelegate {
  Ecole42LearningAchievementDelegate({this.position = Offset.zero});

  final Offset position;

  @override
  void performLayout(Size size) {
    if (hasChild('studentIdentity')) {
      layoutChild('studentIdentity', BoxConstraints.loose(size));
      positionChild(
        'studentIdentity',
        Offset(size.width * 0.17, size.height * 0.33),
      );
    }
    if (hasChild('signature')) {
      layoutChild('signature', BoxConstraints.loose(size));
      positionChild('signature', Offset(size.width * 0.5, size.height * 0.55));
    }
    if (hasChild('level')) {
      layoutChild('level', BoxConstraints.loose(size));
      positionChild('level', Offset(size.width * 0.605, size.height * 0.3685));
    }
  }

  @override
  bool shouldRelayout(
    covariant Ecole42LearningAchievementDelegate oldDelegate,
  ) {
    return oldDelegate.position != position;
  }
}
