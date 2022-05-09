import 'package:altme/app/app.dart';
import 'package:altme/credentials/credential.dart';
import 'package:flutter/material.dart';

class LoyaltyCardDetailsWidget extends StatelessWidget {
  const LoyaltyCardDetailsWidget({Key? key, required this.model})
      : super(key: key);
  final LoyaltyCardModel model;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          /// this size comes from law publication about job student card specs
          aspectRatio: 508.67 / 319.67,
          child: SizedBox(
            height: 319.67,
            width: 508.67,
            child: CardAnimationWidget(
              recto: const LoyaltyCardRecto(),
              verso: LoyaltyCardVerso(model),
            ),
          ),
        ),
      ],
    );
  }
}
