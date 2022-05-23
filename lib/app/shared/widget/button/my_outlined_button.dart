import 'package:altme/app/shared/widget/widget.dart';
import 'package:flutter/material.dart';

class MyOutlinedButton extends StatelessWidget {
  const MyOutlinedButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.borderRadius = 50,
    this.verticalSpacing = 10,
    this.elevation = 2,
    this.fontSize = 20,
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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
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
        ),
        onPressed: onPressed,
        child: MyText(
          text,
          style: TextStyle(
            color: textColor ?? Theme.of(context).colorScheme.primary,
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
