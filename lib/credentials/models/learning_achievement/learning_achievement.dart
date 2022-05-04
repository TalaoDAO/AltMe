// ignore_for_file: overridden_fields

import 'package:altme/app/app.dart';
import 'package:altme/app/shared/date/date.dart';
import 'package:altme/app/shared/widget/image_card_text.dart';
import 'package:altme/credentials/credential.dart';
import 'package:altme/credentials/models/learning_achievement/has_credential.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:url_launcher/url_launcher.dart';

part 'learning_achievement.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class LearningAchievement extends CredentialSubject {
  LearningAchievement(
    this.id,
    this.type,
    this.familyName,
    this.givenName,
    this.email,
    this.birthDate,
    this.hasCredential,
    this.issuedBy,
  ) : super(id, type, issuedBy);

  factory LearningAchievement.fromJson(Map<String, dynamic> json) =>
      _$LearningAchievementFromJson(json);

  @override
  String id;
  @override
  String type;
  @JsonKey(defaultValue: '')
  String familyName;
  @JsonKey(defaultValue: '')
  String givenName;
  @JsonKey(defaultValue: '')
  String email;
  @JsonKey(defaultValue: '')
  String birthDate;
  HasCredential hasCredential;
  @override
  final Author issuedBy;

  @override
  Map<String, dynamic> toJson() => _$LearningAchievementToJson(this);

  @override
  Widget displayInList(BuildContext context, CredentialModel item) {
    return CredentialContainer(child: LearningAchievementRecto(item));
  }

  @override
  Widget displayInSelectionList(BuildContext context, CredentialModel item) {
    return CredentialContainer(child: LearningAchievementRecto(item));
  }

  @override
  Widget displayDetail(BuildContext context, CredentialModel item) {
    return Column(
      children: [
        AspectRatio(
          /// this size comes from law publication about job student card specs
          aspectRatio: 572 / 315,
          child: SizedBox(
            height: 315,
            width: 572,
            child: CardAnimation(
              recto: LearningAchievementRecto(item),
              verso: LearningAchievementVerso(
                item: item,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class LearningAchievementRecto extends Recto {
  const LearningAchievementRecto(this.item, {Key? key}) : super(key: key);
  final CredentialModel item;

  @override
  Widget build(BuildContext context) {
    return CredentialContainer(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fitWidth,
            image: AssetImage(ImageStrings.learningAchievementFront),
          ),
        ),
        child: AspectRatio(
          /// size from over18 recto picture
          aspectRatio: 572 / 315,
          child: SizedBox(
            height: 315,
            width: 572,
            child: CustomMultiChildLayout(
              delegate: LearningAchievementVersoDelegate(position: Offset.zero),
              children: [
                LayoutId(
                  id: 'school',
                  child: Text(
                    item.credentialPreview.credentialSubject.issuedBy.name,
                    overflow: TextOverflow.fade,
                    style: Theme.of(context).textTheme.studentCardSchool,
                  ),
                ),
                LayoutId(
                  id: 'name',
                  child: DisplayNameCard(
                    item,
                    Theme.of(context).textTheme.credentialTitleCard,
                  ),
                ),
                LayoutId(
                  id: 'description',
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: 250 * MediaQuery.of(context).size.aspectRatio,
                    ),
                    child: DisplayDescriptionCard(
                      item,
                      Theme.of(context).textTheme.credentialStudentCardTextCard,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LearningAchievementVerso extends Verso {
  const LearningAchievementVerso({Key? key, required this.item})
      : super(key: key);

  final CredentialModel item;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final credentialSubject =
        item.credentialPreview.credentialSubject as LearningAchievement;

    return CredentialContainer(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fitWidth,
            image: AssetImage(ImageStrings.learningAchievementBack),
          ),
        ),
        child: AspectRatio(
          /// this size comes from law publication about job student card specs
          aspectRatio: 572 / 315,
          child: SizedBox(
            height: 315,
            width: 572,
            child: CustomMultiChildLayout(
              delegate: LearningAchievementDelegate(position: Offset.zero),
              children: [
                LayoutId(
                  id: 'name',
                  child: DisplayNameCard(
                    item,
                    Theme.of(context).textTheme.credentialTitleCard,
                  ),
                ),
                LayoutId(
                  id: 'school',
                  child: Text(
                    item.credentialPreview.credentialSubject.issuedBy.name,
                    overflow: TextOverflow.fade,
                    style: Theme.of(context).textTheme.studentCardSchool,
                  ),
                ),
                LayoutId(
                  id: 'familyName',
                  child: Row(
                    children: [
                      ImageCardText(
                        text: '${l10n.personalLastName}: ',
                        textStyle: Theme.of(context)
                            .textTheme
                            .studentCardData
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      ImageCardText(
                        text: credentialSubject.familyName,
                        textStyle: Theme.of(context).textTheme.studentCardData,
                      ),
                    ],
                  ),
                ),
                LayoutId(
                  id: 'givenName',
                  child: Row(
                    children: [
                      ImageCardText(
                        text: '${l10n.personalFirstName}: ',
                        textStyle: Theme.of(context)
                            .textTheme
                            .studentCardData
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      ImageCardText(
                        text: credentialSubject.givenName,
                        textStyle: Theme.of(context).textTheme.studentCardData,
                      ),
                    ],
                  ),
                ),
                LayoutId(
                  id: 'birthDate',
                  child: Row(
                    children: [
                      ImageCardText(
                        text: '${l10n.birthdate}: ',
                        textStyle: Theme.of(context)
                            .textTheme
                            .studentCardData
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      ImageCardText(
                        text: UiDate.displayDate(
                          l10n,
                          credentialSubject.birthDate,
                        ),
                        textStyle: Theme.of(context).textTheme.studentCardData,
                      ),
                    ],
                  ),
                ),
                LayoutId(
                  id: 'hasCredential',
                  child: Row(
                    children: [
                      ImageCardText(
                        text: '${credentialSubject.hasCredential.title}: ',
                        textStyle: Theme.of(context)
                            .textTheme
                            .studentCardData
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      ImageCardText(
                        text: credentialSubject.hasCredential.description,
                        textStyle: Theme.of(context).textTheme.studentCardData,
                      ),
                    ],
                  ),
                ),
                LayoutId(
                  id: 'proof',
                  child: Row(
                    children: [
                      ImageCardText(
                        text: '${l10n.proof}: ',
                        textStyle: Theme.of(context)
                            .textTheme
                            .studentCardData
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      InkWell(
                        onTap: () => _launchURL(
                          item.credentialPreview.evidence.first.id,
                        ),
                        child: ImageCardText(
                          text: item.credentialPreview.evidence.first.id,
                          textStyle:
                              Theme.of(context).textTheme.studentCardData,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchURL(String _url) async =>
      await canLaunchUrl(Uri.parse(_url))
          ? await launchUrl(Uri.parse(_url))
          : throw Exception('Could not launch $_url');
}

class LearningAchievementDelegate extends MultiChildLayoutDelegate {
  LearningAchievementDelegate({this.position = Offset.zero});

  final Offset position;

  @override
  void performLayout(Size size) {
    if (hasChild('name')) {
      layoutChild('name', BoxConstraints.loose(size));
      positionChild('name', Offset(size.width * 0.06, size.height * 0.16));
    }
    if (hasChild('school')) {
      layoutChild('school', BoxConstraints.loose(size));
      positionChild('school', Offset(size.width * 0.06, size.height * 0.33));
    }

    if (hasChild('familyName')) {
      layoutChild('familyName', BoxConstraints.loose(size));
      positionChild(
        'familyName',
        Offset(size.width * 0.06, size.height * 0.63),
      );
    }
    if (hasChild('givenName')) {
      layoutChild('givenName', BoxConstraints.loose(size));
      positionChild('givenName', Offset(size.width * 0.06, size.height * 0.53));
    }

    if (hasChild('birthDate')) {
      layoutChild('birthDate', BoxConstraints.loose(size));
      positionChild('birthDate', Offset(size.width * 0.45, size.height * 0.53));
    }

    if (hasChild('hasCredential')) {
      layoutChild('hasCredential', BoxConstraints.loose(size));
      positionChild(
        'hasCredential',
        Offset(size.width * 0.45, size.height * 0.63),
      );
    }

    if (hasChild('proof')) {
      layoutChild('proof', BoxConstraints.loose(size));
      positionChild('proof', Offset(size.width * 0.06, size.height * 0.8));
    }
  }

  @override
  bool shouldRelayout(LearningAchievementDelegate oldDelegate) {
    return oldDelegate.position != position;
  }
}

class LearningAchievementVersoDelegate extends MultiChildLayoutDelegate {
  LearningAchievementVersoDelegate({this.position = Offset.zero});

  final Offset position;

  @override
  void performLayout(Size size) {
    if (hasChild('name')) {
      layoutChild('name', BoxConstraints.loose(size));
      positionChild('name', Offset(size.width * 0.06, size.height * 0.16));
    }
    if (hasChild('school')) {
      layoutChild('school', BoxConstraints.loose(size));
      positionChild('school', Offset(size.width * 0.06, size.height * 0.33));
    }
    if (hasChild('description')) {
      layoutChild('description', BoxConstraints.loose(size));
      positionChild(
        'description',
        Offset(size.width * 0.06, size.height * 0.49),
      );
    }
  }

  @override
  bool shouldRelayout(LearningAchievementVersoDelegate oldDelegate) {
    return oldDelegate.position != position;
  }
}
