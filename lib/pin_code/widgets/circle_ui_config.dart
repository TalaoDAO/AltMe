import 'package:flutter/material.dart';

@immutable
class CircleUIConfig {
  const CircleUIConfig({
    this.borderColor,
    this.borderWidth = 1.5,
    this.fillColor,
    this.circleSize = 22,
  });

  final Color? borderColor;
  final Color? fillColor;
  final double borderWidth;
  final double circleSize;
}

class Circle extends StatelessWidget {
  const Circle({
    super.key,
    this.filled = false,
    required this.circleUIConfig,
    this.extraSize = 0,
    required this.allowAction,
  });

  final bool filled;
  final CircleUIConfig circleUIConfig;
  final double extraSize;
  final bool allowAction;

  @override
  Widget build(BuildContext context) {
    final fillColor =
        circleUIConfig.fillColor ?? Theme.of(context).colorScheme.primary;
    final borderColor =
        circleUIConfig.borderColor ?? Theme.of(context).colorScheme.onPrimary;
    return Container(
      margin: EdgeInsets.only(bottom: extraSize),
      width: circleUIConfig.circleSize,
      height: circleUIConfig.circleSize,
      decoration: BoxDecoration(
        color: filled ? fillColor : null,
        shape: BoxShape.circle,
        border: Border.all(
          color: filled
              ? allowAction
                  ? fillColor
                  : fillColor.withOpacity(0.1)
              : allowAction
                  ? borderColor
                  : borderColor.withOpacity(0.1),
          width: circleUIConfig.borderWidth,
        ),
      ),
    );
  }
}
