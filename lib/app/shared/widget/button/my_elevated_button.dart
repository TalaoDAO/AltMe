import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class MyElevatedButton extends StatelessWidget {
  const MyElevatedButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.borderRadius = 50,
    this.verticalSpacing = 15,
    this.elevation = 2,
    this.fontSize = 18,
  }) : super(key: key);

  const MyElevatedButton.icon({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.icon,
    this.backgroundColor,
    this.textColor,
    this.borderRadius = 50,
    this.verticalSpacing = 15,
    this.elevation = 2,
    this.fontSize = 18,
  }) : super(key: key);

  final String text;
  final GestureTapCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double borderRadius;
  final double verticalSpacing;
  final double elevation;
  final double fontSize;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: icon == null
          ? ElevatedButton(
              style: elevatedStyleFrom(
                borderRadius: borderRadius,
                context: context,
                elevation: elevation,
                verticalSpacing: verticalSpacing,
                backgroundColor: backgroundColor,
              ),
              onPressed: onPressed,
              child: ElevatedButtonText(
                text: text,
                fontSize: fontSize,
                textColor: textColor,
              ),
            )
          : ElevatedButton.icon(
              icon: icon!,
              style: elevatedStyleFrom(
                borderRadius: borderRadius,
                context: context,
                elevation: elevation,
                verticalSpacing: verticalSpacing,
                backgroundColor: backgroundColor,
              ),
              onPressed: onPressed,
              label: ElevatedButtonText(
                text: text,
                fontSize: fontSize,
                textColor: textColor,
              ),
            ),
    );
  }
}

ButtonStyle elevatedStyleFrom({
  Color? backgroundColor,
  required double borderRadius,
  required double verticalSpacing,
  required double elevation,
  required BuildContext context,
}) {
  return ElevatedButton.styleFrom(
    elevation: elevation,
    padding: EdgeInsets.symmetric(vertical: verticalSpacing),
    primary: backgroundColor ?? Theme.of(context).colorScheme.primary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    ),
  );
}

class ElevatedButtonText extends StatelessWidget {
  const ElevatedButtonText({
    Key? key,
    required this.text,
    this.textColor,
    this.fontSize = 18,
  }) : super(key: key);

  final String text;
  final Color? textColor;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        color: textColor ?? Theme.of(context).colorScheme.onElevatedButton,
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
