import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';

import 'package:flutter/material.dart';

class NotificationDetailsPage extends StatelessWidget {
  const NotificationDetailsPage({
    super.key,
    required this.message,
  });

  final String message;

  static Route<void> route({required String message}) {
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
      body: Text(
        message,
        style: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          height: 1.5,
        ),
      ),
    );
  }
}
