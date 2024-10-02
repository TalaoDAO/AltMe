import 'package:altme/app/app.dart';
import 'package:altme/chat_room/widget/mxc_image.dart';
import 'package:altme/l10n/l10n.dart';

import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:matrix/matrix.dart';

class NotificationDetailsPage extends StatelessWidget {
  const NotificationDetailsPage({
    super.key,
    required this.message,
  });

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

    return BasePage(
      title: l10n.notification,
      scrollView: false,
      titleLeading: const BackLeadingButton(),
      titleAlignment: Alignment.topCenter,
      padding: const EdgeInsets.all(Sizes.spaceSmall),
      body: message is TextMessage
          ? Text(
              (message as TextMessage).text,
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            )
          : message is ImageMessage
              ? MxcImage(
                  url: (message as ImageMessage).uri,
                  event: message.metadata!['event'] as Event,
                  fit: BoxFit.contain,
                )
              : Container(),
    );
  }
}
