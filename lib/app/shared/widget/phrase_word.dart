import 'package:altme/app/app.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class PhraseWord extends StatelessWidget {
  const PhraseWord({
    super.key,
    required this.order,
    required this.word,
    this.color,
    this.showOrder = true,
    this.onTap,
  });

  final int order;
  final String word;
  final Color? color;
  final bool showOrder;
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
          color: Theme.of(context).colorScheme.transparent,
          border: Border.all(
            width: 1.5,
            color: color,
          ),
          borderRadius: BorderRadius.circular(128),
        ),
        child: SizedBox(
          height: 25,
          child: Center(
            child: MyText(
              showOrder ? '$order. $word' : word,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.passPhraseText,
            ),
          ),
        ),
      ),
    );
  }
}
