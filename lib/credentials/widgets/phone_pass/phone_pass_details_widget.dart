import 'package:altme/app/app.dart';
import 'package:altme/credentials/credential.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class PhonePassDetailsWidget extends StatelessWidget {
  const PhonePassDetailsWidget({Key? key, required this.phonePassModel})
      : super(key: key);

  final PhonePassModel phonePassModel;

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;

    return Column(
      children: [
        CredentialField(
          title: localizations.personalPhone,
          value: phonePassModel.phone,
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: DisplayIssuer(
            issuer: phonePassModel.issuedBy,
          ),
        ),
      ],
    );
  }
}
