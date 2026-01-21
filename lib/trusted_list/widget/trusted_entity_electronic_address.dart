import 'package:altme/app/shared/alert_message/alert_message.dart';
import 'package:altme/app/shared/launch_url/launch_url.dart';
import 'package:altme/app/shared/models/state_message/state_message.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/trusted_list/model/electronic_address.dart';
import 'package:flutter/material.dart';

class TrustedEntityElectronicAddress extends StatelessWidget {
  const TrustedEntityElectronicAddress({
    super.key,
    required this.electronicAddress,
    required this.textTheme,
  });
  final ElectronicAddress electronicAddress;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final uriParts = electronicAddress.uri.split(':');
    final displayValue = uriParts.length > 1
        ? uriParts.sublist(1).join(':').trim()
        : electronicAddress.uri;
    return Padding(
      padding: const EdgeInsets.all(8),
      child: InkWell(
        onTap: () async {
          try {
            await LaunchUrl.launch(electronicAddress.uri);
            Navigator.pop(context);
          } catch (_) {
            AlertMessage.showStateMessage(
              context: context,
              stateMessage: StateMessage.error(
                stringMessage: l10n.failedToSendEmail,
              ),
            );
          }
        },
        child: Text(
          displayValue,
          style: textTheme.bodyLarge?.copyWith(color: Colors.blue),
        ),
      ),
    );
  }
}
