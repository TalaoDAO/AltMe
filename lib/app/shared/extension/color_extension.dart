import 'package:flutter/material.dart';

extension ColorExtension on Color {
  Color get adaptiveTopColor {
    final double luminance = computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}
