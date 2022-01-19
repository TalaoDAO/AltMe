// ignore_for_file: cascade_invocations

import 'package:flutter/widgets.dart';
import 'package:ssi_crypto_wallet/constants.dart';

class ParallelogramClipper extends CustomClipper<Path> {


  @override
  Path getClip(Size size) {
        return _getRightPath(size);
    }


  Path _getRightPath(Size size) {
    final path = Path();
    path.moveTo(cutLength, 0);
    path.lineTo(size.width - quadraticBezierOrigin, 0);
    path.quadraticBezierTo(
      size.width - quadraticBezierControlOffset,
      quadraticBezierControlOffset,
      size.width,
      20,
    );
    path.lineTo(size.width - cutLength, size.height - quadraticBezierOrigin);
    path.quadraticBezierTo(
      size.width - cutLength - quadraticBezierControlOffset,
      size.height - quadraticBezierControlOffset,
      size.width - quadraticBezierControlOffset,
      size.height,
    );
    path.lineTo(quadraticBezierOrigin, size.height);
    path.quadraticBezierTo(
      quadraticBezierControlOffset,
      size.height - quadraticBezierControlOffset,
      0,
      size.height - quadraticBezierOrigin,
    );
    path.lineTo(
        cutLength - quadraticBezierControlOffset, -quadraticBezierOrigin,);
    path.quadraticBezierTo(
      cutLength - quadraticBezierControlOffset,
      quadraticBezierControlOffset,
      cutLength,
      0,
    );
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
return false;  }
}
