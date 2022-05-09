import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class MyText extends StatelessWidget {
  const MyText(
    this.text, {
    Key? key,
    this.style,
    this.maxLines = 1,
    this.textAlign = TextAlign.left,
  }) : super(key: key);

  final String text;
  final TextStyle? style;
  final int maxLines;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    final style = this.style ?? Theme.of(context).textTheme.subtitle1;
    return AutoSizeText(
      text,
      style: style,
      maxLines: maxLines,
      minFontSize: 0,
      textAlign: textAlign,
    );
  }
}
