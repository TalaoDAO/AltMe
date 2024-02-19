import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/lang/cubit/lang_cubit.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_path/json_path.dart';

class CredentialSubjectData extends StatelessWidget {
  const CredentialSubjectData({
    super.key,
    required this.credentialModel,
  });

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    final credentialSupported = credentialModel.credentialSupported;

    final credentialSubjectReference = JsonPath(r'$..credentialSubject')
        .read(credentialSupported)
        .firstOrNull
        ?.value;

    if (credentialSubjectReference == null) return Container();
    if (credentialSubjectReference is! Map<String, dynamic>) return Container();

    final credentialSubjectData = credentialModel.data['credentialSubject'];

    if (credentialSubjectData == null) return Container();
    if (credentialSubjectData is! Map<String, dynamic>) return Container();

    final languageCode = context.read<LangCubit>().state.languageCode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: credentialSubjectReference.entries
          .map((MapEntry<String, dynamic> map) {
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

          if (credentialSubjectData.containsKey(key)) {
            title = display['name'].toString();
            data = credentialSubjectData[key].toString();
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
