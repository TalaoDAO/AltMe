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
    required this.statusListUri,
    required this.statusListIndex,
  });

  final CredentialModel credentialModel;
  final bool showVertically;
  final String? statusListUri;
  final int? statusListIndex;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    // final String issuerDid = credentialModel.credentialPreview.issuer;
    // final String subjectDid =
    //     credentialModel.credentialPreview.credentialSubjectModel.id ?? '';
    // final String type = credentialModel.credentialPreview.type.toString();

    final titleColor = Theme.of(context).colorScheme.onSurface;
    final valueColor = Theme.of(context).colorScheme.onSurface;

    final jwtDecode = JWTDecode();

    String? header;
    String? payload;
    String? data;

    String? kbHeader;
    String? kbPayload;

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
          encryptedJson: credentialModel.data,
          selectiveDisclosure: selectiveDisclosure,
        );

        payload = const JsonEncoder.withIndent('  ')
            .convert(Map.of(data)..removeWhere((key, value) => key == 'jwt'));

        final probableJwt = credentialModel.jwt?.split('~').last;
        kbHeader = 'None';
        kbPayload = 'None';

        if (probableJwt != null &&
            probableJwt.isNotEmpty &&
            probableJwt.startsWith('e')) {
          try {
            final header = jwtDecode.parseJwtHeader(probableJwt);
            kbHeader = const JsonEncoder.withIndent('  ').convert(header);
          } catch (e) {
            kbHeader = 'None';
          }

          try {
            final payload = jwtDecode.parseJwt(probableJwt);
            kbPayload = const JsonEncoder.withIndent('  ').convert(payload);
          } catch (e) {
            kbPayload = 'None';
          }
        }
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
        // CredentialField(
        //   padding: const EdgeInsets.only(top: 10),
        //   title: l10n.issuerDID,
        //   value: issuerDid,
        //   titleColor: titleColor,
        //   valueColor: valueColor,
        //   showVertically: showVertically,
        // ),
        // if (credentialModel.credentialPreview.credentialSubjectModel
        //         is! WalletCredentialModel &&
        //     subjectDid.isNotEmpty)
        //   CredentialField(
        //     padding: const EdgeInsets.only(top: 10),
        //     title: l10n.subjectDID,
        //     value: subjectDid,
        //     titleColor: titleColor,
        //     valueColor: valueColor,
        //     showVertically: showVertically,
        //   ),
        // CredentialField(
        //   padding: const EdgeInsets.only(top: 10),
        //   title: l10n.type,
        //   value: type,
        //   titleColor: titleColor,
        //   valueColor: valueColor,
        //   showVertically: showVertically,
        // ),
        // if (statusListUri != null)
        //   CredentialField(
        //     padding: const EdgeInsets.only(top: 10),
        //     title: l10n.statusList,
        //     value: statusListUri.toString(),
        //     titleColor: titleColor,
        //     valueColor: valueColor,
        //     showVertically: false,
        //   ),
        // if (statusListIndex != null)
        //   CredentialField(
        //     padding: const EdgeInsets.only(top: 10),
        //     title: l10n.statusListIndex,
        //     value: statusListIndex.toString(),
        //     titleColor: titleColor,
        //     valueColor: valueColor,
        //     showVertically: false,
        //   ),
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
        if (kbHeader != null)
          CredentialField(
            padding: const EdgeInsets.only(top: 10),
            title: l10n.keyBindingHeader,
            value: kbHeader,
            titleColor: titleColor,
            valueColor: valueColor,
            showVertically: showVertically,
          ),
        if (kbPayload != null)
          CredentialField(
            padding: const EdgeInsets.only(top: 10),
            title: l10n.keyBindingPayload,
            value: kbPayload,
            titleColor: titleColor,
            valueColor: valueColor,
            showVertically: showVertically,
          ),
      ],
    );
  }
}
