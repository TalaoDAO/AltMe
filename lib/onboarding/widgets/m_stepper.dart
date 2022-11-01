import 'dart:math';

import 'package:altme/app/shared/constants/sizes.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class MStepper extends StatelessWidget {
  const MStepper({
    super.key,
    this.step = 1,
    this.totalStep = 3,
  });

  final int step;
  final int totalStep;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final size = min(
      MediaQuery.of(context).size.width,
      MediaQuery.of(context).size.height,
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '${l10n.step} $step/$totalStep',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(
          height: Sizes.spaceSmall,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            totalStep,
            (index) => Step(
              isEnable: (index + 1) <= step,
              width: ((size / 2) / totalStep) - (totalStep * 4),
            ),
          ),
        )
      ],
    );
  }
}

class Step extends StatelessWidget {
  const Step({
    super.key,
    this.isEnable = false,
    this.width = 50,
  });
  final bool isEnable;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 5,
      width: width,
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isEnable ? Colors.white : Colors.white.withOpacity(0.5),
        borderRadius: const BorderRadius.all(Radius.circular(3)),
      ),
    );
  }
}
