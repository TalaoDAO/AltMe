import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class MyRichText extends StatelessWidget {
  const MyRichText({
    super.key,
    required this.text,
    this.style,
    this.maxLines = 1,
  });

  final TextSpan text;
  final TextStyle? style;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final style = this.style ?? Theme.of(context).textTheme.titleMedium;
    return AutoSizeText.rich(
      text,
      minFontSize: 0,
      stepGranularity: 0.1,
      maxLines: maxLines,
      style: style,
    );
  }
}
