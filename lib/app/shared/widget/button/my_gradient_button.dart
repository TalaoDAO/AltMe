import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyGradientButton extends StatelessWidget {
  const MyGradientButton({
    super.key,
    required this.text,
    this.icon,
    this.borderRadius = 16,
    this.verticalSpacing = 20,
    this.elevation = 2,
    this.fontSize = 18,
    this.gradient,
    this.onPressed,
    this.upperCase = true,
  });

  const MyGradientButton.icon({
    super.key,
    required this.text,
    required this.icon,
    this.borderRadius = 20,
    this.verticalSpacing = 20,
    this.elevation = 2,
    this.fontSize = 18,
    this.gradient,
    this.onPressed,
    this.upperCase = true,
  });

  final String text;
  final double elevation;
  final double borderRadius;
  final double verticalSpacing;
  final double fontSize;
  final Gradient? gradient;
  final GestureTapCallback? onPressed;
  final Widget? icon;
  final bool upperCase;

  @override
  Widget build(BuildContext context) {
    final gradientValue = gradient ??
        LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).colorScheme.startButtonColorA,
            Theme.of(context).colorScheme.startButtonColorB,
          ],
          stops: const [0.0, 0.4],
        );
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          gradient: onPressed == null ? null : gradientValue,
          color: onPressed == null
              ? Theme.of(context).colorScheme.disabledBgColor
              : null,
        ),
        child: icon == null
            ? ElevatedButton(
                style: gradientStyleFrom(
                  elevation: elevation,
                  verticalSpacing: verticalSpacing,
                  borderRadius: borderRadius,
                  context: context,
                ),
                onPressed: onPressed,
                child: GradientButtonText(
                  text: text.toUpperCase(),
                  onPressed: onPressed,
                  fontSize: fontSize,
                  upperCase: upperCase,
                ),
              )
            : ElevatedButton.icon(
                icon: icon!,
                style: gradientStyleFrom(
                  elevation: elevation,
                  verticalSpacing: verticalSpacing,
                  borderRadius: borderRadius,
                  context: context,
                ),
                onPressed: onPressed,
                label: GradientButtonText(
                  text: text.toUpperCase(),
                  onPressed: onPressed,
                  fontSize: fontSize,
                  upperCase: upperCase,
                ),
              ),
      ),
    );
  }
}

ButtonStyle gradientStyleFrom({
  required double borderRadius,
  required double verticalSpacing,
  required double elevation,
  required BuildContext context,
}) {
  return ElevatedButton.styleFrom(
    elevation: elevation,
    padding: EdgeInsets.symmetric(vertical: verticalSpacing),
    backgroundColor: Theme.of(context).colorScheme.transparent,
    shadowColor: Theme.of(context).colorScheme.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    ),
  );
}

class GradientButtonText extends StatelessWidget {
  const GradientButtonText({
    super.key,
    required this.text,
    required this.onPressed,
    this.fontSize = 18,
    required this.upperCase,
  });

  final String text;
  final GestureTapCallback? onPressed;
  final double fontSize;
  final bool upperCase;

  @override
  Widget build(BuildContext context) {
    return Text(
      upperCase ? text.toUpperCase() : text,
      style: GoogleFonts.poppins(
        color: onPressed != null
            ? Theme.of(context).colorScheme.onElevatedButton
            : Theme.of(context).colorScheme.disabledTextColor,
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
