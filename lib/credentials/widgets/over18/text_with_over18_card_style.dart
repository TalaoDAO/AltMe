import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class TextWithOver18CardStyle extends StatelessWidget {
  const TextWithOver18CardStyle({
    Key? key,
    required this.value,
  }) : super(key: key);

  final String value;

  @override
  Widget build(BuildContext context) {
    if (value != '') {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Text(value, style: Theme.of(context).textTheme.over18),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
