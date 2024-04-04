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
    required this.showVertically,
  });

  final CredentialModel credentialModel;
  final bool showVertically;

  @override
  Widget build(BuildContext context) {
    final credentialSupported = credentialModel.credentialSupported;

    var credentialSubjectReference = JsonPath(r'$..credentialSubject')
        .read(credentialSupported)
        .firstOrNull
        ?.value;

    if (credentialSubjectReference == null) return Container();
    if (credentialSubjectReference is! Map<String, dynamic>) return Container();

    if (credentialSupported == null) return Container();

    final credentialDefinition = credentialSupported['credential_definition'];

    if (credentialDefinition != null &&
        credentialDefinition is Map<String, dynamic> &&
        credentialDefinition.containsKey('order')) {
      final order = credentialDefinition['order'];

      if (order != null && order is List<dynamic>) {
        final orderList = order.map((dynamic e) => e.toString()).toList();

        final orderedData = <String, dynamic>{};
        final remainingData = <String, dynamic>{};

        // Order elements based on the order list
        for (final key in orderList) {
          if (credentialSubjectReference.containsKey(key)) {
            orderedData[key] = credentialSubjectReference[key];
          }
        }

        // Add remaining elements to the end of the ordered map
        credentialSubjectReference.forEach((key, value) {
          if (!orderedData.containsKey(key)) {
            remainingData[key] = value;
          }
        });

        orderedData.addAll(remainingData);
        credentialSubjectReference = orderedData;
      }
    }

    final credentialSubjectData = credentialModel.data['credentialSubject'];

    if (credentialSubjectData == null) return Container();
    if (credentialSubjectData is! Map<String, dynamic>) return Container();

    final languageCode = context.read<LangCubit>().state.locale.languageCode;

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

        if (value.containsKey('display')) {
          final displays = value['display'];
          if (displays is! List<dynamic>) return Container();

          final display = displays.firstWhere(
            (element) =>
                element is Map<String, dynamic> &&
                element.containsKey('locale') &&
                element['locale'].toString().contains(languageCode),
            orElse: () => displays.firstWhere(
              (element) =>
                  element is Map<String, dynamic> &&
                  element.containsKey('locale') &&
                  element['locale'].toString().contains('en'),
              orElse: () => displays.firstWhere(
                (element) =>
                    element is Map<String, dynamic> &&
                    element.containsKey('locale'),
                orElse: () => null,
              ),
            ),
          );

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
            showVertically: showVertically,
          ),
        );
      }).toList(),
    );
  }
}
