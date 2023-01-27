import 'package:flutter/material.dart';

@immutable
class CircleUIConfig {
  const CircleUIConfig({
    this.borderColor = Colors.white,
    this.borderWidth = 1.5,
    this.fillColor = const Color(0xFF6600FF),
    this.defaultColor = Colors.white,
    this.circleSize = 22,
  });

  final Color borderColor;
  final Color fillColor;
  final Color defaultColor;
  final double borderWidth;
  final double circleSize;
}

class Circle extends StatelessWidget {
  const Circle({
    super.key,
    this.filled = false,
    required this.circleUIConfig,
    this.extraSize = 0,
  });

  final bool filled;
  final CircleUIConfig circleUIConfig;
  final double extraSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: extraSize),
      width: circleUIConfig.circleSize,
      height: circleUIConfig.circleSize,
      decoration: BoxDecoration(
        color: filled ? circleUIConfig.fillColor : null,
        shape: BoxShape.circle,
        border: Border.all(
          color: filled ? circleUIConfig.fillColor : circleUIConfig.borderColor,
          width: circleUIConfig.borderWidth,
        ),
      ),
    );
  }
}
