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
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.spaceXSmall,
          vertical: Sizes.spaceSmall,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Sizes.normalRadius),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(icon, height: Sizes.icon),
            const SizedBox(
              width: Sizes.spaceXSmall,
            ),
            MyText(
              text,
              maxLines: 1,
              minFontSize: 12,
              style: Theme.of(context).textTheme.title.copyWith(
                    color: isSelected ? null : Colors.grey[400],
                  ),
              overflow: TextOverflow.fade,
            ),
          ],
        ),
      ),
    );
  }
}
