import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CameraImageBlured extends StatelessWidget {
  const CameraImageBlured({
    super.key,
    required this.imageBytes,
  });

  final List<int> imageBytes;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.memory(
          Uint8List.fromList(imageBytes),
          fit: BoxFit.fill,
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0),
            ),
          ),
        ),
        Center(
          child: Image.memory(
            Uint8List.fromList(imageBytes),
          ),
        ),
      ],
    );
  }
}
