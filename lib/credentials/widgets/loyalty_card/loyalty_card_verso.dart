import 'package:altme/app/app.dart';
import 'package:altme/credentials/credential.dart';
import 'package:flutter/material.dart';

class LoyaltyCardVerso extends Verso {
  final LoyaltyCardModel loyaltyCard;

  const LoyaltyCardVerso(this.loyaltyCard, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              value: UIDate.displayDate(loyaltyCard.birthDate)),
          TextWithLoyaltyCardStyle(value: loyaltyCard.email),
          TextWithLoyaltyCardStyle(value: loyaltyCard.telephone),
          TextWithLoyaltyCardStyle(value: loyaltyCard.address),
        ],
      ),
    );
  }
}
