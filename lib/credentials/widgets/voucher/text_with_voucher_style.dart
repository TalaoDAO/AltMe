import 'package:altme/app/app.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class TextWithVoucherStyle extends StatelessWidget {
  const TextWithVoucherStyle({
    Key? key,
    required this.value,
  }) : super(key: key);

  final String value;

  @override
  Widget build(BuildContext context) {
    if (value != '') {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: ImageCardText(
          text: value,
          textStyle: Theme.of(context).textTheme.voucherOverlay,
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
