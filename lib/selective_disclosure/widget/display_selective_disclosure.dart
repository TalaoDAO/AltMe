import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/lang/cubit/lang_cubit.dart';
import 'package:altme/selective_disclosure/helper_functions/selective_disclosure_display_map.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DisplaySelectiveDisclosure extends StatelessWidget {
  const DisplaySelectiveDisclosure({
    super.key,
    required this.credentialModel,
    required this.showVertically,
    this.claims,
    this.onPressed,
    this.selectiveDisclosureState,
    this.parentKeyId,
  });

  final CredentialModel credentialModel;
  final bool showVertically;
  final Map<String, dynamic>? claims;
  final void Function(String?, String, String?)? onPressed;
  final SelectiveDisclosureState? selectiveDisclosureState;
  final String? parentKeyId;

  @override
  Widget build(BuildContext context) {
    final languageCode = context.read<LangCubit>().state.locale.languageCode;
    final limitDisclosure = selectiveDisclosureState?.limitDisclosure ?? '';
    final filters = selectiveDisclosureState?.filters ?? {};

    final mapToDisplay = SelectiveDisclosureDisplayMap(
      credentialModel: credentialModel,
      claims: claims,
      isPresentation: selectiveDisclosureState != null,
      languageCode: languageCode,
      limitDisclosure: limitDisclosure,
      filters: filters,
      isDeveloperMode: context.read<ProfileCubit>().state.model.isDeveloperMode,
    ).buildMap;

    final List<Widget> listOfClaims =
        mapToDisplay.entries.map((MapEntry<String, dynamic> map) {
      return DisplaySelectiveDisclosureValue(
        disclosure: {
          map.key: map.value,
        },
      );
    }).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: listOfClaims,
    );
  }
}

class DisplaySelectiveDisclosureValue extends StatelessWidget {
  const DisplaySelectiveDisclosureValue({
    super.key,
    required this.disclosure,
  });
  final Map<String, dynamic> disclosure;
  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetList = [];
    for (final element in disclosure.entries) {
      if (element.value is Map<String, dynamic>) {
        if (element.value['value'] is Map<String, dynamic>) {
          widgetList.add(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(element.key),
                    const Spacer(),
                    const Text('Object'),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DisplaySelectiveDisclosureValue(
                    disclosure: element.value['value'] as Map<String, dynamic>,
                  ),
                ),
              ],
            ),
          );
          continue;
        }
        if (element.value['value'] is String) {
          widgetList.add(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(element.key),
                    const Spacer(),
                    const Text('String'),
                  ],
                ),
                Text(element.value['value'].toString()),
              ],
            ),
          );
          continue;
        }
        if (element.value['value'] == null) {
          widgetList.add(
            Column(
              children: [
                Row(
                  children: [
                    Text(element.key),
                    const Spacer(),
                    const Text('nested'),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DisplaySelectiveDisclosureValue(
                    disclosure: element.value as Map<String, dynamic>,
                  ),
                ),
              ],
            ),
          );
          continue;
        }
        if (element.value['value'] is List) {
          final List<Widget> nestedList = [];
          for (final nestedListElement in element.value['value'] as List) {
            nestedList.add(
              Row(
                children: [
                  Text(nestedListElement['value'].toString()),
                  const Spacer(),
                  const Text('nested List element'),
                ],
              ),
            );
          }
          widgetList.add(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(element.key),
                    const Spacer(),
                    const Text('nested List'),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: nestedList,
                  ),
                ),
              ],
            ),
          );
          continue;
        }
        widgetList.add(Text('Nt found 1: ${element.value}'));
      }
      if (element.value is String ||
          element.value is num ||
          element.value is bool) {
        widgetList.add(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(element.key),
                  const Spacer(),
                  const Text('String from json'),
                ],
              ),
              Text(element.value.toString()),
            ],
          ),
        );
        continue;
      }

      widgetList.add(Text('Nt found 2'));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgetList,
    );
  }
}
