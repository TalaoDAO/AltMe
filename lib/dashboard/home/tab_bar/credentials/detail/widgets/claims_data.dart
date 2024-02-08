import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class ClaimsData extends StatelessWidget {
  const ClaimsData({
    super.key,
    required this.credentialModel,
  });

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    final claims = credentialModel.claims;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: claims!.entries.map((MapEntry<String, dynamic> map) {
        final key = map.key;
        final value = map.value;

        String title = key;
        String data = value.toString();

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
          if (displays.length < 2) return Container();

          for (final display in displays) {
            if (display is! Map<String, dynamic>) return Container();

            if (display['name'] == null) return Container();
          }

          title = displays[0]['name'].toString();
          data = displays[1]['name'].toString();
        } else {
          return Container();
        }

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
