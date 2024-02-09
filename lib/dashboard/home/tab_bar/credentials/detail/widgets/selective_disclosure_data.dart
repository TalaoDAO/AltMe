import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class SelectiveDisclosureData extends StatelessWidget {
  const SelectiveDisclosureData({
    super.key,
    required this.credentialModel,
  });

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    final encryptedDatas = credentialModel.jwt!.split('~');
    encryptedDatas.removeAt(0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: encryptedDatas.map((dynamic element) {
        dynamic decryptedData;

        try {
          decryptedData = utf8.decode(base64Decode(element.toString()));
        } catch (e) {
          return Container();
        }

        if (decryptedData.toString().isEmpty) return Container();

        final lisString = decryptedData
            .toString()
            .substring(1, decryptedData.toString().length - 1)
            .replaceAll('"', '')
            .split(',');

        if (lisString.length < 3) {
          return Container();
        }

        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: CredentialField(
            padding: EdgeInsets.zero,
            title: lisString[1].beautityTitle,
            value: lisString[2],
            titleColor: Theme.of(context).colorScheme.titleColor,
            valueColor: Theme.of(context).colorScheme.valueColor,
          ),
        );
      }).toList(),
    );
  }
}
