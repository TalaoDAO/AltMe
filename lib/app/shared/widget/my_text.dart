import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class MyText extends StatelessWidget {
  const MyText(
    this.text, {
    Key? key,
    this.style,
    this.maxLines = 1,
    this.textAlign = TextAlign.left,
    this.overflow,
    this.minFontSize = 0,
    this.maxLength,
  }) : super(key: key);

  final String text;
  final TextStyle? style;
  final int maxLines;
  final int? maxLength;
  final TextAlign textAlign;
  final TextOverflow? overflow;
  final double minFontSize;

  @override
  Widget build(BuildContext context) {
    final style = this.style ?? Theme.of(context).textTheme.subtitle1;
    return AutoSizeText(
      textWithDesiredLength,
      style: style,
      overflow: overflow,
      maxLines: maxLines,
      minFontSize: minFontSize,
      textAlign: textAlign,
    );
  }

  String get textWithDesiredLength {
    if (maxLength == null || maxLength! > text.length) return text;
    return text.substring(0, maxLength);
  }
}
