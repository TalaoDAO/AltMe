import 'package:altme/app/shared/widget/hero_workaround.dart';
import 'package:flutter/material.dart';

class TooltipText extends StatelessWidget {
  const TooltipText({
    super.key,
    this.tag,
    required this.text,
    this.tooltip,
    this.maxLines = 1,
    this.style,
    this.textAlign = TextAlign.start,
    this.softWrap = false,
  });

  final String? tag;
  final String text;
  final String? tooltip;

  final int? maxLines;
  final TextStyle? style;
  final TextAlign textAlign;

  final bool softWrap;

  @override
  Widget build(BuildContext context) {
    final child = Tooltip(
      message: tooltip ?? text,
      child: Text(
        text,
        textAlign: textAlign,
        overflow: TextOverflow.fade,
        maxLines: maxLines,
        softWrap: softWrap,
        style: style,
      ),
    );

    if (tag != null) {
      if (tag!.isNotEmpty) {
        return HeroFix(
          tag: tag!,
          child: child,
        );
      }
    }

    return child;
  }
}
