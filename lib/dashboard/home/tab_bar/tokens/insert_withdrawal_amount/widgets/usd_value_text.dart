import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';

class UsdValueText extends StatelessWidget {
  const UsdValueText({
    Key? key,
    required this.usdValue,
  }) : super(key: key);

  final double usdValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Sizes.spaceXSmall),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            IconStrings.exchangeArrow,
            width: Sizes.icon,
          ),
          const SizedBox(
            width: Sizes.spaceXSmall,
          ),
          Text(
            r'$' + usdValue.toStringAsFixed(2).formatNumber(),
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );
  }
}
