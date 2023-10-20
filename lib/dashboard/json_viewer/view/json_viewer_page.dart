import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';

class JsonViewerPage extends StatelessWidget {
  const JsonViewerPage({
    super.key,
    required this.title,
    required this.data,
  });

  final String title;
  final String data;

  static Route<dynamic> route({
    required String title,
    required String data,
  }) =>
      MaterialPageRoute<void>(
        builder: (_) => JsonViewerPage(
          title: title,
          data: data,
        ),
        settings: const RouteSettings(name: '/JsonViewerPage'),
      );

  @override
  Widget build(BuildContext context) {
    return JsonViewerView(
      title: title,
      data: data,
    );
  }
}

class JsonViewerView extends StatelessWidget {
  const JsonViewerView({
    super.key,
    required this.title,
    required this.data,
  });

  final String title;
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
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
      );
      currentIndex = match.end;
    }

    if (currentIndex < data.length) {
      final remainingText = data.substring(currentIndex);
      textSpans.add(TextSpan(text: remainingText));
    }

    return BasePage(
      title: title,
      titleAlignment: Alignment.topCenter,
      scrollView: true,
      titleLeading: const BackLeadingButton(),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      body: RichText(
        text: TextSpan(children: textSpans),
      ),
    );
  }
}
