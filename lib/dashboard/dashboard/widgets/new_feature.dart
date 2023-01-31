import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class NewFeature extends StatelessWidget {
  const NewFeature(
    this.feature, {
    super.key,
  });

  final String feature;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Icon(
              Icons.check_circle,
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              feature,
              style: Theme.of(context).textTheme.defaultDialogBody,
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }
}
