import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraBlured extends StatelessWidget {
  const CameraBlured({
    super.key,
    required this.cameraController,
  });

  final CameraController cameraController;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        CameraPreview(cameraController),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0),
            ),
          ),
        ),
        Center(child: CameraPreview(cameraController)),
      ],
    );
  }
}
