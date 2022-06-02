import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class BottomBarItem extends StatelessWidget {
  const BottomBarItem({
    Key? key,
    required this.icon,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  final String text;
  final String icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(bottom: 5),
            child: ImageIcon(
              AssetImage(icon),
              color: Theme.of(context).colorScheme.onPrimary,
              size: 20,
            ),
          ),
          Text(
            text.toUpperCase(),
            softWrap: false,
            overflow: TextOverflow.fade,
            style: Theme.of(context).textTheme.bottomBar,
          ),
        ],
      ),
    );
  }
}
