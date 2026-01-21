import 'package:altme/app/app.dart';

import 'package:flutter/material.dart';

class PhraseWord extends StatelessWidget {
  const PhraseWord({
    super.key,
    this.order,
    required this.word,
    this.color,
    this.onTap,
  });

  final int? order;
  final String word;
  final Color? color;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final color = this.color ?? Theme.of(context).colorScheme.primary;
    return TransparentInkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.spaceSmall,
          vertical: Sizes.spaceSmall,
        ),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(width: 1.5, color: color),
          borderRadius: BorderRadius.circular(128),
        ),
        child: SizedBox(
          height: 25,
          child: Center(
            child: MyText(
              order == null ? word : '$order. $word',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
