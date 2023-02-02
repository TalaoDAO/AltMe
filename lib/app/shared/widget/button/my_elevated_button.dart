import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyElevatedButton extends StatelessWidget {
  const MyElevatedButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.borderRadius = 20,
    this.verticalSpacing = 15,
    this.elevation = 2,
    this.fontSize = 18,
  });

  const MyElevatedButton.icon({
    super.key,
    required this.text,
    this.onPressed,
    required this.icon,
    this.backgroundColor,
    this.textColor,
    this.borderRadius = 40,
    this.verticalSpacing = 15,
    this.elevation = 2,
    this.fontSize = 18,
  });

  final String text;
  final GestureTapCallback? onPressed;
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
                onPressed: onPressed,
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
                onPressed: onPressed,
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
  GestureTapCallback? onPressed,
}) {
  return ButtonStyle(
    elevation: MaterialStateProperty.all(elevation),
    padding: MaterialStateProperty.all(
      EdgeInsets.symmetric(vertical: verticalSpacing),
    ),
    backgroundColor: MaterialStateProperty.all(
      onPressed == null
          ? Theme.of(context).colorScheme.disabledBgColor
          : backgroundColor ?? Theme.of(context).colorScheme.primary,
    ),
    shape: MaterialStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    ),
  );
}

class ElevatedButtonText extends StatelessWidget {
  const ElevatedButtonText({
    super.key,
    required this.text,
    this.textColor,
    this.fontSize = 18,
  });

  final String text;
  final Color? textColor;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: GoogleFonts.poppins(
        color: textColor ?? Theme.of(context).colorScheme.onElevatedButton,
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
