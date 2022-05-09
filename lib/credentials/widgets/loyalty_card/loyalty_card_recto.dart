import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';

class LoyaltyCardRecto extends Recto {
  const LoyaltyCardRecto({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          fit: BoxFit.fitWidth,
          image: AssetImage(
            'assets/image/tezotopia_loyalty_card.jpeg',
          ),
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
