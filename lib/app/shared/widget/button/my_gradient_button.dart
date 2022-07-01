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
  }) : super(key: key);

  final String text;
  final double elevation;
  final double borderRadius;
  final double verticalSpacing;
  final double fontSize;
  final Gradient? gradient;
  final GestureTapCallback? onPressed;

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
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          gradient: onPressed == null ? null : gradientValue,
        ),
        child: ElevatedButton(
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
          child: Text(
            text.toUpperCase(),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onElevatedButton,
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
