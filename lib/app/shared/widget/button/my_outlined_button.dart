import 'package:flutter/material.dart';

class MyOutlinedButton extends StatelessWidget {
  const MyOutlinedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.borderRadius = 8,
    this.verticalSpacing = 15,
    this.elevation = 2,
    this.fontSize = 18,
  });

  const MyOutlinedButton.icon({
    super.key,
    required this.text,
    required this.onPressed,
    required this.icon,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.borderRadius = 8,
    this.verticalSpacing = 15,
    this.elevation = 2,
    this.fontSize = 18,
  });

  final String text;
  final GestureTapCallback? onPressed;
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
                onPressed: onPressed,
              ),
              onPressed: onPressed,
              child: Text(
                text.toUpperCase(),
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: onPressed == null
                          ? Theme.of(context)
                              .colorScheme
                              .inverseSurface
                              .withValues(alpha: 0.12)
                          : textColor ??
                              Theme.of(context).colorScheme.inverseSurface,
                    ),
              ),
            )
          : OutlinedButton.icon(
              icon: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  textColor ?? Theme.of(context).colorScheme.secondaryContainer,
                  BlendMode.srcIn,
                ),
                child: icon,
              ),
              style: outlinedStyleFrom(
                borderRadius: borderRadius,
                context: context,
                elevation: elevation,
                verticalSpacing: verticalSpacing,
                backgroundColor: backgroundColor,
                borderColor: borderColor,
                onPressed: onPressed,
              ),
              onPressed: onPressed,
              label: Text(
                text.toUpperCase(),
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: onPressed == null
                          ? Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.12)
                          : textColor ??
                              Theme.of(context).colorScheme.secondaryContainer,
                    ),
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
  required GestureTapCallback? onPressed,
}) {
  return OutlinedButton.styleFrom(
    padding: EdgeInsets.symmetric(vertical: verticalSpacing),
    elevation: elevation,
    backgroundColor: backgroundColor ?? Colors.transparent,
    side: BorderSide(
      color: onPressed == null
          ? Theme.of(context).colorScheme.inverseSurface.withValues(alpha: 0.12)
          : borderColor ?? Theme.of(context).colorScheme.inverseSurface,
      width: 2,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    ),
  );
}

class OutlinedButtonText extends StatelessWidget {
  const OutlinedButtonText({
    super.key,
    required this.text,
    this.textColor,
    this.fontSize = 18,
    required this.onPressed,
  });

  final String text;
  final Color? textColor;
  final double fontSize;
  final GestureTapCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        color: onPressed == null
            ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12)
            : textColor ?? Theme.of(context).colorScheme.secondaryContainer,
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
