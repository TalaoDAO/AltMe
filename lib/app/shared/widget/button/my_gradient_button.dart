import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class MyGradientButton extends StatelessWidget {
  const MyGradientButton({
    Key? key,
    required this.text,
    this.borderRadius = 20,
    this.verticalSpacing = 20,
    this.elevation = 2,
    this.fontSize = 18,
    this.gradient,
    this.onPressed,
    this.icon,
    this.upperCase = true,
    this.height,
    this.margin = EdgeInsets.zero,
  }) : super(key: key);

  final String text;
  final double elevation;
  final double borderRadius;
  final double verticalSpacing;
  final double fontSize;
  final Gradient? gradient;
  final GestureTapCallback? onPressed;
  final Widget? icon;
  final bool upperCase;
  final double? height;
  final EdgeInsets margin;

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
    return Expanded(
      child: Container(
        margin: margin,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          gradient: onPressed == null ? null : gradientValue,
          color: onPressed == null
              ? Theme.of(context).colorScheme.disabledBgColor
              : null,
        ),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            elevation: elevation,
            padding: EdgeInsets.symmetric(vertical: verticalSpacing),
            primary: Theme.of(context).colorScheme.transparent,
            shadowColor: Theme.of(context).colorScheme.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          onPressed: onPressed,
          icon: icon ?? const Center(),
          label: Text(
            upperCase ? text.toUpperCase() : text,
            style: TextStyle(
              color: onPressed != null
                  ? Theme.of(context).colorScheme.onElevatedButton
                  : Theme.of(context).colorScheme.disabledTextColor,
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
