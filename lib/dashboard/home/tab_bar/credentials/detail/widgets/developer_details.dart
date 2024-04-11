import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';

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

    final String issuerDid = credentialModel.credentialPreview.issuer;
    final String subjectDid =
        credentialModel.credentialPreview.credentialSubjectModel.id ?? '';
    final String type = credentialModel.credentialPreview.type.toString();

    final jwt = credentialModel.jwt;

    dynamic uri;
    dynamic idx;

    if (jwt != null) {
      final payload = JWTDecode().parseJwt(jwt);
      final status = payload['status'];
      if (status != null && status is Map<String, dynamic>) {
        final statusList = status['status_list'];
        if (statusList != null && statusList is Map<String, dynamic>) {
          uri = statusList['uri'];
          idx = statusList['idx'];
        }
      }
    }

    final titleColor = Theme.of(context).colorScheme.titleColor;
    final valueColor = Theme.of(context).colorScheme.valueColor;

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
        CredentialField(
          padding: const EdgeInsets.only(top: 10),
          title: l10n.issuerDID,
          value: issuerDid,
          titleColor: titleColor,
          valueColor: valueColor,
          showVertically: showVertically,
        ),
        if (credentialModel.credentialPreview.credentialSubjectModel
                is! WalletCredentialModel &&
            subjectDid.isNotEmpty)
          CredentialField(
            padding: const EdgeInsets.only(top: 10),
            title: l10n.subjectDID,
            value: subjectDid,
            titleColor: titleColor,
            valueColor: valueColor,
            showVertically: showVertically,
          ),
        CredentialField(
          padding: const EdgeInsets.only(top: 10),
          title: l10n.type,
          value: type,
          titleColor: titleColor,
          valueColor: valueColor,
          showVertically: showVertically,
        ),
        if (uri != null) ...[
          CredentialField(
            padding: const EdgeInsets.only(top: 10),
            title: l10n.statusList,
            value: uri.toString(),
            titleColor: titleColor,
            valueColor: valueColor,
            showVertically: false,
          ),
        ],
        if (idx != null) ...[
          CredentialField(
            padding: const EdgeInsets.only(top: 10),
            title: l10n.statusListIndex,
            value: idx.toString(),
            titleColor: titleColor,
            valueColor: valueColor,
            showVertically: false,
          ),
        ],
      ],
    );
  }
}
