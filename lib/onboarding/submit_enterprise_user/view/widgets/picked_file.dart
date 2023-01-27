import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class PickedFile extends StatelessWidget {
  const PickedFile({
    super.key,
    required this.fileName,
    required this.onDeleteButtonPress,
  });

  final String fileName;
  final VoidCallback onDeleteButtonPress;

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      color: Colors.grey,
      dashPattern: const [10, 4],
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                fileName,
                maxLines: 1,
              ),
            ),
            IconButton(
              onPressed: onDeleteButtonPress,
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            )
          ],
        ),
      ),
    );
  }
}
