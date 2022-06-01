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
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 13,
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: 3,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: Image.asset(icon, height: 25),
              ),
              Text(text, softWrap: false, overflow: TextOverflow.fade),
            ],
          ),
        ),
      ),
    );
  }
}
