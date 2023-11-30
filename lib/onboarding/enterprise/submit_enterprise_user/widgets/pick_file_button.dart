import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class PickFileButton extends StatelessWidget {
  const PickFileButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: DottedBorder(
        color: Colors.grey,
        dashPattern: const [10, 4],
        child: const Padding(
          padding: EdgeInsets.all(4),
          child: Center(
            child: Icon(
              Icons.add,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
