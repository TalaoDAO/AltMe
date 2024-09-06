import 'package:flutter/material.dart';

class NotifyDot extends StatelessWidget {
  const NotifyDot({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      width: 10,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.red,
      ),
    );
  }
}
