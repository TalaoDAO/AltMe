import 'package:altme/app/app.dart';

import 'package:flutter/material.dart';

class EnterpriseData extends StatelessWidget {
  const EnterpriseData({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.titleLarge!;
    return Container(
      padding: const EdgeInsets.all(Sizes.spaceNormal),
      margin: const EdgeInsets.all(Sizes.spaceXSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.all(
          Radius.circular(Sizes.normalRadius),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        child: RichText(
          text: TextSpan(
            children: <InlineSpan>[
              TextSpan(text: '$title: ', style: textStyle),
              TextSpan(
                text: value,
                style: textStyle.copyWith(
                  color: const Color(0xFF8682A8),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
