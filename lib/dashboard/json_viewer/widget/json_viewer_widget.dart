import 'package:flutter/material.dart';

class JsonViewWidget extends StatelessWidget {
  const JsonViewWidget({super.key, required this.data});

  final String data;

  @override
  Widget build(BuildContext context) {
    final pattern = RegExp(r'<b>(.*?)<\/b>');
    final matches = pattern.allMatches(data);

    final textSpans = <TextSpan>[];
    int currentIndex = 0;

    for (final match in matches) {
      final plainText = data.substring(currentIndex, match.start);
      final boldText = data.substring(match.start + 3, match.end - 4);
      textSpans.add(
        TextSpan(
          text: plainText,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
      textSpans.add(
        TextSpan(
          text: boldText,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w700),
        ),
      );
      currentIndex = match.end;
    }

    if (currentIndex < data.length) {
      final remainingText = data.substring(currentIndex);
      textSpans.add(
        TextSpan(
          text: remainingText,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    return RichText(text: TextSpan(children: textSpans));
  }
}
