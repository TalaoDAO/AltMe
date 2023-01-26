import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class BottomBarItem extends StatelessWidget {
  const BottomBarItem({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
    required this.isSelected,
  });

  final String text;
  final String icon;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(bottom: 5),
              child: ImageIcon(
                AssetImage(icon),
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.unSelectedLabel,
                size: 20,
              ),
            ),
            Text(
              text.toUpperCase(),
              softWrap: false,
              overflow: TextOverflow.fade,
              style: Theme.of(context).textTheme.bottomBar.copyWith(
                    color: isSelected
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.unSelectedLabel,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
