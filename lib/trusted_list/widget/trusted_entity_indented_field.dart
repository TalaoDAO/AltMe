import 'package:flutter/material.dart';

class TrustedEntityIndentedField extends StatelessWidget {
  const TrustedEntityIndentedField({
    super.key,
    required this.label,
    required this.value,
    required this.textTheme,
  });
  final String label;
  final String value;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 1, bottom: 1),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(value, style: textTheme.bodyLarge)),
        ],
      ),
    );
  }
}
