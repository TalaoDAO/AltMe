import 'package:altme/app/app.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class PhraseWord extends StatelessWidget {
  const PhraseWord({
    Key? key,
    required this.order,
    required this.word,
  }) : super(key: key);

  final int order;
  final String word;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.spaceSmall,
          vertical: Sizes.spaceSmall,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.transparent,
          border: Border.all(
            width: 1.5,
            color: Theme.of(context).colorScheme.primary,
          ),
          borderRadius: BorderRadius.circular(128),
        ),
        child: MyText(
          '$order. $word',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.passPhraseText,
        ),
      );
}
