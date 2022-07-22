import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class CredentialActiveStatus extends StatelessWidget {
  const CredentialActiveStatus({Key? key, required this.credentialStatus})
      : super(key: key);

  final CredentialStatus credentialStatus;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      children: [
        Text(
          l10n.verificationStatus,
          style: Theme.of(context).textTheme.credentialStatus,
        ),
        const SizedBox(height: 10),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                credentialStatus.icon,
                color: credentialStatus.color(context),
              ),
              const SizedBox(width: 10),
              Text(
                credentialStatus.message(context),
                style: Theme.of(context).textTheme.credentialStatus.apply(
                      color: credentialStatus.color(context),
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
