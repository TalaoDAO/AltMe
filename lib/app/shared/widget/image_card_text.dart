import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

/// This widget is used to adapt text size on image card when user change
/// phone orientation
class ImageCardText extends StatelessWidget {
  const ImageCardText({
    super.key,
    required this.text,
    this.textStyle,
  });

  final String text;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final textStyle = this.textStyle ?? Theme.of(context).textTheme.imageCard;
    return Text(
      text,
      style: MediaQuery.of(context).orientation == Orientation.landscape
          ? textStyle.copyWith(
              fontSize:
                  textStyle.fontSize! * MediaQuery.of(context).size.aspectRatio,
            )
          : textStyle,
    );
  }
}
