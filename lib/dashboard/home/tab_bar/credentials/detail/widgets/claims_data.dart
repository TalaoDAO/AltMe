import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/lang/cubit/lang_cubit.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClaimsData extends StatelessWidget {
  const ClaimsData({
    super.key,
    required this.credentialModel,
  });

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    final credentialSupported = credentialModel.credentialSupported;

    final claims = credentialSupported!['claims'];

    if (claims is! Map<String, dynamic>) {
      return Container();
    }

    final encryptedDatas = credentialModel.jwt?.split('~');

    final credentialSubjectData = <String, dynamic>{};

    if (encryptedDatas != null) {
      encryptedDatas.removeAt(0);

      for (var element in encryptedDatas) {
        try {
          while (element.length % 4 != 0) {
            element += '=';
          }

          final decryptedData = utf8.decode(base64Decode(element));

          if (decryptedData.isNotEmpty) {
            final lisString = decryptedData
                .substring(1, decryptedData.length - 1)
                .replaceAll('"', '')
                .split(',');

            if (lisString.length == 3) {
              credentialSubjectData[lisString[1].trim()] = lisString[2].trim();
            }
          }
        } catch (e) {
          //
        }
      }
    }

    final languageCode = context.read<LangCubit>().state.languageCode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: claims.entries.map((MapEntry<String, dynamic> map) {
        String? title;
        String? data;

        final key = map.key;
        final value = map.value;

        if (value is! Map<String, dynamic>) return Container();

        if (value.isEmpty) return Container();

        if (value.containsKey('mandatory')) {
          final mandatory = value['mandatory'];
          if (mandatory is! bool) return Container();

          if (!mandatory) return Container();
        }

        if (value.containsKey('display')) {
          final displays = value['display'];
          if (displays is! List<dynamic>) return Container();
          if (displays.isEmpty) return Container();

          final display = displays.where((element) {
            if (element is Map<String, dynamic> &&
                element.containsKey('locale')) {
              if (element['locale'].toString().contains(languageCode)) {
                return true;
              } else if (element['locale'] == 'en-US') {
                return true;
              }
            }
            return false;
          }).firstOrNull;

          if (display == null) return Container();

          if (credentialSubjectData.isNotEmpty &&
              credentialSubjectData.containsKey(key)) {
            title = display['name'].toString();
            data = credentialSubjectData[key].toString();
          } else if (credentialModel.data.containsKey(key)) {
            title = display['name'].toString();
            data = credentialModel.data[key].toString();
          }
        } else {
          return Container();
        }

        if (title == null || data == null) return Container();

        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: CredentialField(
            padding: EdgeInsets.zero,
            title: title,
            value: data,
            titleColor: Theme.of(context).colorScheme.titleColor,
            valueColor: Theme.of(context).colorScheme.valueColor,
          ),
        );
      }).toList(),
    );
  }
}
