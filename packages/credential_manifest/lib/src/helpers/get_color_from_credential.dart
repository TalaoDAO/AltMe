import 'package:credential_manifest/src/models/color_object.dart';
import 'package:flutter/material.dart';

/// convert HEX color code from credential into flutter color
Color? getColorFromCredential(ColorObject? colorCode, Color fallbackColor) {
  final color = colorCode != null
      ? Color(int.parse('FF${colorCode.color!.substring(1)}', radix: 16))
      : fallbackColor;
  return color;
}
