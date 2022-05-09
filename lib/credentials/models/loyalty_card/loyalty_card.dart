// ignore_for_file: overridden_fields

import 'package:altme/app/app.dart';
import 'package:altme/credentials/models/author/author.dart';
import 'package:altme/credentials/models/credential_model/credential_model.dart';
import 'package:altme/credentials/models/credential_subject/credential_subject.dart';
import 'package:altme/credentials/widgets/card_animation.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/app_theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'loyalty_card.g.dart';

@JsonSerializable(explicitToJson: true)
class LoyaltyCard extends CredentialSubject {
  LoyaltyCard(
    this.id,
    this.type,
    this.address,
    this.familyName,
    this.issuedBy,
    this.birthDate,
    this.givenName,
    this.programName,
    this.telephone,
    this.email,
  ) : super(id, type, issuedBy);

  factory LoyaltyCard.fromJson(Map<String, dynamic> json) =>
      _$LoyaltyCardFromJson(json);

  @override
  final String id;
  @override
  final String type;
  @JsonKey(defaultValue: '')
  final String address;
  @JsonKey(defaultValue: '')
  final String familyName;
  @override
  final Author issuedBy;
  @JsonKey(defaultValue: '')
  final String birthDate;
  @JsonKey(defaultValue: '')
  final String givenName;
  @JsonKey(defaultValue: '')
  final String programName;
  @JsonKey(defaultValue: '')
  final String telephone;
  @JsonKey(defaultValue: '')
  final String email;

  @override
  Map<String, dynamic> toJson() => _$LoyaltyCardToJson(this);

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
              recto: const LoyaltyCardRecto(),
              verso: LoyaltyCardVerso(this),
            ),
          ),
        ),
      ],
    );
  }
}

class LoyaltyCardRecto extends Recto {
  const LoyaltyCardRecto({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          fit: BoxFit.fitWidth,
          image: AssetImage(ImageStrings.loyaltyCard),
        ),
      ),
      child: const AspectRatio(
        /// random size, copy from professional student card
        aspectRatio: 508.67 / 319.67,
        child: SizedBox(
          height: 319.67,
          width: 508.67,
        ),
      ),
    );
  }
}

class LoyaltyCardVerso extends Verso {
  const LoyaltyCardVerso(this.loyaltyCard, {Key? key}) : super(key: key);

  final LoyaltyCard loyaltyCard;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.error,
      ),
      child: Column(
        children: [
          TextWithLoyaltyCardStyle(value: loyaltyCard.programName),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextWithLoyaltyCardStyle(value: loyaltyCard.givenName),
                TextWithLoyaltyCardStyle(value: loyaltyCard.familyName),
              ],
            ),
          ),
          TextWithLoyaltyCardStyle(
            value: UiDate.displayDate(l10n, loyaltyCard.birthDate),
          ),
          TextWithLoyaltyCardStyle(value: loyaltyCard.email),
          TextWithLoyaltyCardStyle(value: loyaltyCard.telephone),
          TextWithLoyaltyCardStyle(value: loyaltyCard.address),
        ],
      ),
    );
  }
}

class TextWithLoyaltyCardStyle extends StatelessWidget {
  const TextWithLoyaltyCardStyle({
    Key? key,
    required this.value,
  }) : super(key: key);

  final String value;

  @override
  Widget build(BuildContext context) {
    if (value != '') {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: Text(value, style: Theme.of(context).textTheme.loyaltyCard),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
