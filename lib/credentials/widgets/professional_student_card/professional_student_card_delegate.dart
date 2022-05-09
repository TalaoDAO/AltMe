import 'package:flutter/material.dart';

class ProfessionalStudentCardDelegate extends MultiChildLayoutDelegate {
  final Offset position;

  ProfessionalStudentCardDelegate({this.position = Offset.zero});

  @override
  void performLayout(Size size) {
    if (hasChild('familyName')) {
      layoutChild('familyName', BoxConstraints.loose(size));
      positionChild(
          'familyName', Offset(size.width * 0.15, size.height * 0.29));
    }
    if (hasChild('givenName')) {
      layoutChild('givenName', BoxConstraints.loose(size));
      positionChild('givenName', Offset(size.width * 0.19, size.height * 0.38));
    }

    if (hasChild('birthDate')) {
      layoutChild('birthDate', BoxConstraints.loose(size));
      positionChild('birthDate', Offset(size.width * 0.19, size.height * 0.47));
    }

    if (hasChild('expires')) {
      layoutChild('expires', BoxConstraints.loose(size));
      positionChild('expires', Offset(size.width * 0.22, size.height * 0.56));
    }

    if (hasChild('signature')) {
      layoutChild('signature', BoxConstraints.loose(size));
      positionChild('signature', Offset(size.width * 0.11, size.height * 0.75));
    }

    if (hasChild('image')) {
      layoutChild(
          'image',
          BoxConstraints.tightFor(
              width: size.width * 0.28, height: size.height * 0.59));
      positionChild('image', Offset(size.width * 0.68, size.height * 0.06));
    }
  }

  @override
  bool shouldRelayout(ProfessionalStudentCardDelegate oldDelegate) {
    return oldDelegate.position != position;
  }
}
