import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class MyOutlinedButton extends StatelessWidget {
  const MyOutlinedButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.borderRadius = 50,
    this.verticalSpacing = 15,
    this.elevation = 2,
    this.fontSize = 18,
  }) : super(key: key);

  const MyOutlinedButton.icon({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.icon,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.borderRadius = 50,
    this.verticalSpacing = 15,
    this.elevation = 2,
    this.fontSize = 18,
  }) : super(key: key);

  final String text;
  final GestureTapCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
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
          ? OutlinedButton(
              style: outlinedStyleFrom(
                borderRadius: borderRadius,
                context: context,
                elevation: elevation,
                verticalSpacing: verticalSpacing,
                backgroundColor: backgroundColor,
                borderColor: borderColor,
              ),
              onPressed: onPressed,
              child: OutlinedButtonText(
                text: text,
                fontSize: fontSize,
                textColor: textColor,
              ),
            )
          : OutlinedButton.icon(
              icon: icon!,
              style: outlinedStyleFrom(
                borderRadius: borderRadius,
                context: context,
                elevation: elevation,
                verticalSpacing: verticalSpacing,
                backgroundColor: backgroundColor,
                borderColor: borderColor,
              ),
              onPressed: onPressed,
              label: OutlinedButtonText(
                text: text,
                fontSize: fontSize,
                textColor: textColor,
              ),
            ),
    );
  }
}

ButtonStyle outlinedStyleFrom({
  Color? backgroundColor,
  Color? borderColor,
  required double borderRadius,
  required double verticalSpacing,
  required double elevation,
  required BuildContext context,
}) {
  return OutlinedButton.styleFrom(
    padding: EdgeInsets.symmetric(vertical: verticalSpacing),
    elevation: elevation,
    backgroundColor:
        backgroundColor ?? Theme.of(context).colorScheme.background,
    side: BorderSide(
      color: borderColor ?? Theme.of(context).colorScheme.primary,
      width: 2,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    ),
  );
}

class OutlinedButtonText extends StatelessWidget {
  const OutlinedButtonText({
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
        color: textColor ?? Theme.of(context).colorScheme.onOutlineButton,
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
