import 'package:altme/app/app.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class NftUrlWidget extends StatelessWidget {
  const NftUrlWidget({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.spaceNormal,
          vertical: Sizes.spaceSmall,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Sizes.normalRadius),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            stops: const [0.3, 1.0],
          ),
          color: Theme.of(context).colorScheme.tabBarNotSelected,
        ),
        child: Center(
          child: Text(
            text,
            softWrap: false,
            style: Theme.of(context).textTheme.caption,
            overflow: TextOverflow.fade,
          ),
        ),
      ),
    );
  }
}
