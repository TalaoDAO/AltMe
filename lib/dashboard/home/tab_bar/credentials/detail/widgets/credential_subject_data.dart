import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/app/shared/helper_functions/get_display.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/lang/cubit/lang_cubit.dart';
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

        if (value.containsKey('display')) {
          final display = getDisplay(value, languageCode);
          if (display == null) return Container();

          if (credentialSubjectData.containsKey(key)) {
            title = display['name'].toString();
            data = credentialSubjectData[key] is Map
                ? const JsonEncoder.withIndent('     ')
                    .convert(credentialSubjectData[key])
                : credentialSubjectData[key].toString();
          }
        } else {
          if (credentialSubjectData[key] != null) {
            title = null;
            data = credentialSubjectData[key] is Map
                ? const JsonEncoder.withIndent('     ')
                    .convert(credentialSubjectData[key])
                : credentialSubjectData[key].toString();
          } else {
            return Container();
          }
        }

        if (data == null) return Container();

        final widget = DisplayCredentialField(
          title: title,
          data: data,
          type: value['value_type'].toString(),
          showVertically: showVertically,
        );

        return widget;
      }).toList(),
    );
  }
}

class DisplayCredentialField extends StatelessWidget {
  const DisplayCredentialField({
    super.key,
    this.title,
    required this.data,
    this.type = 'string',
    required this.showVertically,
  });
  final String? title;
  final dynamic data;
  final String type;
  final bool showVertically;

  @override
  Widget build(BuildContext context) {
    late Widget widget;
    try {
      final json = jsonDecode(data.toString());
      if (json is Map<String, dynamic>) {
        widget = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title ?? '',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: DisplayCredentialFieldMap(
                showVertically: showVertically,
                data: data,
                type: type,
              ),
            ),
          ],
        );
      }
    } catch (e) {
      widget = CredentialField(
        padding: const EdgeInsets.only(top: 10),
        title: title,
        value: data.toString(),
        titleColor: Theme.of(context).colorScheme.onSurface,
        valueColor: Theme.of(context).colorScheme.onSurface,
        showVertically: showVertically,
        type: type,
      );
    }

    return CredentialField(
      padding: const EdgeInsets.only(top: 10),
      title: title,
      value: data.toString(),
      titleColor: Theme.of(context).colorScheme.onSurface,
      valueColor: Theme.of(context).colorScheme.onSurface,
      showVertically: showVertically,
      type: type,
    );
  }

  Widget DisplayCredentialFieldMap(
      {required bool showVertically, required data, required String type}) {
    return Text('DisplayCredentialFieldMap');
  }
}
