import 'package:flutter/material.dart';

abstract class SizeHelper {
  ///Padding and margin
  static const double space2XSmall = 4;
  static const double spaceXSmall = 6;
  static const double spaceSmall = 12;
  static const double spaceNormal = 24;
  static const double spaceLarge = 28;

  ///Button
  static const double buttonHeightSmall = 28;
  static const double buttonHeightNormal = 48;
  static const double buttonHeightLarge = 67;

  ///Radius
  static const double radiusSmall = 12;
  static const double radiusNormal = 20;
  static const double radiusLarge = 28;

  ///Logo
  static const double logoSmall = 38;
  static const double logoNormal = 50;
  static const double logoLarge = 100;

  ///HeaderButton
  static const double headerButton = 115;

  ///Icon
  static const double iconSmall = 18;
  static const double iconNormal = 26;
  static const double iconLarge = 34;

  ///TODO need to update
  static BorderRadius buttonRadius = BorderRadius.circular(24.0);

  static EdgeInsets navBarPadding = EdgeInsets.zero;

  static BorderRadius navBarRadius = BorderRadius.zero;

  static EdgeInsets textFieldPadding = EdgeInsets.zero;

  static BorderRadius textFieldRadius = BorderRadius.zero;
  static EdgeInsets buttonPadding = const EdgeInsets.symmetric(
    vertical: 8.0,
  );
}
