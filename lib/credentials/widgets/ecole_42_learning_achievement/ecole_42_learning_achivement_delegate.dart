import 'package:flutter/material.dart';

class Ecole42LearningAchievementDelegate extends MultiChildLayoutDelegate {
  final Offset position;

  Ecole42LearningAchievementDelegate({this.position = Offset.zero});

  @override
  void performLayout(Size size) {
    if (hasChild('studentIdentity')) {
      layoutChild('studentIdentity', BoxConstraints.loose(size));
      positionChild(
          'studentIdentity', Offset(size.width * 0.17, size.height * 0.33));
    }
    if (hasChild('signature')) {
      layoutChild('signature', BoxConstraints.loose(size));
      positionChild('signature', Offset(size.width * 0.5, size.height * 0.55));
    }
    if (hasChild('level')) {
      layoutChild('level', BoxConstraints.loose(size));
      positionChild('level', Offset(size.width * 0.605, size.height * 0.3685));
    }
  }

  @override
  bool shouldRelayout(
      covariant Ecole42LearningAchievementDelegate oldDelegate) {
    return oldDelegate.position != position;
  }
}
