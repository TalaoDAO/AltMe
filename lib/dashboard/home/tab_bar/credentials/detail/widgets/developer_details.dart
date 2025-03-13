import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/selective_disclosure/selective_disclosure.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:oidc4vc/oidc4vc.dart';

class DeveloperDetails extends StatelessWidget {
  const DeveloperDetails({
    super.key,
    required this.credentialModel,
    required this.showVertically,
  });

  final CredentialModel credentialModel;
  final bool showVertically;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final titleColor = Theme.of(context).colorScheme.onSurface;
    final valueColor = Theme.of(context).colorScheme.onSurface;

    final jwtDecode = JWTDecode();

    String? header;
    String? payload;
    String? data;

    if (credentialModel.jwt != null) {
      final jsonheader = decodeHeader(
        jwtDecode: jwtDecode,
        token: credentialModel.jwt!,
      );
      header = const JsonEncoder.withIndent('  ').convert(jsonheader);
      final jsonPayload = decodePayload(
        jwtDecode: jwtDecode,
        token: credentialModel.jwt!,
      );
      payload = const JsonEncoder.withIndent('  ').convert(
        Map.of(jsonPayload)..removeWhere((key, value) => key == 'jwt'),
      );

      if (credentialModel.getFormat == VCFormatType.vcSdJWT.vcValue) {
        final selectiveDisclosure = SelectiveDisclosure(credentialModel);

        final data = createJsonByDecryptingSDValues(
          encryptedJson: jsonPayload,
          selectiveDisclosure: selectiveDisclosure,
        );

        payload = const JsonEncoder.withIndent('  ')
            .convert(Map.of(data)..removeWhere((key, value) => key == 'jwt'));
      }
    } else {
      data = const JsonEncoder.withIndent('  ').convert(credentialModel.data);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CredentialField(
          padding: const EdgeInsets.only(top: 10),
          title: l10n.format,
          value: credentialModel.getFormat,
          titleColor: titleColor,
          valueColor: valueColor,
          showVertically: showVertically,
        ),
        if (header != null)
          CredentialField(
            padding: const EdgeInsets.only(top: 10),
            title: l10n.header,
            value: header,
            titleColor: titleColor,
            valueColor: valueColor,
            showVertically: showVertically,
          ),
        if (payload != null)
          CredentialField(
            padding: const EdgeInsets.only(top: 10),
            title: l10n.payload,
            value: payload,
            titleColor: titleColor,
            valueColor: valueColor,
            showVertically: showVertically,
          ),
        if (data != null)
          CredentialField(
            padding: const EdgeInsets.only(top: 10),
            title: l10n.data,
            value: data,
            titleColor: titleColor,
            valueColor: valueColor,
            showVertically: showVertically,
          ),
      ],
    );
  }
}
