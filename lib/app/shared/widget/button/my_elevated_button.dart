import 'package:altme/app/shared/widget/widget.dart';
import 'package:flutter/material.dart';

class MyElevatedButton extends StatelessWidget {
  const MyElevatedButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.borderRadius = 50,
    this.verticalSpacing = 10,
    this.elevation = 2,
    this.fontSize = 20,
  }) : super(key: key);

  final String text;
  final GestureTapCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double borderRadius;
  final double verticalSpacing;
  final double elevation;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: elevation,
          padding: EdgeInsets.symmetric(vertical: verticalSpacing),
          primary: backgroundColor ?? Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        onPressed: onPressed,
        child: MyText(
          text,
          style: TextStyle(
            color: textColor ?? Theme.of(context).colorScheme.onPrimary,
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
