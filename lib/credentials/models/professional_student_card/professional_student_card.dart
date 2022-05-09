// ignore_for_file: overridden_fields

import 'package:altme/app/app.dart';
import 'package:altme/credentials/models/author/author.dart';
import 'package:altme/credentials/models/credential_model/credential_model.dart';
import 'package:altme/credentials/models/credential_subject/credential_subject.dart';
import 'package:altme/credentials/models/professional_student_card/professional_student_card_recipient.dart';
import 'package:altme/credentials/widgets/card_animation.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'professional_student_card.g.dart';

@JsonSerializable(explicitToJson: true)
class ProfessionalStudentCard extends CredentialSubject {
  ProfessionalStudentCard(
    this.recipient,
    this.expires,
    this.issuedBy,
    this.id,
    this.type,
  ) : super(id, type, issuedBy);

  factory ProfessionalStudentCard.fromJson(Map<String, dynamic> json) =>
      _$ProfessionalStudentCardFromJson(json);

  final ProfessionalStudentCardRecipient recipient;

  @JsonKey(defaultValue: '')
  final String expires;
  @override
  final Author issuedBy;
  @override
  final String id;
  @override
  final String type;

  @override
  Map<String, dynamic> toJson() => _$ProfessionalStudentCardToJson(this);

  @override
  Widget displayDetail(BuildContext context, CredentialModel item) {
    return Column(
      children: [
        AspectRatio(
          /// this size comes from law publication about job student card specs
          aspectRatio: 508.67 / 319.67,
          child: SizedBox(
            height: 319.67,
            width: 508.67,
            child: CardAnimation(
              recto:
                  JobStudentCardRecto(recipient: recipient, expires: expires),
              verso: const JobStudentCardVerso(),
            ),
          ),
        ),
      ],
    );
  }
}

class JobStudentCardRecto extends Recto {
  const JobStudentCardRecto({
    Key? key,
    required this.recipient,
    required this.expires,
  }) : super(key: key);

  final ProfessionalStudentCardRecipient recipient;
  final String expires;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fitWidth,
          image: AssetImage(ImageStrings.professionalStudentCardFront),
        ),
      ),
      child: AspectRatio(
        /// this size comes from law publication about job student card specs
        aspectRatio: 508.67 / 319.67,
        child: SizedBox(
          height: 319.67,
          width: 508.67,
          child: CustomMultiChildLayout(
            delegate: ProfessionalStudentCardDelegate(position: Offset.zero),
            children: [
              LayoutId(
                id: 'familyName',
                child: ImageCardText(text: recipient.familyName),
              ),
              LayoutId(
                id: 'givenName',
                child: ImageCardText(text: recipient.givenName),
              ),
              LayoutId(
                id: 'birthDate',
                child: ImageCardText(
                  text: UiDate.displayDate(
                    l10n,
                    recipient.birthDate,
                  ),
                ),
              ),
              LayoutId(
                id: 'expires',
                child: ImageCardText(
                  text: UiDate.displayDate(l10n, expires),
                ),
              ),
              LayoutId(
                id: 'signature',
                child: const ImageCardText(text: 'missing field'),
              ),
              LayoutId(
                id: 'image',
                child: ImageFromNetwork(recipient.image),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class JobStudentCardVerso extends Verso {
  const JobStudentCardVerso({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fitWidth,
          image: AssetImage(ImageStrings.professionalStudentCardBack),
        ),
      ),
      child: const AspectRatio(
        /// this size comes from law publication about job student card specs
        aspectRatio: 508.67 / 319.67,
        child: SizedBox(
          height: 319.67,
          width: 508.67,
        ),
      ),
    );
  }
}

class ProfessionalStudentCardDelegate extends MultiChildLayoutDelegate {
  ProfessionalStudentCardDelegate({this.position = Offset.zero});

  final Offset position;

  @override
  void performLayout(Size size) {
    if (hasChild('familyName')) {
      layoutChild('familyName', BoxConstraints.loose(size));
      positionChild(
        'familyName',
        Offset(size.width * 0.15, size.height * 0.29),
      );
    }
    if (hasChild('givenName')) {
      layoutChild('givenName', BoxConstraints.loose(size));
      positionChild('givenName', Offset(size.width * 0.19, size.height * 0.38));
    }

    if (hasChild('birthDate')) {
      layoutChild('birthDate', BoxConstraints.loose(size));
      positionChild('birthDate', Offset(size.width * 0.19, size.height * 0.47));
    }

    if (hasChild('expires')) {
      layoutChild('expires', BoxConstraints.loose(size));
      positionChild('expires', Offset(size.width * 0.22, size.height * 0.56));
    }

    if (hasChild('signature')) {
      layoutChild('signature', BoxConstraints.loose(size));
      positionChild('signature', Offset(size.width * 0.11, size.height * 0.75));
    }

    if (hasChild('image')) {
      layoutChild(
        'image',
        BoxConstraints.tightFor(
          width: size.width * 0.28,
          height: size.height * 0.59,
        ),
      );
      positionChild('image', Offset(size.width * 0.68, size.height * 0.06));
    }
  }

  @override
  bool shouldRelayout(ProfessionalStudentCardDelegate oldDelegate) {
    return oldDelegate.position != position;
  }
}
