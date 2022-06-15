import 'package:altme/app/app.dart';
import 'package:altme/home/home.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class LoyaltyCardDisplayInList extends StatelessWidget {
  const LoyaltyCardDisplayInList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return DefaultCredentialSubjectDisplayInList(
      credentialModel: credentialModel,
    );
  }
}

class LoyaltyCardDisplayInSelectionList extends StatelessWidget {
  const LoyaltyCardDisplayInSelectionList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return DefaultCredentialSubjectDisplayInSelectionList(
      credentialModel: credentialModel,
    );
  }
}

class LoyaltyCardDisplayDetail extends StatelessWidget {
  const LoyaltyCardDisplayDetail({Key? key, required this.credentialModel})
      : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    final loyaltyCardModel = credentialModel
        .credentialPreview.credentialSubjectModel as LoyaltyCardModel;
    return Column(
      children: [
        CardAnimation(
          recto: const LoyaltyCardRecto(),
          verso: LoyaltyCardVerso(loyaltyCardModel: loyaltyCardModel),
        ),
      ],
    );
  }
}

class LoyaltyCardRecto extends Recto {
  const LoyaltyCardRecto({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CredentialImage(
      image: ImageStrings.loyaltyCard,
      child: AspectRatio(
        /// random size, copy from professional student card
        aspectRatio: 508.67 / 319.67,
        child: SizedBox.shrink(),
      ),
    );
  }
}

class LoyaltyCardVerso extends Verso {
  const LoyaltyCardVerso({Key? key, required this.loyaltyCardModel})
      : super(key: key);

  final LoyaltyCardModel loyaltyCardModel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return CredentialContainer(
      child: AspectRatio(
        /// random size, copy from professional student card
        aspectRatio: 508.67 / 319.67,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).colorScheme.error,
          ),
          child: Column(
            children: [
              TextWithLoyaltyCardStyle(value: loyaltyCardModel.programName!),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextWithLoyaltyCardStyle(
                        value: loyaltyCardModel.givenName!),
                    TextWithLoyaltyCardStyle(
                        value: loyaltyCardModel.familyName!),
                  ],
                ),
              ),
              TextWithLoyaltyCardStyle(
                value: UiDate.displayDate(l10n, loyaltyCardModel.birthDate!),
              ),
              TextWithLoyaltyCardStyle(value: loyaltyCardModel.email!),
              TextWithLoyaltyCardStyle(value: loyaltyCardModel.telephone!),
              TextWithLoyaltyCardStyle(value: loyaltyCardModel.address!),
            ],
          ),
        ),
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
