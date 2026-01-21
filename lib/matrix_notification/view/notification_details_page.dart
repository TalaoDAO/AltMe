import 'package:altme/app/app.dart';
import 'package:altme/chat_room/widget/mxc_image.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/gestures.dart';

import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:matrix/matrix.dart';

class NotificationDetailsPage extends StatelessWidget {
  const NotificationDetailsPage({super.key, required this.message});

  final Message message;

  static Route<void> route({required Message message}) {
    return MaterialPageRoute<void>(
      builder: (_) => NotificationDetailsPage(message: message),
      settings: const RouteSettings(name: '/NotificationDetailsPage'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;

    if (message is ImageMessage) {
      return BasePage(
        title: l10n.notification,
        scrollView: false,
        titleLeading: const BackLeadingButton(),
        titleAlignment: Alignment.topCenter,
        padding: const EdgeInsets.all(Sizes.spaceSmall),
        body: MxcImage(
          url: (message as ImageMessage).uri,
          event: message.metadata!['event'] as Event,
          fit: BoxFit.contain,
        ),
      );
    } else if (message is TextMessage) {
      final sentence = (message as TextMessage).text;

      final emailRegExp = RegExp(
        r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b',
      );
      final urlRegExp = RegExp(r'(https?:\/\/[^\s]+)');

      final style = TextStyle(
        color: colorScheme.onSurface,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.5,
      );

      final textSpans = <TextSpan>[];
      int lastMatchEnd = 0;

      final matches = [
        ...emailRegExp.allMatches(sentence),
        ...urlRegExp.allMatches(sentence),
      ]..sort((a, b) => a.start.compareTo(b.start));

      // Add non-matching parts of the sentence
      for (final match in matches) {
        if (match.start > lastMatchEnd) {
          textSpans.add(
            TextSpan(
              text: sentence.substring(lastMatchEnd, match.start),
              style: style,
            ),
          );
        }

        final matchedText = match.group(0);
        if (matchedText != null) {
          if (emailRegExp.hasMatch(matchedText)) {
            textSpans.add(
              TextSpan(
                text: matchedText,
                style: style.copyWith(color: Colors.blue),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => LaunchUrl.launch('mailto:$matchedText'),
              ),
            );
          } else if (urlRegExp.hasMatch(matchedText)) {
            textSpans.add(
              TextSpan(
                text: matchedText,
                style: style.copyWith(color: Colors.blue),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => LaunchUrl.launch(matchedText),
              ),
            );
          }
        }
        lastMatchEnd = match.end;
      }

      // Add remaining text after the last match
      if (lastMatchEnd < sentence.length) {
        textSpans.add(
          TextSpan(text: sentence.substring(lastMatchEnd), style: style),
        );
      }

      return BasePage(
        title: l10n.notification,
        scrollView: false,
        titleLeading: const BackLeadingButton(),
        titleAlignment: Alignment.topCenter,
        padding: const EdgeInsets.all(Sizes.spaceSmall),
        body: RichText(text: TextSpan(children: textSpans)),
      );
    } else {
      return Container();
    }
  }
}
