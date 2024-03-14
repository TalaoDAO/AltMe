import 'package:altme/app/shared/widget/base/credential_field.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/credential_model/credential_model.dart';
import 'package:altme/lang/cubit/lang_cubit.dart';
import 'package:altme/selective_disclosure/selective_disclosure.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_path/json_path.dart';

class DisplaySelectiveDisclosure extends StatelessWidget {
  const DisplaySelectiveDisclosure({
    super.key,
    required this.credentialModel,
    this.claims,
  });
  final CredentialModel credentialModel;
  final Map<String, dynamic>? claims;
  @override
  Widget build(BuildContext context) {
    final selectiveDisclosure = SelectiveDisclosure(credentialModel);
    final currentClaims = claims ?? selectiveDisclosure.claims;
    final languageCode = context.read<LangCubit>().state.locale.languageCode;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: currentClaims.entries.map((MapEntry<String, dynamic> map) {
        String? title;
        String? data;

        final key = map.key;
        final value = map.value;

        final bool hasChildren =
            !(value as Map<String, dynamic>).containsKey('display');
        if (hasChildren && value.isNotEmpty) {
          return Padding(
            padding: const EdgeInsets.only(top: 10, left: 10),
            child: DisplaySelectiveDisclosure(
              credentialModel: credentialModel,
              claims: value,
            ),
          );
        } else {
          final display = getDisplay(key, value, languageCode);

          if (display == null) return Container();
          title = display['name'].toString();
          data = getData(selectiveDisclosure.values, credentialModel, key);

          if (data == null) return Container();

          return displayCredentialField(title, data, context);
        }
      }).toList(),
    );
  }

  Widget displayCredentialField(
    String title,
    String data,
    BuildContext context,
  ) {
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
  }

  dynamic getDisplay(String key, dynamic value, String languageCode) {
    if (value is! Map<String, dynamic>) return null;

    if (value.isEmpty) return null;

    if (value.containsKey('mandatory')) {
      final mandatory = value['mandatory'];
      if (mandatory is! bool) return null;

      // if (!mandatory) return null;
    }

    if (value.containsKey('display')) {
      final displays = value['display'];
      if (displays is! List<dynamic>) return null;
      if (displays.isEmpty) return null;

      final displaySelectedLanguage = displays.where((element) {
        if (element is Map<String, dynamic> && element.containsKey('locale')) {
          if (element['locale'].toString().contains(languageCode)) {
            return true;
          }
          return false;
        }
        return false;
      }).firstOrNull;

      final displayEnglish = displays.where((element) {
        if (element is Map<String, dynamic> && element.containsKey('locale')) {
          if (element['locale'].toString().contains('en')) {
            return true;
          }
          return false;
        }
        return false;
      }).firstOrNull;

      final displayFirst = displays.where((element) {
        if (element is Map<String, dynamic> && element.containsKey('locale')) {
          return true;
        }
        return false;
      }).firstOrNull;

      return displaySelectedLanguage ?? displayEnglish ?? displayFirst;
    } else {
      return null;
    }
  }

  String? getData(
    Map<String, dynamic> uncryptedDatas,
    CredentialModel credentialModel,
    String key,
  ) {
    String? data;

    final JsonPath dataPath = JsonPath(
      // ignore: prefer_interpolation_to_compose_strings
      r'$..' + key,
    );

    try {
      final uncryptedDataPath = dataPath.read(uncryptedDatas).first;
      data = uncryptedDataPath.value.toString();
    } catch (e) {
      try {
        final credentialModelPath = dataPath.read(credentialModel.data).first;
        data = credentialModelPath.value.toString();
      } catch (e) {
        data = null;
      }
    }

    return data;
  }
}
