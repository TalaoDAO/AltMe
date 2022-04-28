/// This widget is used to adapt text size on image card when user change
/// phone orientation
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class ImageCardText extends StatelessWidget {
  const ImageCardText({
    Key? key,
    required this.text,
    this.textStyle,
  }) : super(key: key);

  final String text;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final _textStyle = textStyle ?? Theme.of(context).textTheme.imageCard;
    return Text(
      text,
      style: MediaQuery.of(context).orientation == Orientation.landscape
          ? _textStyle.copyWith(
              fontSize: _textStyle.fontSize! *
                  MediaQuery.of(context).size.aspectRatio,
            )
          : _textStyle,
    );
  }
}
