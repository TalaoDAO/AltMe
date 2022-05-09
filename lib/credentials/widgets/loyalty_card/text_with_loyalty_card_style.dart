import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

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
