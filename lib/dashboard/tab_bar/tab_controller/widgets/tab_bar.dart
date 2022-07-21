import 'package:altme/app/app.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class MyTab extends StatelessWidget {
  const MyTab({
    Key? key,
    required this.icon,
    required this.text,
    required this.isSelected,
    required this.onPressed,
  }) : super(key: key);

  final String text;
  final String icon;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.spaceXSmall,
          vertical: Sizes.spaceSmall,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Sizes.largeRadius),
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                  ],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  stops: const [0.3, 1.0],
                )
              : null,
          color: isSelected
              ? null
              : Theme.of(context).colorScheme.tabBarNotSelected,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Image.asset(icon, height: Sizes.icon2x),
            ),
            Text(text, softWrap: false, overflow: TextOverflow.fade),
          ],
        ),
      ),
    );
  }
}
